use serde::Deserialize;

#[derive(Eq, PartialEq)]
pub enum BtcTopic {
    PubRawTx,
    PubRawBlock,
    PubHashTx,
    PubHashBlock,
}

#[derive(Debug, Deserialize)]
pub struct Server {
    host: String,
    port: u16,
}

pub fn connect<F>(server: &Server, cb: F)
where
    F: Fn(BtcTopic, Vec<u8>) + Send + 'static,
{
    let context = zmq::Context::new();
    let sub = context.socket(zmq::SUB).unwrap();
    sub.connect(&format!("tcp://{}:{}", &server.host, server.port))
        .expect("zmq connect failed");
    sub.set_subscribe(b"").expect("zmq subscribe failed");

    std::thread::spawn(move || loop {
        let envelope = sub.recv_multipart(0).unwrap();
        let topic = std::str::from_utf8(&envelope[0]).expect("invalid topic");
        let topic = match topic {
            "hashblock" => BtcTopic::PubHashBlock,
            "hashtx" => BtcTopic::PubHashTx,
            "rawblock" => BtcTopic::PubRawBlock,
            "rawtx" => BtcTopic::PubRawTx,
            _ => panic!("unexpected topic: {}", topic),
        };
        let data = envelope.into_iter().nth(1).expect("data is empty");
        cb(topic, data);
    });
}
