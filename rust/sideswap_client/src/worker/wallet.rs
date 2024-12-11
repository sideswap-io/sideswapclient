use std::{
    collections::BTreeMap,
    sync::{mpsc, Arc},
};

use crate::{
    ffi::proto,
    gdk_ses,
    gdk_ses_impl::CreatedTxCache,
    worker::{self, AccountId},
};

pub type RunCallback = Box<dyn FnOnce(&mut Data) -> () + Send + Sync>;

pub type ResCallback = Box<dyn FnOnce(&mut worker::Data) -> () + Send>;

pub enum Command {
    Run(RunCallback),
}

pub enum Event {
    Run(ResCallback),
}

pub struct Data {
    pub ses: Box<dyn gdk_ses::GdkSes + Send>,
    pub created_tx_cache: CreatedTxCache,
    pub event_callback: EventCallback,
}

pub type EventCallback = Arc<dyn Fn(AccountId, Event) -> () + Send + Sync>;

pub fn callback<Resp, WalletCallback, ResCallback>(
    account_id: AccountId,
    worker: &mut super::Data,
    wallet_cb: WalletCallback,
    res_cb: ResCallback,
) where
    Resp: Send + 'static,
    WalletCallback: FnOnce(&mut Data) -> Result<Resp, anyhow::Error> + Send + Sync + 'static,
    ResCallback:
        FnOnce(&mut super::Data, Result<Resp, anyhow::Error>) -> () + Send + Sync + 'static,
{
    let wallet = match worker.get_wallet(account_id) {
        Ok(wallet) => wallet,
        Err(err) => {
            res_cb(worker, Err(err));
            return;
        }
    };

    wallet
        .command_sender
        .send(Command::Run(Box::new(move |data| {
            let res = wallet_cb(data);
            (data.event_callback)(
                account_id,
                Event::Run(Box::new(move |data| {
                    res_cb(data, res);
                })),
            );
        })))
        .expect("channel must be open");
}

#[must_use]
pub fn send_wallet<Resp, WalletCallback>(
    wallet: &super::Wallet,
    wallet_cb: WalletCallback,
) -> mpsc::Receiver<Result<Resp, anyhow::Error>>
where
    Resp: Send + 'static,
    WalletCallback: FnOnce(&mut Data) -> Result<Resp, anyhow::Error> + Send + Sync + 'static,
{
    let (resp_sender, resp_receiver) = mpsc::channel::<Result<Resp, anyhow::Error>>();

    wallet
        .command_sender
        .send(Command::Run(Box::new(move |data| {
            let res = wallet_cb(data);
            resp_sender.send(res).expect("channel must be open");
        })))
        .expect("channel must be open");

    resp_receiver
}

pub fn call_wallet<Resp, WalletCallback>(
    wallet: &super::Wallet,
    wallet_cb: WalletCallback,
) -> Result<Resp, anyhow::Error>
where
    Resp: Send + 'static,
    WalletCallback: FnOnce(&mut Data) -> Result<Resp, anyhow::Error> + Send + Sync + 'static,
{
    let resp_receiver = send_wallet(wallet, wallet_cb);
    let resp = resp_receiver.recv()??;
    Ok(resp)
}

pub fn call<Resp, WalletCallback>(
    account_id: AccountId,
    worker: &super::Data,
    wallet_cb: WalletCallback,
) -> Result<Resp, anyhow::Error>
where
    Resp: Send + 'static,
    WalletCallback: FnOnce(&mut Data) -> Result<Resp, anyhow::Error> + Send + Sync + 'static,
{
    let wallet = worker.get_wallet(account_id)?;
    call_wallet(wallet, wallet_cb)
}

pub struct PegoutPayment {
    pub policy_asset: elements::AssetId,
    pub send_amount: i64,
    pub peg_addr: String,
}

pub fn process_peg_out_payment(
    ses: &mut dyn gdk_ses::GdkSes,
    payment: PegoutPayment,
) -> Result<(), anyhow::Error> {
    let mut created_tx_cache = CreatedTxCache::new();

    let created = ses.create_tx(
        &mut created_tx_cache,
        proto::CreateTx {
            addressees: vec![proto::AddressAmount {
                address: payment.peg_addr,
                amount: payment.send_amount,
                asset_id: payment.policy_asset.to_string(),
            }],
            account: proto::Account {
                id: ses.login_info().account_id,
            },
            utxos: Vec::new(),
            fee_asset_id: None,
            deduct_fee_output: None,
        },
    )?;

    ses.send_tx(&mut created_tx_cache, &created.id, &BTreeMap::new())?;

    Ok(())
}

fn run(
    ses: Box<dyn gdk_ses::GdkSes + Send>,
    command_receiver: mpsc::Receiver<Command>,
    event_callback: EventCallback,
) {
    let mut data = Data {
        ses,
        created_tx_cache: CreatedTxCache::new(),
        event_callback,
    };

    while let Ok(command) = command_receiver.recv() {
        match command {
            Command::Run(callback) => {
                callback(&mut data);
            }
        }
    }
}

pub fn start(
    ses: Box<dyn gdk_ses::GdkSes + Send>,
    command_receiver: mpsc::Receiver<Command>,
    event_callback: EventCallback,
) {
    std::thread::spawn(move || run(ses, command_receiver, event_callback));
}
