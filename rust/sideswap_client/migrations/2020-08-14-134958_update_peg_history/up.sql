drop table if exists orders;

create table orders (
    id integer primary key not null,
    order_id text unique not null,
    pegin boolean not null,
    own_addr text not null,
    peg_addr text unique not null,
    created_at bigint not null
);
