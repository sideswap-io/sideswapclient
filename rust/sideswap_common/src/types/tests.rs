use super::*;

#[test]
fn test_select_utxo() {
    assert_eq!(select_utxo(vec![10], 10), vec![10]);
    assert_eq!(select_utxo(vec![15], 10), vec![15]);
    assert_eq!(select_utxo(vec![15, 10], 25), vec![15, 10]);
    assert_eq!(select_utxo(vec![5000, 10, 5], 15), vec![10, 5]);
    assert_eq!(select_utxo(vec![5000, 10, 5], 16), vec![5000]);
    assert_eq!(select_utxo(vec![1000, 100, 10, 1], 101), vec![100, 1]);
    assert_eq!(select_utxo(vec![1000, 100, 10, 1], 102), vec![100, 10]);
    assert_eq!(select_utxo(vec![1000, 100, 10, 1], 1), vec![1]);
    assert_eq!(select_utxo(vec![1000, 100, 10, 1], 10), vec![10]);
    assert_eq!(select_utxo(vec![1000, 100, 10, 1], 100), vec![100]);
}

#[test]
fn test_max_amount() {
    use rand::Rng;
    let mut rng = rand::thread_rng();
    let mut less_count = 0;
    let mut more_count = 0;
    let test_count = 10000;
    for _ in 0..test_count {
        let balance: i64 = rng.gen_range(
            SWAP_MARKETS_MIN_BITCOIN_AMOUNT.to_sat() + SWAP_MARKETS_MIN_SERVER_FEE.to_sat()
                ..Amount::from_bitcoin(100.0).to_sat(),
        );
        let balance = Amount::from_sat(balance);
        let server_fee = ServerFee::new(None);
        let amount = get_max_bitcoin_amount(balance, server_fee).unwrap();
        let server_fee = get_server_fee(amount, server_fee);
        if amount + server_fee > balance {
            more_count += 1;
        }
        if amount + server_fee < balance {
            less_count += 1;
        }
    }
    assert!(more_count == 0);
    assert!(
        (less_count as f64) / (test_count as f64) < 0.002,
        "less_count: {}, test_count: {}",
        less_count,
        test_count
    );
}
