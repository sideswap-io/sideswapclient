pub trait UtxoExt {
    fn txid(&self) -> elements::Txid;

    fn vout(&self) -> u32;

    fn value(&self) -> u64;

    fn redeem_script(&self) -> Option<&elements::Script>;

    fn outpoint(&self) -> elements::OutPoint {
        elements::OutPoint {
            txid: self.txid(),
            vout: self.vout(),
        }
    }
}
