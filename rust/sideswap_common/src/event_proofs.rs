use std::{
    collections::{BTreeMap, VecDeque},
    str::FromStr,
};

use anyhow::{anyhow, ensure};
use bitcoin::secp256k1;
use elements::Address;
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use sideswap_api::mkt::{self, AssetPair, ClientEvent, OrdId, ServerEvent, TradeDir};
use sideswap_types::{
    duration_ms::DurationMs, normal_float::NormalFloat, timestamp_ms::TimestampMs,
};

use crate::env::Env;

#[derive(Debug, Serialize)]
enum EventHash<'a> {
    Client { event: &'a ClientEvent },
    Server { event: &'a ServerEvent },
}

#[derive(Clone, Serialize, Deserialize)]
pub struct Order {
    pub asset_pair: AssetPair,
    pub base_amount: u64,
    pub min_price: Option<NormalFloat>,
    pub max_price: Option<NormalFloat>,
    pub trade_dir: TradeDir,
    pub ttl: Option<DurationMs>,
    pub receive_address: Address,
    pub change_address: Address,
    pub private: bool,
    pub client_order_id: Option<Box<String>>,
    pub created_at: TimestampMs,
}

pub type HashArray = [u8; 32];

#[derive(Clone, Serialize, Deserialize)]
pub struct EventProofs {
    last_hash: HashArray,
    pending_orders: VecDeque<Order>,
    active_orders: BTreeMap<OrdId, Order>,
    public_key: secp256k1::PublicKey,
    count: usize,
}

pub fn hash_str(value: &str) -> HashArray {
    let mut hasher = Sha256::new();
    hasher.update(value);
    hasher.finalize().into()
}

fn append_event(last_hash: &HashArray, event: EventHash) -> HashArray {
    let event_str = serde_json::to_string(&event).expect("must not fail");

    let new_hash = hash_str(&event_str);

    let mut hasher = Sha256::new();
    hasher.update(last_hash);
    hasher.update(new_hash);
    hasher.finalize().into()
}

impl EventProofs {
    pub fn new(env: Env, public_key: secp256k1::PublicKey) -> EventProofs {
        let last_hash = hash_str(&env.d().name);
        EventProofs {
            last_hash,
            pending_orders: VecDeque::new(),
            active_orders: BTreeMap::new(),
            public_key,
            count: 0,
        }
    }

    pub fn get_active_orders(&self) -> &BTreeMap<OrdId, Order> {
        &self.active_orders
    }

    pub fn count(&self) -> usize {
        self.count
    }

    pub fn verify_client_signature(
        &self,
        event: &mkt::ClientEvent,
        signature: &str,
    ) -> Result<HashArray, anyhow::Error> {
        let last_hash = append_event(&self.last_hash, EventHash::Client { event });

        let msg = secp256k1::Message::from_digest(last_hash);
        let signature = secp256k1::ecdsa::Signature::from_str(signature)
            .map_err(|err| anyhow!("invalid signature: {err}"))?;
        secp256k1::SECP256K1
            .verify_ecdsa(&msg, &signature, &self.public_key)
            .map_err(|err| anyhow!("signature verification failed: {err}"))?;

        Ok(last_hash)
    }

    pub fn add_client_event(
        &mut self,
        event: mkt::ClientEvent,
        signature: &str,
    ) -> Result<(), anyhow::Error> {
        let last_hash = self.verify_client_signature(&event, signature)?;

        match &event {
            ClientEvent::AddOrder {
                asset_pair,
                base_amount,
                min_price,
                max_price,
                trade_dir,
                ttl,
                receive_address,
                change_address,
                private,
                client_order_id,
            } => {
                ensure!(self.pending_orders.is_empty());
                self.pending_orders.push_back(Order {
                    asset_pair: *asset_pair,
                    base_amount: *base_amount,
                    min_price: *min_price,
                    max_price: *max_price,
                    trade_dir: *trade_dir,
                    ttl: *ttl,
                    receive_address: receive_address.clone(),
                    change_address: change_address.clone(),
                    private: *private,
                    client_order_id: client_order_id.clone(),
                    created_at: TimestampMs::from_millis(0),
                });
            }

            ClientEvent::EditOrder {
                order_id,
                base_amount,
                min_price,
                max_price,
                receive_address,
                change_address,
            } => {
                let order = self
                    .active_orders
                    .get_mut(&order_id)
                    .ok_or_else(|| anyhow!("can't find order {order_id}"))?;
                if let Some(base_amount) = base_amount {
                    order.base_amount = *base_amount;
                }
                if let Some(min_price) = min_price {
                    order.min_price = Some(*min_price);
                }
                if let Some(max_price) = max_price {
                    order.max_price = Some(*max_price);
                }
                if let Some(receive_address) = receive_address {
                    order.receive_address = receive_address.clone();
                }
                if let Some(change_address) = change_address {
                    order.change_address = change_address.clone();
                }
            }

            ClientEvent::Ack { nonce: _ } => {}
        }

        self.last_hash = last_hash;
        self.count += 1;

        Ok(())
    }

    pub fn add_server_event(&mut self, event: mkt::ServerEvent) -> Result<(), anyhow::Error> {
        match &event {
            ServerEvent::OrderCreated {
                order_id,
                created_at,
            } => {
                let mut order = self
                    .pending_orders
                    .pop_front()
                    .ok_or_else(|| anyhow!("can't find pending order {order_id}"))?;
                ensure!(!self.active_orders.contains_key(&order_id));
                order.created_at = *created_at;
                self.active_orders.insert(*order_id, order);
            }

            ServerEvent::OrderEdited {
                order_id,
                updated_at,
            } => {
                let order = self
                    .active_orders
                    .get_mut(&order_id)
                    .ok_or_else(|| anyhow!("can't find order {order_id}"))?;
                order.created_at = *updated_at;
            }

            ServerEvent::OrderRemoved { order_id } => {
                let _order = self
                    .active_orders
                    .remove(&order_id)
                    .ok_or_else(|| anyhow!("can't find order {order_id}"))?;
            }

            ServerEvent::NewSwap {
                created_at: _,
                order_id,
                hist_id: _,
                base_amount,
                quote_amount: _,
                price: _,
                txid: _,
            } => {
                // The order can be already removed
                if let Some(order) = self.active_orders.get_mut(&order_id) {
                    order.base_amount = order.base_amount.saturating_sub(*base_amount);
                }
            }
        }

        self.last_hash = append_event(&self.last_hash, EventHash::Server { event: &event });
        self.count += 1;

        Ok(())
    }

    pub fn add_event(&mut self, event: mkt::EventWithSignature) -> Result<(), anyhow::Error> {
        match event {
            mkt::EventWithSignature::Client { event, signature } => {
                self.add_client_event(event, &signature)
            }
            mkt::EventWithSignature::Server { event } => self.add_server_event(event),
        }
    }

    pub fn sign_client_event(&self, event: mkt::ClientEvent, key: &secp256k1::SecretKey) -> String {
        let last_hash = append_event(&self.last_hash, EventHash::Client { event: &event });
        let msg = secp256k1::Message::from_digest(last_hash);
        let signature = secp256k1::SECP256K1.sign_ecdsa(&msg, key);
        signature.to_string()
    }
}
