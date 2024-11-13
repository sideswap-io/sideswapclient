pub struct UncheckedUnboundedSender<T>(tokio::sync::mpsc::UnboundedSender<T>);

impl<T> UncheckedUnboundedSender<T> {
    pub fn send(&self, message: T) {
        let res = self.0.send(message);
        if res.is_err() {
            debug!("channel is closed");
        }
    }
}

impl<T> From<tokio::sync::mpsc::UnboundedSender<T>> for UncheckedUnboundedSender<T> {
    fn from(value: tokio::sync::mpsc::UnboundedSender<T>) -> Self {
        Self(value)
    }
}

pub struct UncheckedOneshotSender<T>(tokio::sync::oneshot::Sender<T>);

impl<T> UncheckedOneshotSender<T> {
    pub fn send(self, message: T) {
        let res = self.0.send(message);
        if res.is_err() {
            debug!("channel is closed");
        }
    }
}

impl<T> From<tokio::sync::oneshot::Sender<T>> for UncheckedOneshotSender<T> {
    fn from(value: tokio::sync::oneshot::Sender<T>) -> Self {
        Self(value)
    }
}

impl<T> Clone for UncheckedUnboundedSender<T> {
    fn clone(&self) -> Self {
        UncheckedUnboundedSender(self.0.clone())
    }
}
