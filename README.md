# SideSwap Client

> **Cross‑platform, non‑custodial wallet and atomic swap marketplace for the Liquid Network**


SideSwap Client is the official open‑source desktop & mobile application that lets you manage and atomically swap assets on Blockstream’s [**Liquid Network**](https://blockstream.com/liquid).\
It is written in **Flutter (Dart)** with a high‑performance **Rust core** and relies on the [Green Development Kit (GDK)](https://github.com/Blockstream/gdk) for low‑level wallet functionality.

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

## 🔒 Security & Responsible Disclosure

If you find a security vulnerability **please DO NOT open a public issue**.\
Instead, email [**hello@sideswap.io**](mailto\:hello@sideswap.io) or message [@Sideswap](https://t.me/Sideswap) on Telegram, optionally using the [project PGP key](https://sideswap.io/resource/sideswap.gpg.txt). We will coordinate a patch and release timeline with you.

---

## 📄 License

SideSwap Client is released under the **GNU General Public License v3.0**.\
See the [LICENSE](LICENSE) file for the full text.

---

## 🙏 Acknowledgements

- [Blockstream GDK](https://github.com/Blockstream/gdk) for Liquid wallet primitives.
- The wider [Flutter](https://flutter.dev) and [Rust](https://www.rust-lang.org/) communities.

---

### 📣 Stay Connected

- Website & blog: [https://sideswap.io](https://sideswap.io)
- Twitter/X: [https://x.com/side_swap](https://x.com/side_swap)
- Telegram: [@Sideswap](https://t.me/Sideswap)
- Community chat: [https://t.me/SideSwap_io](https://t.me/SideSwap_io)

---

*Settle any asset against any other—instantly, privately and without intermediaries. Welcome to the financial layer of Bitcoin.*
