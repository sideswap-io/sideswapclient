create table users (
    id integer primary key,
    created_at timestamp default current_timestamp,
    email text not null unique
);
