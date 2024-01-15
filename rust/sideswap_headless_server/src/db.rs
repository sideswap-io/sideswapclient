use std::path::Path;

use self::wrapper_type::WrappedType;

pub mod wrapper_type;

pub struct Db {
    conn: rusqlite::Connection,
}

pub struct Swap {
    pub order_id: WrappedType<sideswap_api::OrderId>,
    pub txid: WrappedType<elements::Txid>,
    pub unique_key: Option<String>,
}

impl Db {
    fn init(conn: &rusqlite::Connection) -> Result<(), anyhow::Error> {
        conn.execute(
            "create table if not exists swaps (order_id text primary key, txid text not null unique, unique_key text unique)",
            (),
        )?;

        Ok(())
    }

    #[cfg(test)]
    pub fn in_memory() -> Db {
        let conn = rusqlite::Connection::open_in_memory().expect("must not fail");

        Self::init(&conn).expect("must not fail");

        Db { conn }
    }

    pub fn open(path: impl AsRef<Path>) -> Result<Self, anyhow::Error> {
        let conn = rusqlite::Connection::open(path)?;

        Self::init(&conn)?;

        Ok(Db { conn })
    }

    pub fn load_all(&self) -> Result<Vec<Swap>, anyhow::Error> {
        let mut stmt = self
            .conn
            .prepare("select order_id, txid, unique_key from swaps")?;

        let swaps = stmt
            .query_map([], |row| {
                Ok(Swap {
                    order_id: row.get(0)?,
                    txid: row.get(1)?,
                    unique_key: row.get(2)?,
                })
            })?
            .collect::<Result<Vec<_>, _>>()?;

        Ok(swaps)
    }

    pub fn add_swap(&self, swap: &Swap) -> Result<(), anyhow::Error> {
        self.conn.execute(
            "insert into swaps (order_id, txid, unique_key) VALUES (?1, ?2, ?3)",
            (&swap.order_id, &swap.txid, &swap.unique_key),
        )?;
        Ok(())
    }
}

#[cfg(test)]
mod test;
