SideSwap client
===============

SideSwap is released under the terms of the GNU General Public License. See [LICENSE](LICENSE) for more information.

SideSwap swap protocol: [doc/protocol.md](doc/protocol.md).

Client build instructions: [doc/build.md](doc/build.md).

Dealer example: [doc/dealer.md](doc/dealer.md).

API reference: [https://sideswap.io/docs/](https://sideswap.io/docs/).

SideSwap client uses [GDK library](https://github.com/Blockstream/gdk) and [libwally-core](https://github.com/ElementsProject/libwally-core) from Blockstream.

Build instruction
=================

To build our flutter client on Windows please make sure symlinks are enabled:

- Enable "Developer Mode" (this will also allow make symlinks on Windows)

- Enable symlinks in Git

```
$ git config --global core.symlinks true
```

The repo should be cloned anew.
