use elements::hashes::Hash;
use rand::Rng;

use super::*;

fn new_order_id() -> WrappedType<sideswap_api::OrderId> {
    WrappedType(rand::thread_rng().gen())
}

fn new_txid() -> WrappedType<elements::Txid> {
    elements::Txid::from_slice(&(new_order_id().0 .0))
        .unwrap()
        .into()
}

#[test]
fn basic() {
    let db = Db::in_memory();
    db.load_all().unwrap();

    Db::init(&db.conn).unwrap();

    db.add_swap(&Swap {
        order_id: new_order_id(),
        txid: new_txid(),
        unique_key: None,
    })
    .unwrap();

    db.add_swap(&Swap {
        order_id: new_order_id(),
        txid: new_txid(),
        unique_key: None,
    })
    .unwrap();

    db.add_swap(&Swap {
        order_id: new_order_id(),
        txid: new_txid(),
        unique_key: Some("123".to_owned()),
    })
    .unwrap();

    // Duplicated unique_key
    db.add_swap(&Swap {
        order_id: new_order_id(),
        txid: new_txid(),
        unique_key: Some("123".to_owned()),
    })
    .unwrap_err();

    let swaps = db.load_all().unwrap();
    assert_eq!(swaps.len(), 3);
}
