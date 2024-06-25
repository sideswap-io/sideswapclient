#[macro_export]
macro_rules! verify {
    ($cond:expr, $err:expr) => {
        ::core::primitive::bool::then($cond, || ()).ok_or_else(|| $err)?
    };
}

#[macro_export]
macro_rules! abort {
    ($err:expr) => {
        return Err($err.into())
    };
}
