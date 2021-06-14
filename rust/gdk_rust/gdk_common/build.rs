use std::env;

fn main() {
    let target = env::var("TARGET").unwrap();

    let wally_dir = env::var("WALLY_DIR").unwrap();
    println!("cargo:rustc-link-lib=static=wallycore");
    if !target.contains("apple") {
        println!("cargo:rustc-link-lib=static=secp256k1");
    }
    println!("cargo:rustc-link-search=native={}", wally_dir);
}
