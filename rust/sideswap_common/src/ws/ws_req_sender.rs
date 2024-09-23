use std::{
    collections::{BTreeMap, VecDeque},
    time::Duration,
};

use tokio::sync::mpsc::{UnboundedReceiver, UnboundedSender};

use crate::verify;

use super::{
    auto::{WrappedRequest, WrappedResponse},
    next_request_id,
};

#[derive(thiserror::Error, Debug)]
pub enum Error {
    #[error("Disconnected")]
    Disconnected,
    #[error("Backend error: {0}")]
    BackendError(String),
    #[error("Request timeout")]
    Timeout(#[from] tokio::time::error::Elapsed),
    #[error("Unexpected response")]
    UnexpectedResponse,
}

pub type Callback = Box<dyn FnOnce(Result<&sideswap_api::Response, Error>) + Send + Sync>;

pub struct WsReqSender {
    connected: bool,
    req_sender: UnboundedSender<WrappedRequest>,
    resp_receiver: UnboundedReceiver<WrappedResponse>,
    received: VecDeque<WrappedResponse>,
    callbacks: BTreeMap<sideswap_api::RequestId, Callback>,
}

impl WsReqSender {
    pub fn new(
        req_sender: UnboundedSender<WrappedRequest>,
        resp_receiver: UnboundedReceiver<WrappedResponse>,
    ) -> Self {
        Self {
            connected: false,
            req_sender,
            resp_receiver,
            received: Default::default(),
            callbacks: Default::default(),
        }
    }

    pub fn connected(&self) -> bool {
        self.connected
    }

    pub async fn recv(&mut self) -> WrappedResponse {
        if let Some(event) = self.received.pop_front() {
            event
        } else {
            let event = self.resp_receiver.recv().await.expect("must be open");
            self.on_received(&event);
            event
        }
    }

    pub async fn wait_for_notif<T>(
        &mut self,
        timeout: Duration,
        f: impl Fn(&sideswap_api::Notification) -> Option<T>,
    ) -> Result<T, Error> {
        for (index, received) in self.received.iter().enumerate() {
            if let WrappedResponse::Response(sideswap_api::ResponseMessage::Notification(notif)) =
                &received
            {
                if let Some(value) = f(&notif) {
                    self.received.remove(index);
                    return Ok(value);
                }
            };
        }

        let resp = tokio::time::timeout(timeout, async {
            loop {
                verify!(self.connected, Error::Disconnected);

                let event = self.resp_receiver.recv().await.expect("must be open");
                self.on_received(&event);

                if let WrappedResponse::Response(sideswap_api::ResponseMessage::Notification(
                    notif,
                )) = &event
                {
                    if let Some(value) = f(&notif) {
                        return Result::<T, Error>::Ok(value);
                    }
                };

                self.received.push_back(event);
            }
        })
        .await??;

        Ok(resp)
    }

    pub fn send_request(&mut self, req: sideswap_api::Request) {
        self.req_sender
            .send(WrappedRequest::Request(
                sideswap_api::RequestMessage::Request(next_request_id(), req),
            ))
            .expect("must be open");
    }

    pub async fn make_request(
        &mut self,
        req: sideswap_api::Request,
    ) -> Result<sideswap_api::Response, Error> {
        verify!(self.connected, Error::Disconnected);

        let expected_id = next_request_id();

        self.req_sender
            .send(WrappedRequest::Request(
                sideswap_api::RequestMessage::Request(expected_id.clone(), req),
            ))
            .expect("must be open");

        while let Ok(msg) = self.resp_receiver.try_recv() {
            self.on_received(&msg);
            self.received.push_back(msg);
        }

        tokio::time::timeout(Duration::from_secs(60), async move {
            let res = loop {
                let event = self.resp_receiver.recv().await.expect("must be open");
                self.on_received(&event);

                match event {
                    WrappedResponse::Response(sideswap_api::ResponseMessage::Response(
                        Some(id),
                        res,
                    )) if id == expected_id => {
                        break res.map_err(|err| Error::BackendError(err.message));
                    }
                    other => {
                        let failed = match &other {
                            WrappedResponse::Disconnected | WrappedResponse::Connected => true,
                            WrappedResponse::Response(_) => false,
                        };
                        self.received.push_back(other);
                        if failed {
                            break Err(Error::Disconnected);
                        }
                    }
                }
            };
            res
        })
        .await?
    }

    pub fn callback_request(&mut self, req: sideswap_api::Request, callback: Callback) {
        if !self.connected {
            callback(Err(Error::Disconnected));
        } else {
            let request_id = next_request_id();
            self.req_sender
                .send(WrappedRequest::Request(
                    sideswap_api::RequestMessage::Request(request_id.clone(), req),
                ))
                .expect("must be open");
            self.callbacks.insert(request_id, callback);
        }
    }

    fn on_received(&mut self, msg: &WrappedResponse) {
        match msg {
            WrappedResponse::Connected => self.connected = true,

            WrappedResponse::Disconnected => {
                self.connected = false;

                let callbacks = std::mem::take(&mut self.callbacks);
                for callback in callbacks.into_values() {
                    callback(Err(Error::Disconnected));
                }
            }

            WrappedResponse::Response(resp) => match resp {
                sideswap_api::ResponseMessage::Response(Some(request_id), res) => {
                    self.callbacks.remove(request_id).map(|callback| match res {
                        Ok(resp) => callback(Ok(resp)),
                        Err(err) => callback(Err(Error::BackendError(err.message.clone()))),
                    });
                }
                sideswap_api::ResponseMessage::Response(None, _) => {}
                sideswap_api::ResponseMessage::Notification(_) => {}
            },
        }
    }
}

#[macro_export]
macro_rules! make_request {
    ($ws:expr, $typ:ident, $value:expr) => {{
        let res = $ws
            .make_request(::sideswap_api::Request::$typ($value))
            .await;
        match res {
            Ok(::sideswap_api::Response::$typ(resp)) => Ok(resp),
            Ok(_) => Err(::sideswap_common::ws::ws_req_sender::Error::UnexpectedResponse),
            Err(err) => Err(err),
        }
    }};
}
