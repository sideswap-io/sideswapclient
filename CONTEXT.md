# Context

Glossary of domain terms used across this repo. Terms are added lazily, when a decision or a change forces the project to pin one down.

Use these words in code, tests, issues and commit messages. Where a term has a *server* name and a *user-facing* name, both are listed — the code should not silently swap one for the other.

## Third-party code under `thirdparty/`

**Vendored package** — a copy of somebody else's published package, checked into `thirdparty/`, carrying a named patch and substituted for the pub.dev original through `dependency_overrides`. A vendored package always states its upstream commit, its patch and its maintenance terms in an `UPSTREAM.md` beside it. It may be temporary or permanent, but which one is a decision that gets recorded rather than drifted into. Prior art: `thirdparty/permission_handler_windows`, permanent and hand-maintained by choice — see [ADR-0007](docs/adr/0007-vendored-permission-handler-windows.md).
_Avoid_: calling it a fork. A fork lives in another repository and drifts invisibly; a vendored copy is in this diff, reviewable line by line, and guarded by a test.

**Fork dependency** — a `git:` dependency pointing at a repository we control that mirrors an upstream project. Distinct from a *vendored package* in the property that matters: the delta is not in this repo, so nobody reviewing a SideSwap diff can see what it changes. The `permission_handler` fork hid a five-line fix under a whole-file reformat for fourteen months, and the reason for it survived only in a commit subject.

**Upstream drift** — the gap that opens between a *vendored package* and the release it was copied from. It has two independent failure modes and both need catching: the local copy diverging by accident, and the original's version constraint moving past what the copy declares — which `dependency_overrides` satisfies **silently**, since an override ignores constraints entirely.

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

**Pending set** — the requests currently awaiting a user decision. A request enters it on arrival — unless it is *dropped at delivery*, the one case where it never enters at all — and leaves it exactly once, carrying a *resolution reason*. Membership is what an acceptance is checked against after the *acceptance gate* returns: a request that left the set while the user was authenticating is not accepted afterwards. See ADR-0006.

**Request TTL** — the validity window a request carries, shown to the user as a countdown. It is **a hint, not the authority**: the app counts it from the moment it *received* the request, so a phone that was offline or backgrounded runs a more generous clock than the server's, and the binding expiry arrives from the network as a *remote cancel*. A request with a TTL leaves the *pending set* as *expired* when the countdown reaches zero; a request **without** a TTL never expires locally and waits indefinitely for the user. **Expiry is a fact about the request, not an effect of being looked at**: it happens whether or not any window, panel or dialog is open. It is still not the authority. The local deadline falls at or after the server's — the app counts from receipt, the server from issue — so a local expiry approximates a withdrawal the server owns rather than being a retraction the app decides; how closely depends on the transport, which is not bounded. The comparison is millisecond-precise, which fixes where the boundary sits rather than how promptly it is crossed: the removal runs on a timer callback, so it lands at the first moment after the deadline that the scheduler delivers one. See ADR-0006 and ADR-0010.
_Avoid_: treating the countdown as a deadline the app enforces, or extending/freezing it to accommodate a slow user — a user who runs out of time retries from the web page; and reading "expiry is a fact" as "the app's clock wins" — the binding withdrawal is still the server's.

**Dropped at delivery** — what happens to a request that has already outlived its *request TTL* by the time it reaches the app. It never enters the *pending set*, so it has no *resolution reason*, nothing is sent to the origin, no window is raised and no badge is written; a log line is the only record it leaves. Distinct from every resolution reason, because there was no resolution: the user was never asked. See ADR-0010.
_Avoid_: calling it *rejected* — that names a user action that sends `accept: false`; and confusing it with a request whose TTL is merely short — one that still has time left is delivered normally, counts down and goes, because inventing a floor would invent a deadline the server did not give.

**Acceptance gate** — the wallet authentication (`isAuthenticated()`) that every acceptance driven by a user action passes before any acceptance leaves the app, on both platforms and for both request kinds. *Autosign* is the single exception: it authenticates once at the checkbox that enables it, never per signature. See ADR-0006.
_Avoid_: reading it as "the user is always prompted" — a wallet with neither PIN nor biometrics passes it in silence, and a Jade wallet passes it immediately.

