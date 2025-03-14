use sideswap_common::random_id::random_hash32;

use super::*;

async fn create_test_db() -> Db {
    let options: SqliteConnectOptions = ":memory:".parse().unwrap();
    Db::open_with_options(options).await
}

#[tokio::test]
async fn db_test_1() {
    let db = create_test_db().await;
    let order_id = random_hash32();
    db.add_peg(Peg {
        order_id: Text(order_id),
    })
    .await;
    let orders = db.load_pegs().await;
    assert_eq!(orders.len(), 1);
    assert_eq!(orders[0].order_id.0, order_id);
    db.delete_peg(order_id).await;

    let orders = db.load_pegs().await;
    assert!(orders.is_empty());

    db.close().await;
}
