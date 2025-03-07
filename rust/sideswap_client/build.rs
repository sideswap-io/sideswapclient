use std::env;

fn main() {
    let proto_path = "../../ffi/sideswap.proto";
    let mut config = prost_build::Config::new();
    config.type_attribute(".", "#[derive(serde::Serialize, serde::Deserialize)]");
    config
        .compile_protos(&[proto_path], &["../../ffi"])
        .unwrap();
    println!("cargo:rerun-if-changed={}", proto_path);

    let gdk_env_name = "GDK_DIR";
    let gdk_dir = env::var(gdk_env_name).unwrap();
    println!("cargo:rerun-if-env-changed={gdk_env_name}");

    let gdk_dylib_name = "GDK_DYLIB";
    println!("cargo:rerun-if-env-changed={gdk_dylib_name}");

    println!("cargo:rerun-if-changed={gdk_dir}/libgreen_gdk_full.a");

    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();
    match target_os.as_str() {
        "android" => {
            println!("cargo:rustc-link-lib=dylib=green_gdk_java");
            println!("cargo:rustc-link-search=native={}", gdk_dir);
        }
        "linux" => {
            if let Ok(gdk_dylib) = env::var(gdk_dylib_name) {
                println!("cargo:rustc-link-lib=dylib={gdk_dylib}");
            } else {
                println!("cargo:rustc-link-lib=static=green_gdk_full");
                println!("cargo:rustc-link-lib=dylib=stdc++");
            }
            println!("cargo:rustc-link-search=native={gdk_dir}");
        }
        "windows" => {
            println!("cargo:rustc-link-lib=static=green_gdk_full");
            println!("cargo:rustc-link-lib=dylib=stdc++.dll");
            println!("cargo:rustc-link-lib=dylib=ssp.dll");
            println!("cargo:rustc-link-lib=dylib=crypt32");
            println!("cargo:rustc-link-lib=dylib=shell32");
            println!("cargo:rustc-link-lib=dylib=iphlpapi");
            println!("cargo:rustc-link-search=native={gdk_dir}");
            println!("cargo:rustc-link-search=native=/usr/lib/gcc/x86_64-w64-mingw32/10-posix");
        }
        "ios" => {
            println!("cargo:rustc-link-lib=static=green_gdk_full");
            println!("cargo:rustc-link-lib=dylib=c++");
            println!("cargo:rustc-link-lib=framework=Security");
            println!("cargo:rustc-link-search=native={}", gdk_dir);
        }
        "macos" => {
            println!("cargo:rustc-link-lib=static=green_gdk_full");
            println!("cargo:rustc-link-lib=dylib=c++");
            println!("cargo:rustc-link-lib=framework=Security");
            println!("cargo:rustc-link-search=native={}", gdk_dir);
        }
        _ => {
            unimplemented!("unsupported target_os: {}", target_os)
        }
    }

    vergen::vergen(vergen::Config::default()).unwrap();
}
