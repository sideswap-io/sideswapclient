create table wallets (
    id bigint unique primary key not null,
    wallet_type text not null,
    host text not null,
    port text not null,
    user_name text not null,
    user_pass text not null,
    is_active boolean not null
);