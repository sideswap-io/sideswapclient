# Phase 0 research: Autosign for connected sites

Format: Decision / Rationale / Alternatives considered.

---

## 1. How does the app convert asset amounts to USDT (or USD notional)?

**Decision:** Use **`portfolioPricesProvider`** (`Map<String, double>`), populated from `From_PortfolioPrices.pricesUsd` in `SideswapWallet` when the server sends portfolio prices. For each value component, convert **smallest-unit integer** (protobuf `Balance.amount` / `AddressAmount.amount` / fee) to a **decimal human quantity** using the same **precision** as the rest of the app (`assetUtils.getPrecisionForAssetId`, same path as `amountToString` / `DNotificationSignBalances`), then multiply by `pricesUsd[assetId]`. Sum per component is not required by spec; **each** component must be ≤ **100** in that USD notional.

**Rationale:** Existing balance USD display uses human-readable amount × USD price (`assetBalanceInUsd` in `balances_provider.dart`). `amountUsdProvider(assetId, amount)` multiplies `portfolioPrices[assetId]` by a **numeric amount** directly; sign-request UI passes **smallest-unit** ints to `amountToStringNamed`, so autosign must **scale to human units before × price** to match portfolio price semantics (price per 1.0 asset unit in ticker precision).

**USDT vs USD:** The wire format is **`pricesUsd`**. FR-004 asks for “USDT equivalent”; there is no separate USDT oracle in-app. **Treat USD portfolio notional as the threshold currency** for this iteration (stablecoin peg assumption), unless product later requires pricing via a specific USDT asset id.

**Alternatives considered:** `conversionRatesProvider` / `defaultConversionRateMultiplierProvider` — those convert **display currency** (USD → user fiat), not per-asset notionals for arbitrary assets; wrong layer for per-component caps. Hardcoding USDT asset id — brittle across networks.

---

## 2. Is there an existing “authenticated” / unlock trigger callable from `wallet.dart`?

**Decision:** Yes — **`SideswapWallet.isAuthenticated()`** (`lib/providers/wallet.dart`). If PIN protection is on, it awaits **`ref.read(pinProtectionHelperProvider).pinBlockadeUnlocked()`** (`PinProtectionHelper.pinBlockadeUnlocked` in `pin_protection_provider.dart`), which shows the PIN UI when needed. Otherwise it decrypts mnemonic (biometric/fallback) and validates.

**Rationale:** Desktop sign notification accept already uses `ref.read(walletProvider).isAuthenticated()` before sending `To_SignerResponse(accept: true)` (`d_notifications.dart`).

**Alternatives considered:** Duplicating PIN flows — would drift from existing security behavior.

---

## 3. Does `_handleSignerRequest` validate origin vs active sessions (FR-011)?

**Decision:** **No.** Current code only forwards every `From_SignerRequest` to notifications:

```2231:2233:lib/providers/wallet.dart
  void _handleSignerRequest(From_SignerRequest signerRequest) {
    ref.read(notificationsProvider.notifier).addNotification(signerRequest);
  }
```

**Where to add FR-011:** At the **start** of sign-request handling (first branch for `hasSign()`), **before** autosign and **before** `addNotification`: resolve **`swaptionSessionProvider`** and require **at least one** `SwaptionSession` whose **`domain`** matches **`signerRequest.origin`** (define explicit equality rules: exact string match as shown in session list, unless product specifies URL normalization).

If no match: **silent ignore** — do **not** send `To_SignerResponse`, do **not** add a notification. Unknown origins are discarded entirely.

**Connect** requests (`hasConnect()`) are out of scope for autosign; keep existing `addNotification` behavior.

**Alternatives considered:** Validating only in UI — insufficient; requests must be rejected at wallet boundary.

---

## 4. Riverpod `keepAlive` for `autosign_provider`

**Decision:** Use **`@Riverpod(keepAlive: true)`** for the autosign notifier (or equivalent generated provider) that mirrors persisted settings.

**Rationale:** Matches **`configurationProvider`**, **`swaptionSessionProvider`**, **`notificationsProvider`**, and **`portfolioPricesProvider`** — long-lived app state that must survive short-lived listeners and align with wallet message handling.

**Alternatives considered:** Auto-dispose — risk of dropping in-memory map when no UI listens; persistence still in `SharedPreferences`, but unnecessary inconsistency with other settings-backed providers.

---

## 5. Async `_handleSignerRequest`

**Decision:** Make sign-request handling **`async`** and **`await`** it from **`_recvMsg`** (already `Future<void> _recvMsg`):

- Change case `From_Msg.signerRequest` to `await _handleSignerRequest(...)`.
- `_handleSignerRequest` becomes `Future<void>` to support `await isAuthenticated()`.

**Rationale:** Auto-accept path must await unlock without blocking the isolate incorrectly; `_recvMsg` is already async-capable.

---

## 6. Value components to include for FR-004

**Decision:** Evaluate **every** monetary line consistent with the sign UI:

| Component | Source | Asset id |
|-----------|--------|----------|
| Balances | `sign.balances[]` | `balance.assetId` |
| Recipients | `sign.recipients[]` | `recipient.assetId` |
| Network fee | `sign.networkFee` | **`liquidAssetIdStateProvider`** (same as `DNotificationsNetworkFee`) |

Skip or treat as **0 USD** only if a row has **no asset id** or **zero amount** after explicit rules (prefer: **zero amount → 0 USD** eligible; **missing asset id → conversion fails → fall through**).

**Rationale:** Matches user-visible “value components” in `d_notifications.dart` (balances, recipients, network fee).

---

## 7. Contracts / external APIs

**Decision:** No separate OpenAPI-style contract; behavior is app-internal protobuf + UI. Optional narrative only in `plan.md` / spec.

---

*Research complete — no remaining NEEDS CLARIFICATION items for implementation.*
