use std::path::Path;

use sqlx::{
    sqlite::{SqliteConnectOptions, SqliteJournalMode, SqlitePoolOptions, SqliteQueryResult},
    types::{Json, Text},
    SqlitePool,
};

pub struct Db {
    pool: SqlitePool,
}

pub type DbError = sqlx::Error;

impl Db {
    async fn open_with_options(option: SqliteConnectOptions) -> Self {
        let pool = SqlitePoolOptions::new()
            .connect_with(option.foreign_keys(true))
            .await
            .expect("should not fail");

        // sqlx::migrate!().run(&pool).await.expect("should not fail");

        Self { pool }
    }

    pub async fn open_file(path: impl AsRef<Path>) -> Self {
        let options = SqliteConnectOptions::new()
            .filename(path)
            .create_if_missing(true)
            .journal_mode(SqliteJournalMode::Wal);

        Self::open_with_options(options).await
    }

    // pub async fn add_user(&self) {
    //     let x = sqlx::query!("select (1) as id, 'Herp Derpinson' as name")
    //         .fetch_one(&self.pool)
    //         .await
    //         .unwrap();
    //     log::debug!("#### {x:#?}");
    // }

    pub async fn close(self) {
        self.pool.close().await;
    }
}
