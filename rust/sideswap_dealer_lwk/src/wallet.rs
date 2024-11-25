use std::{
    sync::mpsc::{Receiver, RecvTimeoutError},
    time::{Duration, Instant},
};

use elements::{
    bitcoin::bip32,
    confidential::{AssetBlindingFactor, ValueBlindingFactor},
};
use lwk_common::singlesig_desc;
use lwk_wollet::{
    elements_miniscript, secp256k1::SECP256K1, BlockchainBackend, ElementsNetwork, WolletDescriptor,
};
use sideswap_common::{channel_helpers::UncheckedUnboundedSender, network::Network};
use sideswap_dealer::utxo_data::{self, UtxoData, UtxoWithKey};
use tokio::sync::mpsc::UnboundedSender;

pub struct Params {
    pub network: Network,
    pub work_dir: String,
    pub mnemonic: bip39::Mnemonic,
}

pub enum Command {
    NewAdddress,
}

pub enum Event {
    Utxos { utxo_data: UtxoData },
    Address { address: elements::Address },
}

fn run(
    Params {
        network,
        work_dir: _work_dir,
        mnemonic,
    }: Params,
    command_receiver: Receiver<Command>,
    event_sender: UncheckedUnboundedSender<Event>,
) {
    let is_mainnet = match network {
        Network::Liquid => true,
        Network::LiquidTestnet => false,
    };

    let seed = mnemonic.to_seed("");
    let bitcoin_network = network.d().bitcoin_network;
    let master_key = bip32::Xpriv::new_master(bitcoin_network, &seed).unwrap();

    let signer =
        lwk_signer::SwSigner::new(&mnemonic.to_string(), is_mainnet).expect("must not fail");

    let descriptor = singlesig_desc(
        &signer,
        lwk_common::Singlesig::ShWpkh,
        lwk_common::DescriptorBlindingKey::Slip77,
        is_mainnet,
    )
    .expect("must not fail");

    let descriptor = descriptor
        .parse::<WolletDescriptor>()
        .expect("must not fail");

    let lwk_network = match network {
        Network::Liquid => ElementsNetwork::Liquid,
        Network::LiquidTestnet => ElementsNetwork::LiquidTestnet,
    };

    let mut wallet = lwk_wollet::Wollet::without_persist(lwk_network, descriptor.clone())
        .expect("must not fail");
    // let mut wallet =
    //     lwk_wollet::Wollet::with_fs_persist(lwk_network, descriptor.clone(), &work_dir)
    //         .expect("must not fail");

    let electrum_url = match network {
        Network::Liquid => "electrs.sideswap.io:12001",
        Network::LiquidTestnet => "electrs.sideswap.io:12002",
    };
    let electrum_url =
        lwk_wollet::ElectrumUrl::new(electrum_url, true, true).expect("must not fail");
    let mut electrum_client =
        lwk_wollet::ElectrumClient::new(&electrum_url).expect("must not fail");

    let mut utxo_data = UtxoData::new(utxo_data::Params {
        confifential_only: true,
    });

    'outer: loop {
        let update = electrum_client.full_scan(&wallet).expect("must not fail");
        if let Some(update) = update {
            wallet.apply_update(update).expect("must not fail");

            let utxos = wallet.utxos().expect("must not fail");

            let utxos_with_key = utxos
                .into_iter()
                .filter(|utxo| {
                    utxo.unblinded.asset_bf != AssetBlindingFactor::zero()
                        && utxo.unblinded.value_bf != ValueBlindingFactor::zero()
                })
                .map(|utxo| {
                    let utxo_desc = descriptor
                        .definite_descriptor(utxo.ext_int, utxo.wildcard_index)
                        .expect("must not fail");

                    let mut utxo_details = None;

                    use elements_miniscript::ForEachKey;
                    utxo_desc.for_each_key(|d| {
                        let full_path = d.full_derivation_path().expect("must be set");
                        let priv_key = master_key
                            .derive_priv(SECP256K1, &full_path)
                            .expect("must not fail")
                            .to_priv();
                        let pub_key = priv_key.public_key(&SECP256K1);
                        let redeem_script = sideswap_common::pset::p2shwpkh_redeem_script(&pub_key);

                        assert!(utxo_details.is_none());
                        utxo_details = Some((redeem_script, priv_key));

                        true
                    });

                    let (redeem_script, priv_key) = utxo_details.expect("must be set");

                    UtxoWithKey {
                        utxo: sideswap_api::Utxo {
                            txid: utxo.outpoint.txid,
                            vout: utxo.outpoint.vout,
                            asset: utxo.unblinded.asset,
                            asset_bf: utxo.unblinded.asset_bf,
                            value: utxo.unblinded.value,
                            value_bf: utxo.unblinded.value_bf,
                            redeem_script: Some(redeem_script),
                        },
                        priv_key,
                    }
                })
                .collect::<Vec<_>>();

            utxo_data.reset(utxos_with_key);

            event_sender.send(Event::Utxos {
                utxo_data: utxo_data.clone(),
            });
        }

        let deadline = Instant::now() + Duration::from_secs(1);

        loop {
            let timeout = deadline.saturating_duration_since(Instant::now());
            let res = command_receiver.recv_timeout(timeout);
            match res {
                Ok(command) => match command {
                    Command::NewAdddress => {
                        // FIXME: This returns same address, pass updated index
                        let res = wallet.address(None);
                        match res {
                            Ok(addr) => {
                                log::debug!("new address: {}", addr.address());
                                event_sender.send(Event::Address {
                                    address: addr.address().clone(),
                                });
                            }
                            Err(err) => {
                                log::error!("loading address failed: {err}");
                            }
                        }
                    }
                },

                Err(err) => match err {
                    RecvTimeoutError::Timeout => {
                        break;
                    }
                    RecvTimeoutError::Disconnected => {
                        log::debug!("stop wallet");
                        break 'outer;
                    }
                },
            }
        }
    }
}

pub fn start(
    params: Params,
    command_receiver: Receiver<Command>,
    event_sender: UnboundedSender<Event>,
) {
    std::thread::spawn(move || run(params, command_receiver, event_sender.into()));
}