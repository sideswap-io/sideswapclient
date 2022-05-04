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
    println!("cargo:rerun-if-env-changed={}", gdk_env_name);

    let target_os = env::var("CARGO_CFG_TARGET_OS").unwrap();
    let target_arch = env::var("CARGO_CFG_TARGET_ARCH").unwrap();
    match target_os.as_str() {
        "android" => {
            println!("cargo:rustc-link-lib=dylib=greenaddress");
            let android_gdk_path = match target_arch.as_str() {
                "x86" => "x86",
                "x86_64" => "x86_64",
                "arm" => "armeabi-v7a",
                "aarch64" => "arm64-v8a",
                _ => unimplemented!("unsupported target_arch: {}", target_arch),
            };
            println!(
                "cargo:rustc-link-search=native={}/lib/{}",
                gdk_dir, android_gdk_path
            );
        }
        "linux" => {
            println!("cargo:rustc-link-lib=static=greenaddress_full");
            println!("cargo:rustc-link-lib=dylib=stdc++");
            println!("cargo:rustc-link-search=native={}", gdk_dir);
        }
        "windows" => {
            println!("cargo:rustc-link-lib=dylib=greenaddress_full");
            println!("cargo:rustc-link-lib=dylib=stdc++.dll");
            println!("cargo:rustc-link-lib=dylib=ssp.dll");
            println!("cargo:rustc-link-lib=dylib=crypt32");
            println!("cargo:rustc-link-lib=dylib=shell32");
            println!("cargo:rustc-link-lib=dylib=iphlpapi");
            println!("cargo:rustc-link-search=native={}", gdk_dir);
            println!("cargo:rustc-link-search=native=/usr/lib/gcc/x86_64-w64-mingw32/8.3-posix");
        }
        "ios" => {
            println!("cargo:rustc-link-lib=static=greenaddress_full");
            println!("cargo:rustc-link-lib=dylib=stdc++");
            println!("cargo:rustc-link-search=native={}", gdk_dir);
        }
        "macos" => {
            println!("cargo:rustc-link-lib=static=greenaddress_full");
            println!("cargo:rustc-link-lib=dylib=c++");
            println!("cargo:rustc-link-search=native={}", gdk_dir);
        }
        _ => {
            unimplemented!("unsupported target_os: {}", target_os)
        }
    }

    vergen::vergen(vergen::Config::default()).unwrap();
}
