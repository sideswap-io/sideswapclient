use std::process::Command;

fn main() {
    // Based on https://stackoverflow.com/questions/43753491/include-git-commit-hash-as-string-into-rust-program
    let git_hash = Command::new("git")
        .args(&["rev-parse", "HEAD"])
        .output()
        .map(|output| String::from_utf8(output.stdout).unwrap())
        .unwrap_or("UNKNOWN".to_owned());
    println!("cargo:rustc-env=GIT_HASH={}", git_hash);
}
