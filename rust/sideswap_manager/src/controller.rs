use std::{str::FromStr, sync::Arc};

use elements::Address;
use sideswap_common::{
    channel_helpers::UncheckedUnboundedSender, dealer_ticker::TickerLoader, network::Network,
    verify,
};
use tokio::sync::{mpsc::UnboundedSender, oneshot};

use crate::{api, error::Error, worker::Command, ws_server::ClientId};

#[derive(Clone)]
pub struct Controller {
    network: Network,
    _ticker_loader: Arc<TickerLoader>,
    command_sender: UnboundedSender<Command>,
}

impl Controller {
    pub fn new(
        network: Network,
        ticker_loader: Arc<TickerLoader>,
        command_sender: UnboundedSender<Command>,
    ) -> Controller {
        Controller {
            network,
            _ticker_loader: ticker_loader,
            command_sender,
        }
    }

    pub fn parse_address(&self, address: &str) -> Result<elements::Address, Error> {
        let address = elements::Address::from_str(address)
            .map_err(|err| Error::InvalidAddress(address.to_owned(), err.into()))?;

        verify!(
            address.params == self.network.d().elements_params,
            Error::InvalidAddress(
                address.to_string(),
                anyhow::anyhow!(
                    "invalid address network, expected network: {:?}",
                    self.network
                )
            )
        );

        Ok(address)
    }

    fn make_request(&self, command: Command) -> Result<(), Error> {
        self.command_sender.send(command)?;
        Ok(())
    }

    pub fn client_connected(
        &self,
        client_id: ClientId,
        notif_sender: UncheckedUnboundedSender<api::Notif>,
    ) {
        let _ = self.make_request(Command::ClientConnected {
            client_id,
            notif_sender,
        });
    }

    pub fn client_disconnected(&self, client_id: ClientId) {
        let _ = self.make_request(Command::ClientDisconnected { client_id });
    }

    pub async fn new_address(&self) -> Result<Address, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(Command::NewAddress {
            res_sender: res_sender.into(),
        })?;
        let address = res_receiver.await??;
        Ok(address)
    }

    pub async fn get_quote(&self, req: api::GetQuoteReq) -> Result<api::GetQuoteResp, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(Command::GetQuote {
            req,
            res_sender: res_sender.into(),
        })?;
        let resp = res_receiver.await??;
        Ok(resp)
    }

    pub async fn accept_quote(
        &self,
        req: api::AcceptQuoteReq,
    ) -> Result<api::AcceptQuoteResp, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(Command::AcceptQuote {
            req,
            res_sender: res_sender.into(),
        })?;
        let resp = res_receiver.await??;
        Ok(resp)
    }

    pub async fn new_peg(&self, req: api::NewPegReq) -> Result<api::NewPegResp, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(Command::NewPeg {
            req,
            res_sender: res_sender.into(),
        })?;
        let resp = res_receiver.await??;
        Ok(resp)
    }

    pub async fn del_peg(&self, req: api::DelPegReq) -> Result<api::DelPegResp, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(Command::DelPeg {
            req,
            res_sender: res_sender.into(),
        })?;
        let resp = res_receiver.await??;
        Ok(resp)
    }

    pub async fn get_swaps(&self, req: api::GetSwapsReq) -> Result<api::GetSwapsResp, Error> {
        let (res_sender, res_receiver) = oneshot::channel();
        self.make_request(Command::GetSwaps {
            req,
            res_sender: res_sender.into(),
        })?;
        let resp = res_receiver.await??;
        Ok(resp)
    }
}
