use elements::Address;

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub struct UnconfidentialAddress(Address);

impl UnconfidentialAddress {
    pub fn new(address: &Address) -> UnconfidentialAddress {
        UnconfidentialAddress(address.to_unconfidential())
    }
}
