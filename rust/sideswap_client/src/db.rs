use super::*;
use diesel::prelude::*;
use diesel::sqlite::SqliteConnection;
use std::collections::hash_map::DefaultHasher;
use std::hash::{Hash, Hasher};
use std::sync::{Arc, Mutex};
use std::time::{SystemTime, UNIX_EPOCH};

embed_migrations!();

#[derive(Clone)]
pub struct Db(Arc<Mutex<SqliteConnection>>);

pub fn now() -> i64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_millis() as i64
}

fn calculate_hash<T: Hash>(t: &T) -> i64 {
    let mut s = DefaultHasher::new();
    t.hash(&mut s);
    s.finish() as i64
}

impl Db {
    pub fn new(path: &str) -> Result<Db, anyhow::Error> {
        let conn = SqliteConnection::establish(path)?;
        info!("run migrations...");
        embedded_migrations::run(&conn)?;
        Ok(Db(Arc::new(Mutex::new(conn))))
    }

    pub fn load_orders(&self) -> Vec<models::Order> {
        let db = self.0.lock().unwrap();
        schema::orders::table.load::<models::Order>(&*db).unwrap()
    }

    pub fn create_order(&self, value: models::NewOrder) -> models::Order {
        let db = self.0.lock().unwrap();

        diesel::insert_into(schema::orders::table)
            .values(&value)
            .execute(&*db)
            .unwrap();

        schema::orders::table
            .order(schema::orders::id.desc())
            .limit(1)
            .first::<models::Order>(&*db)
            .unwrap()
    }

    pub fn load_swaps(&self) -> Vec<models::Swap> {
        let db = self.0.lock().unwrap();
        schema::swaps::table.load::<models::Swap>(&*db).unwrap()
    }

    pub fn create_swap(&self, value: models::NewSwap) -> models::Swap {
        let db = self.0.lock().unwrap();

        diesel::insert_into(schema::swaps::table)
            .values(&value)
            .execute(&*db)
            .unwrap();

        schema::swaps::table
            .order(schema::swaps::id.desc())
            .limit(1)
            .first::<models::Swap>(&*db)
            .unwrap()
    }

    pub fn load_wallets(&self) -> Vec<models::Wallet> {
        let db = self.0.lock().unwrap();
        schema::wallets::table.load::<models::Wallet>(&*db).unwrap()
    }

    pub fn create_wallet(
        &self,
        value: &mut models::NewWallet,
    ) -> Result<models::Wallet, anyhow::Error> {
        let db = self.0.lock().unwrap();

        let new_id = calculate_hash(&value);
        let exists = schema::wallets::table
            .filter(schema::wallets::columns::id.eq(new_id))
            .count()
            .get_result::<i64>(&*db)
            .unwrap()
            != 0;

        diesel::update(schema::wallets::table)
            .set(schema::wallets::columns::is_active.eq(false))
            .filter(schema::wallets::columns::is_active.eq(true))
            .execute(&*db)
            .unwrap();

        if exists {
            diesel::update(schema::wallets::table)
                .set(schema::wallets::columns::is_active.eq(true))
                .filter(schema::wallets::columns::id.eq(new_id))
                .execute(&*db)
                .unwrap();

            Err(anyhow!("Wallet already exists"))
        } else {
            value.id = Some(new_id);
            diesel::insert_into(schema::wallets::table)
                .values(&*value)
                .execute(&*db)
                .unwrap();

            let new_wallet = schema::wallets::table
                .order(schema::wallets::id.desc())
                .limit(1)
                .first::<models::Wallet>(&*db)
                .unwrap();

            Ok(new_wallet)
        }
    }

    pub fn mark_wallet_as_active(&self, id: i64) -> Vec<models::Wallet> {
        {
            let db = self.0.lock().unwrap();

            diesel::update(schema::wallets::table)
                .set(schema::wallets::columns::is_active.eq(false))
                .filter(schema::wallets::columns::is_active.eq(true))
                .execute(&*db)
                .unwrap();

            diesel::update(schema::wallets::table)
                .set(schema::wallets::columns::is_active.eq(true))
                .filter(schema::wallets::columns::id.eq(id))
                .execute(&*db)
                .unwrap();
        }

        self.load_wallets()
    }

    pub fn remove_wallet(&self, remove_date: i64) -> Vec<models::Wallet> {
        {
            let db = self.0.lock().unwrap();

            diesel::delete(schema::wallets::table)
                .filter(schema::wallets::columns::id.eq(remove_date))
                .execute(&*db)
                .unwrap();

            let first_wallet = schema::wallets::table
                .order(schema::wallets::id.asc())
                .limit(1)
                .first::<models::Wallet>(&*db);

            match first_wallet {
                Ok(res) => {
                    diesel::update(schema::wallets::table)
                        .set(schema::wallets::columns::is_active.eq(true))
                        .filter(schema::wallets::columns::id.eq(res.id))
                        .execute(&*db)
                        .unwrap();
                }
                _ => {}
            };
        }

        self.load_wallets()
    }

    pub fn update_setting(&self, key: &str, value: &str) {
        let db = self.0.lock().unwrap();

        diesel::delete(schema::settings::table.find(&key))
            .execute(&*db)
            .unwrap();

        let setting = models::NewSetting {
            key: key.to_owned(),
            value: value.to_owned(),
        };

        diesel::insert_into(schema::settings::table)
            .values(&setting)
            .execute(&*db)
            .unwrap();
    }

    pub fn get_setting(&self, key: &str) -> Option<String> {
        let db = self.0.lock().unwrap();

        schema::settings::table
            .find(&key)
            .first::<models::Setting>(&*db)
            .ok()
            .map(|setting| setting.value)
    }
}
