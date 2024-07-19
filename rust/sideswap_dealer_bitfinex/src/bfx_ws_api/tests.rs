use super::*;

#[test]
fn wallet_snapshot() {
    let msg = r#"
    [
        0,
        "ws",
        [
          [
            "exchange",
            "TESTBTC",
            1.23456789012,
            0,
            null,
            "Trading fees for 0.00012345 TESTBTC (TESTBTC:TESTUSDT) @ 12345.0 on BFX (0.2%)",
            null
          ],
          [
            "exchange",
            "TESTUSDT",
            56789.01234567890,
            0,
            null,
            "Exchange 0.00123456 TESTBTC for TESTUSDT @ 23456.0",
            {
              "reason": "TRADE",
              "order_id": 123456789012,
              "order_id_oppo": 123456789012,
              "trade_price": "12345.0",
              "trade_amount": "0.00123456",
              "order_cid": 1234567890123,
              "order_gid": null
            }
          ],
          [
            "exchange",
            "TESTUSD",
            12345.67890123,
            0,
            null,
            null,
            null
          ],
          [
            "margin",
            "TESTUSDTF0",
            12345.67890123,
            0,
            null,
            null,
            null
          ]
        ]
      ]
    "#;
    let mut state = State::new();
    let events = get_events(&mut state, msg).unwrap();
    assert_eq!(
        events,
        [
            Event::WalletBalance {
                wallet_type: WalletType::Exchange,
                currency: "TESTBTC".to_owned(),
                balance: 1.23456789012,
            },
            Event::WalletBalance {
                wallet_type: WalletType::Exchange,
                currency: "TESTUSDT".to_owned(),
                balance: 56789.01234567890,
            },
            Event::WalletBalance {
                wallet_type: WalletType::Exchange,
                currency: "TESTUSD".to_owned(),
                balance: 12345.67890123,
            },
            Event::WalletBalance {
                wallet_type: WalletType::Margin,
                currency: "TESTUSDTF0".to_owned(),
                balance: 12345.67890123,
            },
        ]
    );
}

#[test]
fn wallet_update() {
    let msg = r#"
    [
      0,
      "wu",
      [
        "exchange",
        "TESTBTC",
        1.23456789012,
        0,
        1.23456789012,
        "Trading fees for 0.00123456 TESTBTC (TESTBTC:TESTUSDT) @ 23456.0 on BFX (0.2%)",
        null
      ]
    ]
    "#;
    let mut state = State::new();
    let events = get_events(&mut state, msg).unwrap();
    assert_eq!(
        events,
        [Event::WalletBalance {
            wallet_type: WalletType::Exchange,
            currency: "TESTBTC".to_owned(),
            balance: 1.23456789012,
        }]
    );
}

#[test]
fn order_cancel() {
    let msg = r#"
    [
      0,
      "oc",
      [
        161234567890,
        null,
        1723456789012,
        "tTESTBTC:TESTUSDT",
        1234567890125,
        1234567801226,
        0,
        -0.001234,
        "EXCHANGE MARKET",
        null,
        null,
        null,
        0,
        "EXECUTED @ 23456.0(-0.001234)",
        null,
        null,
        23456,
        23456,
        0,
        0,
        null,
        null,
        null,
        0,
        0,
        null,
        null,
        null,
        "API>BFX",
        null,
        null,
        {}
      ]
    ]
    "#;
    let mut state = State::new();
    let events = get_events(&mut state, msg).unwrap();
    assert_eq!(
        events,
        [Event::OrderCancel {
            symbol: "tTESTBTC:TESTUSDT".to_owned(),
            cid: 1723456789012,
            id: 161234567890,
            amount_orig: -0.001234,
            price_avg: 23456.0
        }]
    );
}
