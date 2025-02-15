use elements::secp256k1_zkp::PublicKey;
use serde::{Deserialize, Serialize};

pub type InstallId = sideswap_api::Hash16;
pub type ContactId = sideswap_api::Hash16;
pub type AvatarId = sideswap_api::Hash16;

// Common

pub type ReqId = i32;

#[derive(Debug, Clone, PartialEq, Eq, Ord, PartialOrd, Hash, Serialize, Deserialize)]
pub struct PhoneKey(pub String);

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PhoneNumber {
    // Example: +41 44 668 18 00
    pub international: String,
    // Example: +41446681800
    pub e164: String,
    // Example: CH
    pub region_code: String,
    // Example: 41
    pub country_code: u32,
    // Example: 446681800
    pub national_number: String,
}

#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct RawContact {
    pub name: String,
    pub phone_numbers: Vec<String>,
}

pub type RawContacts = Vec<RawContact>;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Contact {
    pub contact_id: ContactId,
    pub phone_number: PhoneNumber,
    pub name: String,
    pub avatar_id: Option<AvatarId>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ContactTx {
    pub txid: elements::Txid,
    pub phone_number: PhoneNumber,
    pub message: String,
}

// Requests

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterPhoneReq {
    pub country_code: u32,
    pub national_number: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterPhoneResp {
    pub register_id: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyPhoneReq {
    pub register_id: String,
    pub code: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct VerifyPhoneResp {
    pub phone_key: PhoneKey,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterWalletReq {
    pub phone_key: PhoneKey,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct RegisterWalletResp {}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChallengeReq {}

#[derive(Serialize, Deserialize, Debug)]
pub struct ChallengeResp {
    pub challenge: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct WalletLoginReq {
    pub public_key: PublicKey,
    pub signature: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct WalletLoginResp {}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadFcmTokenReq {
    pub install_id: InstallId,
    pub token: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadFcmTokenResp {}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadContactsReq {
    pub install_id: InstallId,
    pub contacts: RawContacts,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadContactsResp {}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadAvatarReq {
    pub avatar: Option<String>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadAvatarResp {}

#[derive(Serialize, Deserialize, Debug)]
pub struct DownloadAvatarReq {
    pub avatar_id: AvatarId,
    pub contact_id: Option<ContactId>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DownloadAvatarResp {
    pub avatar: Vec<u8>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadAddressesReq {
    pub addresses: Vec<elements::Address>,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct UploadAddressesResp {}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetContactAddrReq {
    pub contact_id: ContactId,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetContactAddrResp {
    pub address: elements::Address,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddContactTxReq {
    pub tx: String,
    pub message: String,
}

#[derive(Serialize, Deserialize, Debug)]
pub struct AddContactTxResp {}

// Notifications

#[derive(Debug, Serialize, Deserialize)]
pub struct UnregisteredNotif {}

#[derive(Debug, Serialize, Deserialize)]
pub struct RegisteredNotif {
    pub phone_number: PhoneNumber,
    pub contacts: Vec<Contact>,
    pub contact_txs: Vec<ContactTx>,
    pub avatar_id: Option<AvatarId>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ContactCreatedNotif {
    pub contact: Contact,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct ContactRemovedNotif {
    pub contact_id: ContactId,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct UploadAddressesNotif {
    pub count: usize,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct NewContactTxNotif {
    pub tx: ContactTx,
}

// Top level messages

#[derive(Debug, Serialize, Deserialize)]
pub enum ErrorCode {
    /// Something wrong with the request arguments.
    InvalidRequest,
    /// Server error.
    Server,
    /// Wrong SMS code.
    WrongSmsCode,
    /// Unknown error
    #[serde(other)]
    Unknown,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct Error {
    pub code: ErrorCode,
    pub message: String,
}

pub trait HttpRequest: serde::Serialize + serde::de::DeserializeOwned {
    const NAME: &'static str;
    type Resp: serde::Serialize + serde::de::DeserializeOwned;
}

impl HttpRequest for RegisterPhoneReq {
    const NAME: &'static str = "register_phone";
    type Resp = RegisterPhoneResp;
}

impl HttpRequest for VerifyPhoneReq {
    const NAME: &'static str = "verify_phone";
    type Resp = VerifyPhoneResp;
}

#[derive(Serialize, Deserialize)]
pub enum Req {
    Challenge(ChallengeReq),
    WalletLogin(WalletLoginReq),
    RegisterWallet(RegisterWalletReq),
    UploadFcmToken(UploadFcmTokenReq),
    UploadContacts(UploadContactsReq),
    UploadAvatar(UploadAvatarReq),
    DownloadAvatar(DownloadAvatarReq),
    UploadAddresses(UploadAddressesReq),
    GetContactAddr(GetContactAddrReq),
    AddContactTx(AddContactTxReq),
}

#[derive(Serialize, Deserialize)]
pub enum Resp {
    Challenge(ChallengeResp),
    WalletLogin(WalletLoginResp),
    RegisterWallet(RegisterWalletResp),
    UploadFcmToken(UploadFcmTokenResp),
    UploadContacts(UploadContactsResp),
    UploadAvatar(UploadAvatarResp),
    UploadAddresses(UploadAddressesResp),
    DownloadAvatar(DownloadAvatarResp),
    GetContactAddr(GetContactAddrResp),
    AddContactTx(AddContactTxResp),
}

#[derive(Debug, Serialize, Deserialize)]
pub enum Notif {
    Unregistered(UnregisteredNotif),
    Registered(RegisteredNotif),
    ContactCreated(ContactCreatedNotif),
    ContactRemoved(ContactRemovedNotif),
    UploadAddresses(UploadAddressesNotif),
    NewContactTx(NewContactTxNotif),
}

#[derive(Serialize, Deserialize)]
pub enum To {
    Req { id: ReqId, req: Req },
}

#[derive(Serialize, Deserialize)]
pub enum From {
    Resp { id: ReqId, resp: Resp },
    Error { id: ReqId, err: Error },
    Notif { notif: Notif },
}

// Utils

pub fn get_login_message(challenge: &str) -> String {
    format!("stableapp login, nonce: {challenge}")
}
