use serde::{Deserialize, Serialize};

pub const PROTOCOL_VERSION: u32 = 1;

#[derive(Serialize, Deserialize)]
pub enum Request {
    Login {
        work_dir: String,
        mnemonic: String,
        testnet: bool,
    },
    RecvAddress {},
}

#[derive(Serialize, Deserialize)]
pub enum Response {
    Protocol {
        version: u32,
    },
    RecvAddress {
        address: elements::Address,
    },
    AddressOutput {
        created_at: i64,
        txid: elements::Txid,
        vout: u32,
        address: elements::Address,
        asset_id: elements::AssetId,
        satoshi: u64,
    },
}
