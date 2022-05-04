#[derive(Default)]
struct Buf {
    data: Vec<u8>,
    pos: usize,
}

#[derive(Clone, Default)]
pub struct BufReader {
    buf: std::sync::Arc<std::sync::Mutex<Buf>>,
}

impl ciborium_io::Read for BufReader {
    type Error = anyhow::Error;

    fn read_exact(&mut self, data: &mut [u8]) -> Result<(), Self::Error> {
        let mut buf = self.buf.lock().unwrap();
        ensure!(buf.pos + data.len() <= buf.data.len());
        data.copy_from_slice(&buf.data[buf.pos..buf.pos + data.len()]);
        buf.pos += data.len();
        Ok(())
    }
}

impl BufReader {
    pub fn reset_pos(&self) {
        let mut buf = self.buf.lock().unwrap();
        buf.pos = 0;
    }

    pub fn remove_read(&self) -> Vec<u8> {
        let mut buf = self.buf.lock().unwrap();
        let pos = buf.pos;
        let result = buf.data.drain(0..pos).collect();
        buf.pos = 0;
        result
    }

    pub fn append_data(&self, data: &[u8]) {
        let mut buf = self.buf.lock().unwrap();
        buf.data.extend_from_slice(data);
    }

    pub fn size(&self) -> usize {
        let buf = self.buf.lock().unwrap();
        buf.data.len()
    }
}