**Acceptance attempt** — the span from a user pressing an approval control until the acceptance is sent or abandoned: the *acceptance gate*, then the *pending set* re-check, then the send and the record. It is identified by the **request id**, because that is what one acceptance answers — not by the notification id, which is a local arrival counter carrying no identity of its own — it does **not** restart on `clearAll()`, because the notifier instance survives the invalidation (#211), and a bare integer is not an identity either way, and not by the widget the press came from. At most one attempt per request id runs at a time, and while one runs that request's approval control is busy. It outlives any widget: once the gate is crossed, the widget is no longer a party, and the attempt is neither cancelled nor completed by the control going away. It still has a liveness guard, now on the provider's `ref` rather than a widget's context. See ADR-0009.
_Avoid_: giving it a return value for the caller to act on — that puts a widget's survival back in the path; reading "the control is busy" as UI polish rather than as the visible half of the one-attempt rule; and reading "outlives any widget" as "cannot be disposed" — an explicit invalidation still disposes it, which is why nothing invalidates it.

**Notification panel** — the desktop list of pending requests, opened from the toolbar bell. Simultaneity is its point: it shows every request at once, which is what makes it, and not mobile, the place where per-request state has to be kept apart. **Resolving one request does not collapse it while another is still pending** — resolving the last one does, because the *pending set* empties. No item has the means to collapse it. The toolbar button is the user's own way to close it, and so is a click outside it; the dismissal is a dismissal and not a toggle, because the overlay outlives the click by the length of the collapse animation and a second click must not be read as "open again". An item's element **follows the request it shows**: children are keyed by the entry's notification id *and* its kind — one id can carry two entries — and the sliver relocates them through `findChildIndexCallback`, so an unrelated arrival or removal leaves keyboard focus where the user put it. The panel grants the keyboard once, to the request it opens on; nothing arriving afterwards takes it. An item's height is a constant of its kind and its state, which is how the panel sizes itself to its first item without measuring a child that can move. See ADR-0009.
_Avoid_: reading that as "an element outlives its request" — a collapse takes the whole panel and everything under it, which is why nothing an acceptance depends on lives in an element; and a window resize still rebuilds the overlay entry and destroys every element with it, which is a defect rather than a rule, tracked as #233. The stronger claim once attached to that rebuild — that a resize *during the collapse* removes the entry twice, throws inside the status listener, and strands an invisible full-window catcher that eats every click until restart — does **not** hold. It was deduced from `OverlayEntry.remove`, never measured, and the measurement refutes it: both panels, ten resize offsets spread across the 75 ms collapse, eight size changes each, with the effect body instrumented to prove it ran — every entry is removed and reinserted cleanly, nothing throws, and a button under the panel still answers afterwards. The ordering is why: the reinserting microtask drains before the next frame, and in the frame that dismisses, the ticker runs before the build, so the effect finds the handle already cleared.

**Connections panel** — the desktop list of the Liquid Connect sessions currently standing, opened from the toolbar's connections icon; the icon carries the session count as a badge and is dead with nothing to show. It is the *notification panel*'s sibling and shares its idioms rather than its rules. Shared: one overlay entry, the grow-and-collapse, and the dismiss-and-swallow catcher — a click outside it dismisses it, and the dismissal is a dismissal and not a toggle, for the reason its sibling's is. Not shared: **the panel does not size itself to its first item**. It stands at a fixed 370×300 whatever it holds, which it can afford because no session item has to be answered — there is no request under it, only a domain, a disconnect control, and, for a local session, the autosign checkbox. Not shared either: its children carry no key and its sliver has no `findChildIndexCallback`, so an element is matched to a *slot* rather than to a session — the shape #203 fixed in its sibling, deduced here rather than measured, and unfixed. The panel goes when the last session drops, and it collapses on the way out, because the effect keyed on the session list defers its `expanded` write through a microtask and leaves the entry to the status listener; measured, the controller stands at 0.6 thirty milliseconds into the 75 ms reverse, at 0 when it ends, and at 0.33 fifty milliseconds into the 150 ms grow that follows. The entry therefore outlives the last session by the length of the collapse, and draws its empty state for that span. Nothing shrinks on screen while it does, in this panel or in its sibling: the `Align` that carries `heightFactor` sits under a `SizedBox` of fixed height, and `RenderPositionedBox` returns `constraints.constrain(child.height * heightFactor)`, which those tight constraints pin to the fixed height whatever the factor. Measured: the panel's `ClipRect` is 370x300 both open and mid-collapse, and under a 20x `timeDilation` the panel stands still for the length of the reverse and then goes at once. The grow and the collapse are timings without a picture; that is a defect rather than a rule. A window resize rebuilds its overlay entry and destroys every element with it, the same defect its sibling carries, tracked as #233.
_Avoid_: reading "sibling" as "the same widget" — the two panels are separate files that were copied from one another, and every fix so far has had to be made twice; and reading the fixed size as a decision about content — nothing measures a session item, so a tall list scrolls inside 300 px and a short one leaves the box half empty.

**Raise episode** — the span from the app bringing its desktop window forward for an unsolicited request until every request in that span is resolved. It is what "put the window back afterwards" is scoped to; a second request arriving mid-span joins the episode rather than starting a new one.

**Window ownership** — the app's claim that *it* put the window in front of the user, and may therefore put it back. It lapses when the user takes the window over. Ownership is **best-effort, not a guarantee**: the platform reports window transitions without saying who caused them. See ADR-0004.
_Avoid_: "the window was minimized" as a synonym — that is one observation at one instant, not a standing claim.

**Window disposition** — where the window stood relative to the user when a request arrived: *minimized*, *hidden* (the whole app, Cmd-H), *visible but the app inactive*, *off the active Space*, or *active*. It decides what the app is allowed to do: on macOS only *minimized, on the active Space and not hidden* earns a raise, because it is the only disposition the app can put back exactly. The dispositions overlap as measured, so they are read in a fixed precedence. See ADR-0005.
_Avoid_: treating it as a single boolean ("was it minimized") — that reading is what let the app take the foreground and never return it.

**Pending badge** — the count of requests still awaiting a user decision, shown on the app icon. It tracks the pending set, **not** a raise episode: it survives the user activating the app and clears only when nothing is left pending, whatever the resolution reason.
_Avoid_: using it as an attention signal ("come here") — that is the Dock bounce, which dies the moment the app is activated. The badge answers "what is still waiting for me".

## Wallet unlock

**Unlock** — getting from a locked wallet to a usable one on mobile. Two credentials, sharing a screen but not their wording: **biometric**, where the prompt belongs to the platform and cancelling it is silent, and **PIN**, where the prompt is ours, is dismissible, and counts three attempts down before deleting the wallet. Either way the user must always be left something that can start the attempt again — that requirement is what keeps a dismissed prompt from becoming a wallet you can only escape by killing the app. See [ADR-0008](docs/adr/0008-wallet-unlock-locked-screen.md).
_Avoid_: writing copy or building affordances that assume biometrics — a wallet configured with a PIN and no biometrics reaches the same screen and is currently told to touch a fingerprint reader it does not use.

**Local login** — what a successful login actually asserts: the client accepted the credentials and opened the wallet from local storage. It says **nothing about the server**. The connection to the dealer is started afterwards, fire-and-forget, and reports back neither success nor failure, so a wallet whose registration is already cached logs in with no network at all and puts the user inside the app with empty balances.
_Avoid_: reading it as "connected", and treating a login failure as evidence that the network is down — the failures it can carry are a bad mnemonic, a hardware-wallet error, or a failed first-time registration.

**Unlocking** — the span between the app sending the login request and the client answering. It is the only window in which the app can honestly claim to be working, and on a long-used wallet it lasts seconds, because opening the wallet replays an update log that is never compacted. Distinct from *local login*, which is its outcome, and from the connection, which it does not wait for.
_Avoid_: calling it "connecting" — nothing is connecting during it.

## PIN setup

**PIN setup** — the flow that turns PIN protection on, entered from settings, from the PIN welcome screen, or on a new wallet. Distinct from *unlock*, which spends a PIN that already exists. Both flows share the on-screen keyboard and the field widgets, and neither shares state with the other. See [ADR-0013](docs/adr/0013-pin-setup-busy-state.md).
_Avoid_: "PIN entry" for either — it names the keystrokes, not which of the two flows they belong to.

**First PIN** and **confirm PIN** — the two values PIN setup collects. They are two values and not one value entered twice: the confirm PIN can exist while the first PIN has since changed, which is precisely the state that has to be prevented rather than tolerated. User-facing labels: **Set your PIN (6-8 digits)** and **Confirm your PIN**.

**Mismatch** — the first PIN and the confirm PIN differ when the user accepts. It is a normal outcome of typing, not a failure of anything, and it leaves both values, the focus and the caret exactly where they were so the user can correct a digit. It shares its resting state with an operational failure — biometric, mnemonic, server — because both are answered identically, and it is reached differently: a mismatch never leaves *idle*, a failure always comes back out of *busy*.
_Avoid_: calling it an error in the copy the user reads. Nothing failed; two values differ.

**Busy** — the span between PIN setup sending the PIN and the client answering. It is a property of the *setup attempt*, not of the screen, so it outlives leaving and coming back: return mid-flight and the form is still dimmed, because the attempt is still out there. The user can start nothing while it lasts, and every field and every key says so. Nothing bounds it, so leaving the screen must stay possible throughout.
_Avoid_: reading it as "saved". The PIN is not set until the reply arrives, and the reply can be a failure, which returns the user to the same two values and lets the attempt be repeated. _Avoid_ also recording it twice — once on the form and once on the attempt. Two records of one fact drift, and the form's copy is the one that gets reset.

**Setup attempt** — one send of one PIN, and the unit a reply belongs to. Only one can be outstanding, and that is what makes a reply attributable: nothing on the wire says which send produced it. Leaving the screen does not end an attempt and nothing cancels it, so a reply outlives the screen and is still acted on — a PIN submitted is a PIN that may yet be enabled. Same rule as a Liquid Connect acceptance — see [ADR-0009](docs/adr/0009-liquid-connect-acceptance-attempt-identity.md) and [ADR-0013](docs/adr/0013-pin-setup-busy-state.md).
_Avoid_: treating "the setup screen is open" as the identity. Two attempts share one screen, and the second would inherit the first one's reply.

**PIN record** — the encrypted blob the PIN server returns, and the flag that says PIN protection is on. One thing in two halves, never written apart. The blob is the only way into a wallet whose flag is set, so a flag set beside a missing or stale blob is an unlock screen that waits for an answer nobody will send.
_Avoid_: speaking of "enabling PIN protection" as a separate act from storing the blob. Enabling *is* storing it; the flag alone is the failure.

**Wallet-losing state** — a raised PIN flag over a blob that is missing or not whole, or any moment in which no credential opens the wallet. It is the one state a *persist round* must never leave on disk, whatever fails inside it. See [ADR-0017](docs/adr/0017-refused-settings-write-ends-the-persist-round.md).
_Avoid_: "corrupt config" — the config parses fine; what is lost is the way in.

## Settings persistence

**Persist round** — one rewrite of the whole settings snapshot to the settings store, every key in one fixed order, queued behind the previous round. One state change starts one round; nothing writes a single key on its own. The next round is the repair for whatever an earlier one failed to land. See [ADR-0017](docs/adr/0017-refused-settings-write-ends-the-persist-round.md).
_Avoid_: "save" for one key — no key is saved alone.

**Refused write** — a write the settings store answered with `false` or with a throw. The app still holds the value; the disk does not. A refused write ends its *persist round*, and the round after it starts from what the disk holds. See [ADR-0017](docs/adr/0017-refused-settings-write-ends-the-persist-round.md).
_Avoid_: "silent failure" — it is logged with the key name.

## Sending

**Outputs payload** — a `sideswap_app` version `2` JSON document carrying a list of receivers, imported so that one transaction pays all of them. It enters the app through the desktop import and through no other surface; mobile declines it and says so. See [ADR-0012](docs/adr/0012-outputs-payload-desktop-import-only.md).
_Avoid_: "outputs file" (the same document arrives as a QR and as a file), "multi-output QR" (names a rejected entrance).

**Receiver** — one entry in an outputs payload: an address, an asset, an amount and an account. A payload with no receivers is not a payload with nothing to pay; it is invalid, and refused when it is decoded.
_Avoid_: "output" (that is the thing on the chain), "addressee" (that is the wire form).

**Addressee** — a receiver in the form the core is given it, inside a create-transaction request. The two words name the same pay-this-much-to-this-address fact on the two sides of the boundary, and the code should not swap them.

**Created transaction** — the core's answer to a create-transaction request: a transaction that is built and priced but not yet sent. It outlives the flow that produced it, and it survives being sent, so **its presence is never evidence that a screen asked for it**. A screen may render one; only the arrival of a fresh one may move the user. See [ADR-0012](docs/adr/0012-outputs-payload-desktop-import-only.md) decision 4.
_Avoid_: reading it as "the user is confirming a payment".

## Desktop window and layout

**Work area** — the part of a display an application window may occupy: the screen minus the taskbar, the dock, the menu bar or a panel. It is what the window is sized against, never the screen. All three desktops report it in logical pixels through `screen_retriever`. See [ADR-0014](docs/adr/0014-desktop-minimum-window-height.md).
_Avoid_: "screen size" and "resolution" as synonyms — a 1366x768 screen offers about 720 logical pixels of work area, and the difference is the whole defect ADR-0014 addresses.

**Chrome** — the part of a window the OS draws and the app does not: the title bar and the frame. It is the difference between the **outer window**, which is what `setSize` and `setMinimumSize` take, and the **client area**, which is what Flutter lays out in. Its size differs per platform and per theme, so it is measured rather than assumed, and it is measured differently on each desktop. On a GTK desktop with server-side decoration the chrome sits outside the window the toolkit reports, and the correct allowance is therefore zero.
_Avoid_: using "window size" without saying which of the two — every unit bug in this area is one of the pair standing in for the other.

**Supported floor** — the smallest client area every desktop surface must stay usable in: **620 x 1072 logical pixels**. It is a floor and not a design target. Nothing opens at it, every surface is tested at the design height as well, and the binding case that sets it is a 1280x720 Windows screen, which leaves 632 px of client height. A machine whose work area cannot hold the floor is below support: the window minimum yields rather than trapping the window. See [ADR-0014](docs/adr/0014-desktop-minimum-window-height.md) decisions 1 and 6.
_Avoid_: reading "usable" as "fits". A wallet that shows two assets fits and is not usable; the floor carries a task requirement, not a geometry requirement.

**Design height** — the height a desktop surface was laid out for, and the height it takes wherever there is room. A surface at its design height looks exactly as it does today and scrolls nothing.
_Avoid_: treating it as a maximum. It is the natural size; the surface may be given more room and simply not use it.

**Surface** — one desktop dialog, popup or page: a thing built on `DContentDialog`, `SideSwapPopupPage` or `DPopupWithClose`, or one of the four pages the navigation bar switches between. There are 64 of the first kind. It is the unit the *supported floor* applies to and the unit a layout test is written against.
_Avoid_: "screen" — that word is taken by the display.

**Scroll owner** — the one widget in a *surface* that scrolls its content. Exactly one: nested scrollables swallow the wheel, because Flutter stops propagating to the parent while the inner one can still move, so a second owner is a dead zone and not a safety net. The owner is either the wrapper or the content, stated explicitly, never inferred. Four popups state `child` while owning no scrollable at all: the value says the wrapper adds none, and #268 gives them a real owner. Nine surfaces own theirs today. See [ADR-0014](docs/adr/0014-desktop-minimum-window-height.md) decision 9.
_Avoid_: "scrollable" for the same idea — a surface may contain several, and only one of them owns the surface.

**Pinned action** — a control that stays visible whatever the window height, because it sits outside the scroll body rather than at the bottom of it. Every surface's primary action is pinned. This is the point of the layout work: a window short enough to scroll must never be a window whose Send, Confirm or Swap button has to be found first. One exception, recorded in the amendment to [ADR-0014](docs/adr/0014-desktop-minimum-window-height.md) decision 8: the markets order form keeps CONTINUE at the end of its scroll body, because at the *supported floor* a pinned band would hide the quote the user is about to accept, and a visible scrollbar thumb takes over the discoverability job there.
_Avoid_: reading it as a style rule. An action below the fold is an invisible defect that replaces a visible one, and it is the reason the scrolling half of PR #254 was not enough.

**Illustration block** — the 640 px tall box the four desktop onboarding surfaces centre their illustration in, built by `DOnboardingBlock`. It keeps a 24 px gap above itself at every window height, and it gives up its own height rather than grow, so at the *supported floor* it is 572 px and not 640 px. See [ADR-0014](docs/adr/0014-desktop-minimum-window-height.md) decision 6 for what happens below the floor.
_Avoid_: reading the 640 px as a guarantee. It is a design height the block sheds under pressure, and a consumer whose content needs more than 572 px overflows at the floor.

**Stored geometry** — the desktop window's last *normal* bounds and its maximized flag, written to the settings store while the app runs and read back at launch. It is a **hint the launch may ignore, never a command**. The launch restores it only when the whole rectangle lies inside one *work area* of one present display and every display reports the same scale factor; on any other answer the launch centres the window exactly as it does with nothing stored. A user who unplugs a monitor or changes the layout therefore always gets a visible window. Full-screen is never stored, and a minimized window never overwrites the bounds. See [ADR-0016](docs/adr/0016-desktop-window-geometry-persistence.md).
_Avoid_: "the saved window position" as a guarantee. The stored value survives a layout the app cannot honour, and the launch drops it silently rather than placing a window the user cannot see.

**Visit** — one continuous stay on one desktop navigation item. It ends only when the navigation item changes. A dialog opened over the item, a loading spinner inside it, and a rebuild of the desktop shell (the return from Settings does one) do not end it. The scroll offsets of the desktop address list and the desktop transaction list live exactly as long as the visit: they come back after a dialog or a shell rebuild, and they are gone on the next visit. The store that holds them is created with the visit and discarded with it, and it belongs to nothing that outlives the visit. The market product picker is not a visit-scoped list on either platform: it keeps a column offset across close and open by its own store, and the mobile transaction list keeps its offset through its route. #296 leaves both alone. See #296.
_Avoid_: "session" and "page state" — the first is taken by Liquid Connect, and the second suggests a store that outlives the visit, which is the defect #296 removes.

## Build pipeline

**Pinned rust commit** — the one commit of the public `sideswap-io/sideswap_rust` repository that a build of this repo is made against, written as a full 40-character SHA in `rust.sha` at the root. The two repositories share no history, so without the pin a build is not reproducible and a regression cannot be bisected. Moving the pin is a commit in this repo and a reviewable diff, never a side effect of somebody else's push. See [ADR-0015](docs/adr/0015-github-actions-builds.md).
_Avoid_: "the rust version" — the crate version in `Cargo.toml` is `0.1.2` and has not moved in a year; it identifies nothing.

**Rust libs bundle** — the archive of native libraries built from one *pinned rust commit*: `libsideswap_client.so` for `arm64-v8a`, `sideswap_client.dll` for Windows, and the four MinGW runtime libraries the DLL loads. It is built once per pin and stored as the assets of a *build prerelease* tagged `rust-libs-<sha>`. It is the expensive part of a build; everything else is minutes. The workflow builds it on a runner. `tools/build_local_release.py --build-rust` builds the same bundle in WSL on a developer machine, by a route that is not byte for byte reproducible.
_Avoid_: calling it a cache. A cache may be evicted and the build still succeeds slowly; this bundle is the only copy, and a build without it does not run.

**Build prerelease** — a GitHub release in this repo, always marked pre-release, whose only purpose is to carry files. Three kinds exist and they are pruned by different rules: `rust-libs-<sha>` holds a *rust libs bundle* and is kept as long as any pin refers to it; `build-<n>` holds one Windows archive and one debug APK made on a runner; and `local-<n>` holds the same two made on a developer machine. The last two share one counter and one pruning rule — the highest five survive, whichever side made them. A release is used rather than a workflow artifact because release assets do not consume the private repository's storage quota and do not expire.
_Avoid_: reading it as a release of the product. Nothing here is shipped to a user; the tag exists because GitHub attaches files to releases and to nothing else.

**CI build number** — the build number a *build prerelease* carries, rendered as `1.9.2+<n>`. It is one past the highest number any `build-<n>` or `local-<n>` release already holds, so it is a property of the release list rather than of the thing that built it, and it rises whichever side builds next.
_Avoid_: deriving it from `github.run_number`. That counts runs of one workflow and cannot see a package built on a developer machine, so the two sources drift and Android starts refusing installs. It counts CI runs and it is not the shipped build number, which is `5033` today and lives in `pubspec.yaml`. The two number lines cross deliberately: a CI build starts low, so installing one over a locally built APK needs a single uninstall.
_Avoid_: reasoning about it as if it were newer or older than the shipped number. It answers "which CI run", not "which version".
