use std::collections::BTreeSet;

use elements::{OutPoint, TxOutSecrets};
use serde::{Deserialize, Serialize};
use sideswap_types::timestamp_us::TimestampUs;

use super::*;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TransactionInput {
    pub prevtxid: elements::Txid,
    pub previdx: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TransactionOutput {
    pub pt_idx: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Transaction {
    pub txid: elements::Txid,
    pub created_at: TimestampUs,
    /// 0 for unconfirmed transactions
    pub block_height: u32,
    /// Amount is always non-zero
    pub amounts: BTreeMap<AssetId, i64>,
    pub network_fee: u64,
    pub inputs: Vec<TransactionInput>,
    pub outputs: Vec<TransactionOutput>,
}

#[derive(Default, Serialize, Deserialize)]
pub struct TxCache {
    txs: Vec<Transaction>,

    secrets: BTreeMap<OutPoint, TxOutSecrets>,

    assets: BTreeSet<AssetId>,
}

impl TxCache {
    pub fn new() -> Self {
        Self {
            txs: Vec::new(),
            secrets: BTreeMap::new(),
            assets: BTreeSet::new(),
        }
    }

    pub fn start_sync_timestamp(&self) -> TimestampUs {
        let mut top_block_height = 0;
        for tx in self.txs.iter().rev() {
            if tx.block_height != 0 && top_block_height == 0 {
                top_block_height = tx.block_height;
            }
            if top_block_height != 0 && tx.block_height < top_block_height {
                return tx.created_at;
            }
        }
        TimestampUs::from_micros(0)
    }

    pub fn update_latest_txs(&mut self, mut new_txs: Vec<Transaction>) {
        if new_txs.is_empty() {
            return;
        }

        let first_timestamp = new_txs[0].created_at;
        while self
            .txs
            .last()
            .map(|tx| tx.created_at >= first_timestamp)
            .unwrap_or(false)
        {
            self.txs.pop();
        }

        for tx in new_txs.iter() {
            for asset_id in tx.amounts.keys() {
                self.assets.insert(*asset_id);
            }
        }

        self.txs.append(&mut new_txs);
    }

    pub fn txs(&self) -> &[Transaction] {
        &self.txs
    }

    pub fn assets(&self) -> &BTreeSet<AssetId> {
        &self.assets
    }

    pub fn add_secret(&mut self, outpoint: OutPoint, secret: TxOutSecrets) {
        self.secrets.insert(outpoint, secret);
    }

    pub fn get_secret(&self, outpoint: &OutPoint) -> Option<&TxOutSecrets> {
        self.secrets.get(outpoint)
    }
}
