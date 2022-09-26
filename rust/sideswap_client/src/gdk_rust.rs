use std::{collections::BTreeMap, str::FromStr};

use crate::{
    envs, ffi, gdk_json, gdk_ses, models, swaps,
    worker::{self, AccountId, PegPayment, ACCOUNT_ID_REG},
};
use bitcoin::hashes::hex::ToHex;
use gdk_common::model::GetPreviousAddressesOpt;
use gdk_electrum::ElectrumSession;
use sideswap_api::{AssetId, Hash32, Txid};

struct GdkSesRust {
    login_info: gdk_ses::LoginInfo,

    session: ElectrumSession,
    send_tx: Option<SendTx>,
}

const ACCOUNT: u32 = 0;

struct NotifContext {
    account_id: AccountId,
    worker: crossbeam_channel::Sender<worker::Message>,
}

struct SendTx {
    tx_signed: gdk_common::model::TransactionMeta,
}

fn get_blinded_value(unblinded: &elements::TxOutSecrets) -> String {
    [
        unblinded.value.to_string(),
        unblinded.asset.to_string(),
        unblinded.value_bf.to_string(),
        unblinded.asset_bf.to_string(),
    ]
    .join(",")
}

fn reversed(mut v: Vec<u8>) -> Vec<u8> {
    v.reverse();
    v
}

fn convert_input_output(
    item: &gdk_common::model::GetTxInOut,
    is_input: bool,
) -> Option<models::Balance> {
    let asset_id = item
        .asset_id
        .as_ref()
        .map(|asset_id| AssetId::from_slice(&reversed(hex::decode(&asset_id).unwrap())).unwrap());

    let value = if is_input {
        Some(-(item.satoshi as i64))
    } else {
        Some(item.satoshi as i64)
    };

    match (item.is_relevant, asset_id, value) {
        (true, Some(asset), Some(value)) if value != 0 => Some(models::Balance { asset, value }),
        _ => None,
    }
}

fn get_tx_item(tx: &gdk_common::model::TxListItem) -> models::Transaction {
    let created_at = tx.created_at_ts as i64 / 1000;
    let balances = tx
        .satoshi
        .iter()
        .map(|(asset_id, balance)| models::Balance {
            asset: sideswap_api::AssetId::from_str(&asset_id).unwrap(),
            value: *balance,
        })
        .collect::<Vec<_>>();

    let balances_all = tx
        .inputs
        .iter()
        .map(|input| convert_input_output(input, true))
        .chain(
            tx.outputs
                .iter()
                .map(|output| convert_input_output(output, false)),
        )
        .flatten()
        .collect();

    let tx_item = models::Transaction {
        txid: sideswap_api::Txid::from_str(&tx.txhash).unwrap(),
        network_fee: tx.fee as u32,
        size: tx.transaction_size as u32,
        vsize: tx.transaction_vsize as u32,
        memo: tx.memo.clone(),
        balances,
        created_at,
        block_height: tx.block_height,
        balances_all,
    };
    tx_item
}

impl crate::gdk_ses::GdkSes for GdkSesRust {
    fn login(&mut self) -> Result<(), anyhow::Error> {
        let mnemonic = self.login_info.mnemonic.clone().unwrap();

        let _login_data = self.session.login(gdk_common::model::Credentials {
            mnemonic: mnemonic.to_owned(),
            bip39_passphrase: String::new(),
        })?;

        Ok(())
    }

    fn connect(&mut self) {}

    fn disconnect(&mut self) {}

    fn login_info(&self) -> &gdk_ses::LoginInfo {
        &self.login_info
    }

    fn get_gaid(&self) -> Result<String, anyhow::Error> {
        bail!("not available")
    }

    fn update_sync_interval(&self, time: u32) {
        self.session.sync_interval.store(time);
    }

    fn get_balances(&self) -> Result<std::collections::BTreeMap<AssetId, i64>, anyhow::Error> {
        let balance_opts = gdk_common::model::GetBalanceOpt {
            subaccount: ACCOUNT,
            num_confs: 0,
            confidential_utxos_only: None,
        };
        Ok(self
            .session
            .get_balance(&balance_opts)?
            .into_iter()
            .map(|(asset_id, balance)| (AssetId::from_str(&asset_id).unwrap(), balance))
            .collect::<BTreeMap<_, _>>())
    }

