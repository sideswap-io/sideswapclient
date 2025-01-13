use std::sync::Arc;

use tokio::sync::Notify;

pub struct TermSignal {
    notify: Arc<Notify>,
}

impl TermSignal {
    pub fn new() -> TermSignal {
        let notify = Arc::new(Notify::new());

        #[cfg(target_os = "linux")]
        {
            let notify_copy = Arc::clone(&notify);
            tokio::spawn(async move {
                let mut signal =
                    tokio::signal::unix::signal(tokio::signal::unix::SignalKind::terminate())
                        .expect("must not fail");
                loop {
                    signal.recv().await;
                    log::debug!("received terminate signal");
                    notify_copy.notify_one();
                }
            });
        }

        let notify_copy = Arc::clone(&notify);
        tokio::spawn(async move {
            loop {
                tokio::signal::ctrl_c().await.expect("must not fail");
                log::debug!("received interrupt signal");
                notify_copy.notify_one();
            }
        });

        TermSignal { notify }
    }

    pub async fn recv(&self) {
        self.notify.notified().await;
    }
}
