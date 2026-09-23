# SideSwap Client

> **Cross‑platform, non‑custodial wallet and atomic swap marketplace for the Liquid Network**

SideSwap Client is the official open‑source desktop & mobile application that lets you manage and atomically swap assets on Blockstream’s [**Liquid Network**](https://blockstream.com/liquid).\
It is written in **Flutter (Dart)** with a high‑performance **Rust core** and relies on the [Liquid Wallet Kit (LWK)](https://github.com/Blockstream/lwk) for low‑level wallet functionality.

*Peer‑to‑peer swaps, peg‑in/peg‑out bridging, AMP token management, multi‑platform binaries, and a fully documented swap protocol—everything you need to settle assets on Liquid.*

---

## ✨ Key Features

|                                     |                                                                                                       |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------- |
| 🔄 **Atomic swaps**                 | Trust‑minimised trades between any two Liquid assets (L‑BTC, USDt, EURx, AMP tokens, NFTs, etc.).     |
| 🪙 **Asset management**             | Transfer AMP assets without intermediaries.                              |
| 🔐 **Confidential & non‑custodial** | You keep the keys; amounts & asset types are hidden on‑chain thanks to Liquid CT.                     |
| 📈 **Market & order‑book view**     | Built‑in price index and order aggregation for stablecoin, AMP and custom token markets.              |
| 🔌 **Pluggable dealer bots**        | Headless *Dealer* daemons (written in Rust) expose HTTP + WebSocket APIs for automated market‑making. |
| 🖥  **Fully cross‑platform**        | Build & run on **Android, iOS, Linux, Windows and macOS** from a single code base.                    |
| 🛡 **GPL‑3.0 licensed**             | 100 % open source; auditable by anyone.                                                               |

See the [Rust sources](https://github.com/sideswap-io/sideswap_rust/) for more details.

---

## 🚀 Quick Start (pre‑built binaries)

1. Download the latest release for your OS from the [releases page](https://github.com/sideswap-io/sideswapclient/releases).
2. Verify the PGP signature (using this [public key](https://sideswap.io/resource/sideswap.gpg.txt)).
3. Unpack the archive and launch the executable / `.apk` / `.dmg` / `.AppImage`.
4. Create or import a Liquid mnemonic and you are ready to swap.

> Need help? Check the in‑app **Guides** tab or the [FAQ on sideswap.io](https://sideswap.io/faq/).

---

## 🛠️ Build from Source (Linux)

The client can be compiled inside a minimal Debian 11 container—no toolchain installation required on the host. Make sure you have either **Docker** or **Podman** installed. You may need up to 10 GB of free disk space.

### Using Docker

```bash
docker pull debian:11
docker run --rm -v "$(pwd)":/sideswapclient debian:11 /sideswapclient/deploy/build_linux.sh
```

### Using Podman

```bash
podman pull docker.io/debian:11
podman run --rm -v "$(pwd)":/sideswapclient:Z docker.io/debian:11 /sideswapclient/deploy/build_linux.sh
```

Run the application after a successful build with:

```bash
./output/sideswap_linux/sideswap
```

Temporary directories can then be removed:

```bash
rm -rf deps build
```


### Native library for a developer build

The desktop app loads the rust wallet library `sideswap_client` at run time. The
Docker build above copies it for you. A developer build done with
`flutter build linux`, `flutter build windows`, `flutter run -d linux` or
`flutter run -d windows` copies it during the build's install step, so no manual
copy is needed.

The library is looked up in two places, in this order:

1. The cargo target directory of the `sideswap_rust` checkout:
   `<rust>/target/debug/` for a Debug build and `<rust>/target/release/`
   otherwise. `<rust>` is the `SIDESWAP_RUST_DIR` environment variable when it is
   set, and the `sideswap_rust` sibling directory of this repository otherwise.
   On Windows and macOS the "Sideswap: cargo sideswap_client (desktop)" VS Code
   task builds the Debug library. For a Profile or Release build, and on Linux,
   run `cargo build -p sideswap_client [--release]` in that checkout yourself.
2. A drop directory inside the platform directory, for developers who do not
   build the rust library themselves: `linux/lib/libsideswap_client.so` and
   `windows/lib/sideswap_client.dll`. Both directories are gitignored. On Windows
   every other `.dll` in the chosen directory is copied too, which covers the
   MinGW runtime libraries that ship beside a prebuilt DLL.

When the library is in neither place, the build prints a warning that names both
paths and still succeeds. Unless an earlier build already put the library in
place, the app then starts and fails on the login screen. On
Windows `flutter build windows` hides the console output of the install step, so
the warning is visible only in the raw build log, for example through
`cmake --install build/windows/x64 --config Debug`.


---

## 🔒 Security & Responsible Disclosure

If you find a security vulnerability **please DO NOT open a public issue**.\
Instead, email [**hello@sideswap.io**](mailto:hello@sideswap.io) or message [@Sideswap](https://t.me/Sideswap) on Telegram, optionally using the [project PGP key](https://sideswap.io/resource/sideswap.gpg.txt). We will coordinate a patch and release timeline with you.

---

## 📄 License

SideSwap Client is released under the **GNU General Public License v3.0**.\
See the [LICENSE](LICENSE) file for the full text.

---

## 🙏 Acknowledgements

- [Blockstream LWK](https://github.com/Blockstream/lwk) for Liquid wallet primitives.
- The wider [Flutter](https://flutter.dev) and [Rust](https://www.rust-lang.org/) communities.

---

### 📣 Stay Connected

- Website & blog: [https://sideswap.io](https://sideswap.io)
- Twitter/X: [https://x.com/side_swap](https://x.com/side_swap)
- Telegram: [@Sideswap](https://t.me/Sideswap)
- Community chat: [https://t.me/SideSwap_io](https://t.me/SideSwap_io)

---

*Settle any asset against any other—instantly, privately and without intermediaries. Welcome to the financial layer of Bitcoin.*

