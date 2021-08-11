fn main() {
    let target = std::env::var("TARGET").unwrap();

    prost_build::compile_protos(
        &["../../go/sideswap.io/proxy_bitfinex/proto/bitfinex.proto"],
        &["../../go/sideswap.io/proxy_bitfinex/proto"],
    )
    .unwrap();

    let dir = std::env::var("CARGO_MANIFEST_DIR").unwrap();
    let proxy_dir = std::path::Path::new(&dir).join("../../go/sideswap.io/proxy_bitfinex");

    println!("cargo:rustc-link-search=native={}", proxy_dir.display());

    if target.contains("linux") {
        println!("cargo:rustc-link-lib=proxy_bitfinex_linux");
        println!(
            "cargo:rerun-if-changed={}",
            proxy_dir.join("libproxy_bitfinex_linux.a").display()
        );
    } else if target.contains("windows") {
        println!("cargo:rustc-link-lib=proxy_bitfinex_windows");
        println!(
            "cargo:rerun-if-changed={}",
            proxy_dir.join("libproxy_bitfinex_windows.a").display()
        );
    }
}
