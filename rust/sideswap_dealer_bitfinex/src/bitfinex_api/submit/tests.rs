use super::*;

#[test]
fn test_parse() {
    let resp = r#" [1713851220,"on-req",null,null,[[150674086017,null,1713851220162,"tTESTBTC:TESTUSDT",1713851220162,1713851220162,0.0001,0.0001,"EXCHANGE MARKET",null,null,null,0,"ACTIVE",null,null,66588,0,0,0,null,null,null,0,0,null,null,null,"API>BFX",null,null,{}]],null,"SUCCESS","Submitting 1 orders."] "#;
    let resp = serde_json::from_str::<serde_json::Value>(resp).unwrap();
    let resp = SubmitRequest::parse(resp).unwrap();
    assert!(resp.order_id == 150674086017);
}
