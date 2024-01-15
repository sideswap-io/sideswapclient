pub struct WrappedType<T>(pub T);

impl<T: std::str::FromStr> rusqlite::types::FromSql for WrappedType<T>
where
    <T as std::str::FromStr>::Err: Send + Sync + std::error::Error + 'static,
{
    fn column_result(
        value: rusqlite::types::ValueRef,
    ) -> rusqlite::types::FromSqlResult<WrappedType<T>> {
        if let rusqlite::types::ValueRef::Text(text) = value {
            let text = std::str::from_utf8(text)
                .map_err(|err| rusqlite::types::FromSqlError::Other(Box::new(err)))?;
            let value = T::from_str(text)
                .map_err(|err| rusqlite::types::FromSqlError::Other(Box::new(err)))?;
            Ok(WrappedType(value))
        } else {
            Err(rusqlite::types::FromSqlError::InvalidType)
        }
    }
}

impl<T: std::fmt::Display> rusqlite::types::ToSql for WrappedType<T> {
    fn to_sql(&self) -> rusqlite::Result<rusqlite::types::ToSqlOutput<'_>> {
        Ok(rusqlite::types::ToSqlOutput::from(self.0.to_string()))
    }
}

impl<T> From<T> for WrappedType<T> {
    fn from(value: T) -> Self {
        Self(value)
    }
}
