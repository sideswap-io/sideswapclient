use std::collections::BTreeMap;

use anyhow::bail;
use sideswap_api::{Asset, AssetId};
use sideswap_jade::jade_mng;

use crate::{
    ffi,
    gdk_json::{self, AddressInfo},
    gdk_ses::{self, Balances, SignWith},
    gdk_ses_impl::CreatedTxCache,
};

struct GdkSesStub {
    login_info: gdk_ses::LoginInfo,
}

impl crate::gdk_ses::GdkSes for GdkSesStub {
    fn login(&mut self) -> Result<(), anyhow::Error> {
        Ok(())
    }

    fn register(&mut self) -> Result<(), anyhow::Error> {
        Ok(())
    }

    fn set_watch_only(&mut self, _username: &str, _password: &str) -> Result<(), anyhow::Error> {
        Ok(())
    }

    fn connect(&mut self) {}

    fn disconnect(&mut self) {}

    fn login_info(&self) -> &gdk_ses::LoginInfo {
        &self.login_info
    }

    fn get_gaid(&self) -> Result<String, anyhow::Error> {
        Ok("GAstub".to_owned())
    }

    fn get_balances(&self) -> Result<Balances, anyhow::Error> {
        Ok(Balances::new())
    }

    fn get_transactions_impl(&self) -> Result<Vec<gdk_json::Transaction>, anyhow::Error> {
        Ok(Vec::new())
    }

    fn get_receive_address(&self) -> Result<AddressInfo, anyhow::Error> {
        Ok(AddressInfo {
            address:
                "vjU4PTkGD4ejd2xwvAZ31jhHax8CTCUaMsUV8y2cjpnrvNRzVXp5JhJLXGx5q3NoFUqsCyac6ntvk6wL"
                    .parse()
                    .unwrap(),
            subaccount: 1,
            address_type: gdk_json::AddressType::P2wsh,
            pointer: 2,
            user_path: vec![
                2147483651,
                2147483649,
                1,
                2
              ],
            unconfidential_address: "91Qh5DgjZoo9C8ZtEQRVB3jzWr9QPZeWNP".parse().unwrap(),
            blinding_key: "0361180adaaee37c67de462964035494b85cde286b3d620b49691a753dc52e63b0"
                .to_owned(),
            is_confidential: true,
            scriptpubkey: "a914e63561bf97244dcff92881179fac7b847893441f87"
                .parse()
                .unwrap(),
            is_internal: None,
            public_key: None,
            script: Some("52210305b9d4acd4c6cd5a5a9eb5e9a4dcd74a7b962eb0109cab264ea7412d6901bfa42102945512944638fe25e24962866d19ec858fdc70dd5a68ae801d54b5c36231f2e652ae".parse().unwrap()),
            branch: Some(0),
            service_xpub: Some("tpubECMbgHMZm4QymM7WtpQonF5cU5x54M54QvLFsGjEY3HWx8YPxqZ7nq3PiaQSEjeDwCwpYr4heLC8N7kP74HYGKjoycutoZ4VACJmco16btA".parse().unwrap()),
            subtype: Some(0),
            tx_count: Some(0),
        })
    }

    fn get_change_address(&self) -> Result<AddressInfo, anyhow::Error> {
        bail!("get_change_address is not implemented")
    }

    fn create_tx(
        &mut self,
        _cache: &mut CreatedTxCache,
        _req: ffi::proto::CreateTx,
    ) -> Result<ffi::proto::CreatedTx, anyhow::Error> {
        bail!("create_tx is not implemented")
    }

    fn send_tx(
        &mut self,
        _cache: &mut CreatedTxCache,
        _id: &str,
        _assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<elements::Txid, anyhow::Error> {
        bail!("send_tx is not implemented")
    }

    fn broadcast_tx(&mut self, _tx: &str) -> Result<(), anyhow::Error> {
        Ok(())
    }

    fn get_utxos(&self) -> Result<gdk_json::UnspentOutputs, anyhow::Error> {
        bail!("get_utxos is not implemented")
    }

    fn get_blinded_values(&self, _txid: &elements::Txid) -> Result<Vec<String>, anyhow::Error> {
        Ok(Vec::new())
    }

    fn get_previous_addresses(
        &mut self,
        _last_pointer: Option<u32>,
        _is_internal: bool,
    ) -> Result<gdk_json::PreviousAddresses, anyhow::Error> {
        bail!("get_previous_addresses is not implemented")
    }

    fn verify_and_sign_pset(
        &mut self,
        _amounts: &crate::swaps::Amounts,
        _pset: &str,
        _nonces: &[String],
        _assets: &BTreeMap<AssetId, Asset>,
    ) -> Result<String, anyhow::Error> {
        bail!("verify_and_sign_pset is not implemented")
    }

    fn sign_pset(
        &mut self,
        _utxos: &gdk_json::UnspentOutputs,
        _pset: &str,
        _nonces: &[String],
        _assets: &BTreeMap<AssetId, Asset>,
        _tx_type: jade_mng::TxType,
        _sign_with: SignWith,
    ) -> Result<String, anyhow::Error> {
        bail!("sign_pset is not implemented")
    }

    fn set_memo(&mut self, _txid: &str, _memo: &str) -> Result<(), anyhow::Error> {
        Ok(())
    }
}

pub fn start_processing(login_info: gdk_ses::LoginInfo) -> Box<dyn crate::gdk_ses::GdkSes + Send> {
    let ses = GdkSesStub { login_info };
    Box::new(ses)
}

unsafe impl Send for GdkSesStub {}
