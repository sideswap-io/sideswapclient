# Quickstart: implement autosign (001-autosign-notifications)

1. **Config:** Add `autosignDomains` to `SideswapSettings` + read/write in `Configuration` (`config_provider.dart`). Run `dart run build_runner build`.
2. **Provider:** Add `lib/providers/autosign_provider.dart` (`@Riverpod(keepAlive: true)`, codegen) — `isAutosign` / `setAutosign` / `removeAutosign`; delegate persistence to `configurationProvider`.
3. **USD threshold helper:** Add testable helper (same file or `autosign_usd_threshold.dart`) using `portfolioPricesProvider`, `assetUtilsProvider`, `liquidAssetIdStateProvider`, `amountToString` pattern for smallest-unit → decimal; constant **100** USD notional per component.
4. **Wallet:** In `SideswapWallet`, make `_handleSignerRequest` async; `await` from `_recvMsg`. Implement FR-011, autosign branch (auth → `To_SignerResponse` accept, no notification), reject paths (no notification when spec says drop).
5. **Disconnect:** In `_handleSessionRemoved`, resolve domain by `sessionId`, `removeAutosign(domain)`, then `removeSessions`.
6. **UI:** In `SwaptionDomainItem`, add **Autosign** `Checkbox` bound to `autosignProvider`; `setAutosign(domain, value)`.
7. **i18n:** Add short label key for “Autosign” (English).
8. **Tests:** `test/providers/autosign_provider_test.dart`, extend `config_provider_test.dart`; **no** `wallet.dart` tests. Coverage target for new/changed implementation files only.

See `plan.md` for full structure and edge cases.