    fn get_transactions(&self) -> Result<Vec<crate::models::Transaction>, anyhow::Error> {
        let opt = gdk_common::model::GetTransactionsOpt {
            first: 0,
            count: usize::MAX,
            subaccount: ACCOUNT,
            num_confs: None,
        };
        let txs = self.session.get_transactions(&opt)?.0;
        let txs = txs.iter().map(|tx| get_tx_item(tx)).collect::<Vec<_>>();
        Ok(txs)
    }

    fn get_recv_address(&self) -> Result<String, anyhow::Error> {
        Ok(self
            .session
            .get_receive_address(&gdk_common::model::GetAddressOpt {
                subaccount: ACCOUNT,
                address_type: None,
                is_internal: Some(false),
            })?
            .address)
    }

    fn create_tx(
        &mut self,
        req: ffi::proto::CreateTx,
    ) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
        let liquid_asset_id = AssetId::from_str(self.login_info.env.data().policy_asset).unwrap();
        let send_asset = AssetId::from_str(&req.balance.asset_id).unwrap();
        let send_amount = req.balance.amount;
        let amount = gdk_common::model::AddressAmount {
            address: req.addr.clone(),
            satoshi: req.balance.amount as u64,
            asset_id: Some(send_asset.to_string()),
        };
        let utxos = self
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(0),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("loading UTXO failed"))?
            .0;

        let bitcoin_balance = utxos
            .get(&liquid_asset_id.to_string())
            .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
            .unwrap_or_default() as i64;
        let balance = utxos
            .get(&send_asset.to_string())
            .map(|inputs| inputs.iter().map(|input| input.satoshi).sum::<u64>())
            .unwrap_or_default() as i64;

        let utxos = utxos
            .into_iter()
            .map(|(asset_id, utxos)| {
                (
                    asset_id,
                    utxos
                        .into_iter()
                        .map(|utxo| gdk_common::model::CreateTxUtxo {
                            txid: utxo.txhash,
                            vout: utxo.pt_idx,
                        })
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<std::collections::HashMap<_, _>>();
        ensure!(send_amount > 0, "invalid send amount");
        ensure!(balance >= send_amount, "Insufficient balance");
        ensure!(bitcoin_balance > 0, "Insufficient L-BTC to pay network fee");
        let send_all = balance == send_amount && send_asset == liquid_asset_id;
        let mut details = gdk_common::model::CreateTransaction {
            addressees: vec![amount],
            fee_rate: None,
            subaccount: ACCOUNT,
            send_all,
            previous_transaction: None,
            memo: None,
            utxos,
            num_confs: 0,
            confidential_utxos_only: false,
            utxo_strategy: gdk_common::model::UtxoStrategy::Default,
        };
        let tx_detail_unsigned = self
            .session
            .create_transaction(&mut details)
            .map_err(|e| anyhow!("{}", e))?;
        let network_fee = tx_detail_unsigned.fee as i64;
        ensure!(network_fee > 0, "network fee is 0");

        let tx_signed = self
            .session
            .sign_transaction(&tx_detail_unsigned)
            .map_err(|e| anyhow!("transaction sign failed: {}", e.to_string()))?;

        let addressees = &tx_signed
            .create_transaction
            .as_ref()
            .ok_or_else(|| anyhow!("create_transaction is not set"))?
            .addressees;
        let result = worker::get_created_tx(&req, &tx_signed.hex, addressees)?;

        self.send_tx = Some(SendTx { tx_signed });

        Ok(result)
    }

    fn send_tx(&mut self) -> Result<sideswap_api::Txid, anyhow::Error> {
        let send_tx = self.send_tx.take().ok_or(anyhow!("no transaction found"))?;
        let tx_detail_signed = send_tx.tx_signed;
        let txid = sideswap_api::Txid::from_str(&tx_detail_signed.txid).unwrap();

        self.session
            .send_transaction(&tx_detail_signed)
            .map_err(|e| anyhow!("send failed: {}", e.to_string()))?;
        Ok(txid)
    }

    fn get_utxos(&self) -> Result<crate::ffi::proto::from::UtxoUpdate, anyhow::Error> {
        let balance_opts = gdk_common::model::GetUnspentOpt {
            subaccount: ACCOUNT,
            num_confs: Some(0),
            confidential_utxos_only: None,
            all_coins: None,
        };
        let utxos = self
            .session
            .get_unspent_outputs(&balance_opts)
            .map_err(|e| anyhow!("{}", e))?
            .0;
        let utxos = utxos
            .into_iter()
            .map(|(asset_id, utxos)| {
                utxos
                    .into_iter()
                    .map(move |utxo| ffi::proto::from::utxo_update::Utxo {
                        txid: utxo.txhash,
                        vout: utxo.pt_idx,
                        asset_id: asset_id.clone(),
                        amount: utxo.satoshi,
                    })
            })
            .flatten()
            .collect::<Vec<_>>();
        Ok(ffi::proto::from::UtxoUpdate {
            account: worker::get_account(ACCOUNT_ID_REG),
            utxos,
        })
    }

    fn get_tx_fee(
        &mut self,
        asset_id: sideswap_api::AssetId,
        send_amount: i64,
        addr: &str,
    ) -> Result<i64, anyhow::Error> {
        let balance = self.get_balance(&asset_id);
        ensure!(balance >= send_amount, "Insufficient balance");
        let send_all = balance == send_amount;

        let address_amount = gdk_common::model::AddressAmount {
            address: addr.to_owned(),
            satoshi: send_amount as u64,
            asset_id: Some(asset_id.to_string()),
        };

        let utxos = self
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(0),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("loading UTXO failed"))?
            .0
            .into_iter()
            .map(|(asset_id, utxos)| {
                (
                    asset_id,
                    utxos
                        .into_iter()
                        .map(|utxo| gdk_common::model::CreateTxUtxo {
                            txid: utxo.txhash,
                            vout: utxo.pt_idx,
                        })
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<std::collections::HashMap<_, _>>();

        let mut details = gdk_common::model::CreateTransaction {
            addressees: vec![address_amount],
            fee_rate: None,
            subaccount: ACCOUNT,
            send_all,
            previous_transaction: None,
            memo: None,
            utxos,
            num_confs: 0,
            confidential_utxos_only: false,
            utxo_strategy: gdk_common::model::UtxoStrategy::Default,
        };
        let tx_detail_unsigned = self
            .session
            .create_transaction(&mut details)
            .map_err(|e| anyhow!("{}", e))?;
        Ok(tx_detail_unsigned.fee as i64)
    }

    fn make_pegout_payment(
        &mut self,
        send_amount: i64,
        peg_addr: &str,
        send_amount_exact: i64,
    ) -> Result<crate::worker::PegPayment, anyhow::Error> {
        let liquid_asset_id = AssetId::from_str(self.login_info.env.data().policy_asset).unwrap();
        let balance = self.get_balance(&liquid_asset_id);
        ensure!(balance >= send_amount, "Insufficient balance");
        let send_all = balance == send_amount;

        let address_amount = gdk_common::model::AddressAmount {
            address: peg_addr.to_owned(),
            satoshi: send_amount as u64,
            asset_id: Some(liquid_asset_id.to_string()),
        };

        let utxos = self
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(0),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("loading UTXO failed"))?
            .0
            .into_iter()
            .map(|(asset_id, utxos)| {
                (
                    asset_id,
                    utxos
                        .into_iter()
                        .map(|utxo| gdk_common::model::CreateTxUtxo {
                            txid: utxo.txhash,
                            vout: utxo.pt_idx,
                        })
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<std::collections::HashMap<_, _>>();

        let mut details = gdk_common::model::CreateTransaction {
            addressees: vec![address_amount],
            fee_rate: None,
            subaccount: ACCOUNT,
            send_all,
            previous_transaction: None,
            memo: None,
            utxos,
            num_confs: 0,
            confidential_utxos_only: false,
            utxo_strategy: gdk_common::model::UtxoStrategy::Default,
        };
        let tx_detail_unsigned = self
            .session
            .create_transaction(&mut details)
            .map_err(|e| anyhow!("{}", e))?;
        let sent_amount = if send_all {
            send_amount - tx_detail_unsigned.fee as i64
        } else {
            send_amount
        };
        ensure!(send_amount_exact == sent_amount);
        let tx_detail_signed = self.session.sign_transaction(&tx_detail_unsigned).unwrap();
        let sent_txid = match self.session.send_transaction(&tx_detail_signed) {
            Ok(v) => sideswap_api::Txid::from_str(&v.txid).unwrap(),
            Err(e) => bail!("broadcast failed: {}", e.to_string()),
        };
        let payment = PegPayment {
            sent_amount,
            sent_txid,
            signed_tx: tx_detail_signed.hex,
        };
        Ok(payment)
    }

    fn get_blinded_values(&self, txid: &str) -> Result<Vec<String>, anyhow::Error> {
        let txid = gdk_common::be::BETxid::Elements(elements::Txid::from_str(txid)?);
        let store = self.session.store.as_ref().unwrap().read().unwrap();
        let tx = store
            .cache
            .accounts
            .get(&ACCOUNT)
            .unwrap()
            .all_txs
            .get(&txid)
            .ok_or(anyhow!("not found"))?;
        let tx = match &tx.tx {
            gdk_common::be::BETransaction::Bitcoin(_) => bail!("unexpected tx type"),
            gdk_common::be::BETransaction::Elements(v) => v,
        };
        let mut out_points = tx
            .input
            .iter()
            .map(|v| v.previous_output.clone())
            .collect::<Vec<_>>();
        for vout in 0..tx.output.len() {
            out_points.push(elements::OutPoint {
                txid: tx.txid(),
                vout: vout as u32,
            });
        }
        let result: Vec<String> = out_points
            .iter()
            .flat_map(|out_point| {
                store
                    .cache
                    .accounts
                    .get(&ACCOUNT)
                    .unwrap()
                    .unblinded
                    .get(out_point)
                    .map(get_blinded_value)
            })
            .collect();
        Ok(result)
    }

    fn get_previous_addresses(
        &self,
        last_pointer: Option<u32>,
        is_internal: bool,
    ) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
        // TODO: Return extra addresses in advance
        let prev_addr = self
            .session
            .get_previous_addresses(&GetPreviousAddressesOpt {
                subaccount: ACCOUNT,
                last_pointer,
                is_internal,
                count: 100,
            })?;
        let list = prev_addr
            .list
            .into_iter()
            .map(|addr| gdk_json::PreviousAddress {
                address: addr.address,
                pointer: addr.pointer,
            })
            .collect();
        Ok(gdk_json::PreviousAddresses {
            last_pointer: prev_addr.last_pointer,
            list,
        })
    }

    fn get_swap_inputs(
        &self,
        send_asset: &sideswap_api::AssetId,
    ) -> Result<Vec<sideswap_api::PsetInput>, anyhow::Error> {
        let mut all_utxos = self
            .session
            .get_unspent_outputs(&gdk_common::model::GetUnspentOpt {
                subaccount: ACCOUNT,
                num_confs: Some(0),
                confidential_utxos_only: None,
                all_coins: None,
            })
            .map_err(|_| anyhow!("getting unspent outputs failed"))?;
        let all_asset_utxos = all_utxos
            .0
            .remove(&send_asset.to_string())
            .unwrap_or_default();

        let mut inputs = Vec::new();
        for utxo in all_asset_utxos {
            let public_key = bitcoin::PublicKey::from_str(&utxo.public_key).unwrap();
            let asset_bf = Hash32::from_str(
                &utxo
                    .asset_blinder
                    .as_ref()
                    .ok_or_else(|| anyhow!("asset_blinder is not set"))?,
            )
            .unwrap();
            let value_bf = Hash32::from_str(
                &utxo
                    .amount_blinder
                    .as_ref()
                    .ok_or_else(|| anyhow!("amount_blinder is not set"))?,
            )
            .unwrap();
            let redeem_script = sideswap_common::pset::p2shwpkh_redeem_script(&public_key).to_hex();

            inputs.push(sideswap_api::PsetInput {
                txid: Txid::from_str(&utxo.txhash).unwrap(),
                vout: utxo.pt_idx,
                asset: send_asset.clone(),
                asset_bf,
                value: utxo.satoshi,
                value_bf,
                redeem_script: Some(redeem_script.to_string()),
            });
        }

        Ok(inputs)
    }

    fn sig_single_maker_tx(
        &self,
        input: &crate::swaps::SigSingleInput,
        output: &crate::swaps::SigSingleOutput,
    ) -> Result<crate::swaps::SigSingleMaker, anyhow::Error> {
        let accounts = self.session.accounts.read().unwrap();
        let account = accounts.get(&ACCOUNT).unwrap();
        crate::swaps::sig_single_maker_tx(account, &input, &output)
    }

    fn verify_and_sign_pset(
        &self,
        amounts: &crate::swaps::Amounts,
        pset: &str,
        _nonces: &[String],
    ) -> Result<String, anyhow::Error> {
        let accounts = self.session.accounts.read().unwrap();
        let account = accounts.get(&ACCOUNT).unwrap();
        let blinded_pset = elements::encode::deserialize::<
            elements::pset::PartiallySignedTransaction,
        >(&base64::decode(&pset)?)?;
        let signed_pset = swaps::verify_and_sign_pset(account, &amounts, &blinded_pset)?;
        Ok(base64::encode(elements::encode::serialize(&signed_pset)))
    }

    fn set_memo(&mut self, txid: &str, memo: &str) -> Result<(), anyhow::Error> {
        self.session.set_transaction_memo(&txid.to_string(), memo)?;
        Ok(())
    }
}

impl Drop for GdkSesRust {
    fn drop(&mut self) {
        if let Err(e) = self.session.disconnect() {
            error!("disconnect failed: {}", e);
        }
    }
}

extern "C" fn notification_callback_rust(context: *const libc::c_void, json: *const libc::c_char) {
    let context = unsafe { &*(context as *const NotifContext) };
    let json = unsafe { std::ffi::CStr::from_ptr(json) };
    let json = json.to_str().unwrap();
    debug!("new notification from {}: {}", context.account_id, json);
    let details = serde_json::from_str(json).unwrap();
    let result = context
        .worker
        .send(worker::Message::Notif(context.account_id, details));
    if let Err(e) = result {
        error!("sending notification message failed: {}", e);
    }
}

pub fn start_processing(info: gdk_ses::LoginInfo) -> Box<dyn crate::gdk_ses::GdkSes> {
    let parsed_network = envs::get_network(info.env, info.cache_dir.clone());
    let url = match &info.network {
        ffi::proto::network_settings::Selected::Sideswap(_)
            if info.env.data().network == sideswap_common::env::Network::Mainnet =>
        {
            gdk_electrum::interface::ElectrumUrl::Tls("electrs.sideswap.io:12001".to_owned(), true)
        }
        ffi::proto::network_settings::Selected::Sideswap(_)
            if info.env.data().network == sideswap_common::env::Network::Testnet =>
        {
            gdk_electrum::interface::ElectrumUrl::Tls("electrs.sideswap.io:12002".to_owned(), true)
        }
        ffi::proto::network_settings::Selected::Sideswap(_) => {
            gdk_electrum::determine_electrum_url(&parsed_network).unwrap()
        }
        ffi::proto::network_settings::Selected::Blockstream(_) => {
            gdk_electrum::determine_electrum_url(&parsed_network).unwrap()
        }
        ffi::proto::network_settings::Selected::Custom(custom) => {
            let url = format!("{}:{}", custom.host, custom.port);
            if custom.use_tls {
                gdk_electrum::interface::ElectrumUrl::Tls(url, true)
            } else {
                gdk_electrum::interface::ElectrumUrl::Plaintext(url)
            }
        }
    };

    let mut session = ElectrumSession::create_session(parsed_network, None, url);

    let notif_context = Box::new(NotifContext {
        account_id: info.account_id,
        worker: info.worker.clone(),
    });
    let notif_context = Box::into_raw(notif_context);

    session.notify = gdk_electrum::NativeNotif {
        native: Some((
            notification_callback_rust,
            notif_context as *const libc::c_void,
        )),
        testing: Default::default(),
    };

    session.connect(&serde_json::Value::Null).unwrap();

    let ses = GdkSesRust {
        login_info: info,
        session,
        send_tx: None,
    };
    Box::new(ses)
}
