# Context

Glossary of domain terms used across this repo. Terms are added lazily, when a decision or a change forces the project to pin one down.

Use these words in code, tests, issues and commit messages. Where a term has a *server* name and a *user-facing* name, both are listed — the code should not silently swap one for the other.

## Peg-in

**Peg-in** — moving BTC from the Bitcoin chain into Liquid, producing L-BTC in the user's SideSwap wallet. The user sends BTC to a per-request peg-in address; the L-BTC is credited once the peg-in clears.

**Instant credit** — crediting the user's L-BTC after only 2 Bitcoin confirmations, out of SideSwap's own liquidity, instead of waiting for the federation's full confirmation window. This is the fast path.

**Instant credit limit** — the largest peg-in amount that is still eligible for *instant credit*. A peg-in at or below the limit is credited after 2 confirmations; above it, the user waits for up to 103 confirmations.

> The server transports this number as `SubscribedValue.peg_in_wallet_balance` and the Dart model mirrors that name (`PegSubscribedValues.pegInWalletBalance`) — it is literally SideSwap's peg-in hot-wallet balance, which is what caps how much can be fronted. **User-facing copy never says "wallet balance"; it says "instant credit limit".** The two names describe the same number in two roles: the server's capacity, and the user's ceiling.

**Instant credit unavailable** — the state where the *instant credit limit* is zero, so no peg-in gets the fast path and every peg-in requires up to 103 confirmations. This is a normal, temporary operating state, not an error. See [ADR-0001](docs/adr/0001-pegin-instant-credit-zero-state.md).

> Distinct from **not loaded** — the state before the server has sent the limit at all. A zero *value* means both things and must never be read as "unavailable" on its own; the limit carries a separate loaded flag, and until it is set, the peg-in copy renders nothing rather than making a claim. Conflating the two is what produced the old "peg-ins below 0.0 BTC" line.

**Confirmation window** — the number of Bitcoin confirmations before L-BTC is released. 2 on the instant-credit path; **up to 103** otherwise. (Older copy said a flat "102" — that number is retired.)

**Peg-in info lines** — the bulleted explanatory copy shown on the peg-in screens (mobile receive screen and desktop peg dialog). Its content depends on whether instant credit is available; see ADR-0001.

## Wallet descriptors

**Wallet descriptor** — a CT output descriptor `ct(slip77(<blinding key>), <script>)` bundling an account's xpub with the wallet's SLIP-77 master blinding key. Whoever holds it can derive every address and unblind the wallet's full past and future transaction history, but cannot spend. The server sends two of them on successful login.
_Avoid_: "xpub" alone (a descriptor is more than the xpub), "private key" (it contains none).

**Native segwit descriptor** — the wallet descriptor for the native-segwit account (`elwpkh`, derivation 84'). Server name: `native_segwit_descriptor`. User-facing section name: **Native segwit**.

**Nested segwit descriptor** — the wallet descriptor for the nested-segwit account (`elsh(wpkh)`, derivation 49'). Server name: `nested_segwit_descriptor`. User-facing section name: **Nested segwit**.

**Watch-only wallet** — an external wallet (e.g. LWK-based) loaded from a wallet descriptor: it sees balances and history but holds no spending keys. The reason descriptor export exists.

**Descriptor export** — the settings flow that reveals both wallet descriptors so the user can set up a watch-only wallet. User-facing entry: **Export watch-only descriptors**; screen title: **Wallet descriptors**. Treated as sensitive like the recovery phrase — it leaks history, not funds.

**Jade unlock lease** — the app-side authorization window a Jade wallet holds after a successful device unlock: valid for five minutes from the last refresh, then it lapses. It is a cached lease, **not** a statement that the device is currently present or unlocked. The same lease gates trading actions and descriptor export.
_Avoid_: "device unlocked" (overstates what the app knows).

> Descriptors have a **not loaded** state (before a successful login delivers them), same discipline as the peg-in instant credit limit: not-loaded must never be conflated with a present-but-empty value. See ADR-0002.

## Liquid Connect

**Liquid Connect** — the feature that lets a web dApp ask the user's SideSwap wallet to connect and to sign. Three names for one thing, and they are not interchangeable: the **user-facing** name is *Liquid Connect* (every string the user reads says so), the **code** name is *swaption* (`swaption_session_providers`, `FCMPayloadType.swaptionSign`, `lib/screens/swaption/`), and the **URL scheme** is `liquidconnect`. New code and all issues, tests and commit messages say **Liquid Connect**; `swaption` survives only where it already names an existing symbol.
_Avoid_: inventing a fourth name, and renaming existing `swaption` symbols opportunistically — a half-done rename is worse than the split.

**Sign request** — a request from a connected origin for the wallet to sign a specific transaction. It carries a request id, an origin, and optionally a TTL. Requires a user decision unless the origin has autosign.

**Connect request** — a request from a new origin to establish a session. Same shape as a sign request and the same user decision, but it authorizes the relationship rather than a transaction.

**Origin** — the web domain a request comes from. A **session** is the standing relationship with an origin; a sign request whose origin has no matching session is ignored.

**Autosign** — a per-origin setting under which sign requests are signed without asking. An autosigned request produces no notification and no interruption of any kind — that is its whole point.

**Resolution reason** — why a request left the pending set: *accepted by user*, *rejected by user*, *expired* (its TTL ran out), or *remote cancel* (the origin withdrew it). Only the first two are user actions, and the desktop window policy turns on exactly that distinction. See ADR-0004.

**Raise episode** — the span from the app bringing its desktop window forward for an unsolicited request until every request in that span is resolved. It is what "put the window back afterwards" is scoped to; a second request arriving mid-span joins the episode rather than starting a new one.

**Window ownership** — the app's claim that *it* put the window in front of the user, and may therefore put it back. It lapses when the user takes the window over. Ownership is **best-effort, not a guarantee**: the platform reports window transitions without saying who caused them. See ADR-0004.
_Avoid_: "the window was minimized" as a synonym — that is one observation at one instant, not a standing claim.

**Window disposition** — where the window stood relative to the user when a request arrived: *minimized*, *hidden* (the whole app, Cmd-H), *visible but the app inactive*, *off the active Space*, or *active*. It decides what the app is allowed to do: on macOS only *minimized, on the active Space and not hidden* earns a raise, because it is the only disposition the app can put back exactly. The dispositions overlap as measured, so they are read in a fixed precedence. See ADR-0005.
_Avoid_: treating it as a single boolean ("was it minimized") — that reading is what let the app take the foreground and never return it.

**Pending badge** — the count of requests still awaiting a user decision, shown on the app icon. It tracks the pending set, **not** a raise episode: it survives the user activating the app and clears only when nothing is left pending, whatever the resolution reason.
_Avoid_: using it as an attention signal ("come here") — that is the Dock bounce, which dies the moment the app is activated. The badge answers "what is still waiting for me".
