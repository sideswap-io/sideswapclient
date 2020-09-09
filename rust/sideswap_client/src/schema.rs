table! {
    orders (id) {
        id -> Integer,
        order_id -> Text,
        pegin -> Bool,
        own_addr -> Text,
        peg_addr -> Text,
        created_at -> BigInt,
    }
}

table! {
    settings (key) {
        key -> Text,
        value -> Text,
    }
}

table! {
    swaps (id) {
        id -> Integer,
        order_id -> Text,
    }
}

table! {
    wallets (id) {
        id -> BigInt,
        wallet_type -> Text,
        host -> Text,
        port -> Text,
        user_name -> Text,
        user_pass -> Text,
        is_active -> Bool,
    }
}

allow_tables_to_appear_in_same_query!(orders, settings, swaps, wallets,);
