# Testing standards

Binding rules for every change to production code in this repository. PRDs and ADRs do not need to repeat these; issues should reference this file in their Acceptance criteria.

## Coverage rules

- **Every new line of production code must be covered by a test added in the same change, and every modified line must have its test updated (or a new test added) in the same change.** There is no diff-coverage tool; this is enforced in review.
- **Provider files require 100% line and branch coverage.** Every Riverpod provider file (`lib/providers/**/*.dart`) must be at 100% and remain there after any change. This is the one automated gate — see the `provider-test-standards` skill for the full conventions.
- The 100% threshold is measured with generated files excluded — `dart run tools/coverage.dart` strips `**/*.g.dart` from `lcov.info` — so it covers hand-written lines only (relevant for providers with Riverpod codegen / `*.freezed.dart` companions).
- **Platform-gated branches are covered, not exempted.** A branch behind a `dart:io Platform.is*` check (e.g. the Windows multiline-subtitle split in `lib/providers/local_notifications_service.dart`) is verified with a platform-scoped test (`testOn: 'windows'` / `testOn: '!windows'`) rather than left uncovered. Prior art: `test/providers/local_notifications_service_test.dart`. **The 100% gate is authoritative on Windows**, where the Windows-scoped tests run. `dart run tools/coverage.dart` works on macOS and Linux too, but there every `testOn: 'windows'` test is skipped, so platform-gated branches are under-reported — a sub-100% provider figure from a non-Windows run is not by itself a coverage failure; confirm it on Windows.
- **Widget files have no line-coverage gate**, but every behavioural branch (visible/hidden, loading/loaded/error, ready/not-ready, …) must have an explicit test asserting that branch's externally observable output. (No widget-test prior art exists in the suite yet; the rule still applies to any widget change.)

## What makes a good test

Review criteria, not CI gates.

- Assert externally observable behaviour: pure-function output for given inputs, provider state transitions in response to upstream changes, widget tree composition under known provider overrides.
- Do **not** assert internal counters, the order of internal `await` boundaries, or implementation details of helper widgets. If a behaviour-preserving refactor breaks the test, the test was wrong.
- Prefer asserting behaviour over absolute call counts. When a count is genuinely meaningful, the per-test reset under [Test isolation](#test-isolation) is what makes it sound.
- Mocks stand in for the rust wallet (`MockWallet extends Mock implements SideswapWallet` with `mocktail`) and the backend connection at the provider boundary, and for **platform-plugin seams that a unit takes as an injected dependency** — never for a unit's own internal collaborators. The platform-plugin case has prior art across the suite: the `FlutterLocalNotificationsPlugin` seam is injected into `LocalNotificationService` and mocked in `test/providers/local_notifications_service_test.dart`, and that service is in turn mocked at the provider boundary in `test/providers/notifications_provider_test.dart`.
- For a unit whose **only** externally observable output is the call it makes to such a plugin (e.g. a unit whose sole effect is the notification it posts), that posted artifact **is** the observable behaviour: assert the behaviour-bearing facts of it — the routing `payload` carries `type`, the channel is the sign vs main channel — not the incidental fields a behaviour-preserving refactor would churn (notification id value, exact channel-detail flags).
- **Never use `@visibleForTesting`.** Do not widen a production member's visibility solely so a test can reach it. Test through a legitimately public surface instead: a public top-level function tested directly, a public method on a service read through its provider and exercised via `container.read(provider).method(...)`, or a test-local subclass that overrides a single method (purely in `test/`, no production change). Any existing `@visibleForTesting` is removed on sight.

## Test isolation

- **Reset every shared store in `setUp`, not `setUpAll`.** Anything built once in `setUpAll` and reused accumulates state across tests in the file — a `mocktail` mock records invocations, a backing store keeps its writes — which makes `verify(...).called(n)` and `isNull`/default-state assertions order-dependent. Reset per test, by store type:
  - `mocktail` mock (e.g. a `MockWallet`): `reset(mock)`
  - secure storage / shared prefs: `setMockInitialValues({})` (prior art: `test/providers/config_provider_test.dart`, `autosign_provider_test.dart`, `env_provider_test.dart`)
  - in-memory fake: `.reset()`
- Build a fresh `ProviderContainer.test(...)` in `setUp` and let the test framework dispose it (the project-wide pattern across `test/providers/`).
- **Never reset at the *end* of a test** — end-of-test cleanup is skipped when an earlier `expect` throws, leaving the store dirty for the next test. Always reset in `setUp`.
- Why this is invisible in declaration order, and how it is caught, is in [Verification before merge](#verification-before-merge).

## Test patterns and prior art

- **Pure helpers**: plain `test()` cases with literal inputs. Prior art: `test/parse_asset_amount_test.dart` (`satoshiRepository.parseAssetAmount`).
- **Riverpod providers**: `ProviderContainer.test` with `overrideWith` for upstream providers, `mocktail` for the wallet boundary, and `ProviderListener<T>` from `test/utils.dart` for state-transition assertions (`container.listen(p, listener.call, fireImmediately: true)` + `verifyInOrder`). Suppress logs with `NoOpLogOutput` from `test/helpers/test_utils.dart`; override `configurationProvider` with `FakeConfiguration` from `test/helpers/fake_configuration.dart`. Prior art: `test/providers/amount_to_string_provider_test.dart`, `test/providers/notifications_provider_test.dart`. See the `provider-test-standards` skill for the full template.
- **Widgets**: `ProviderScope` with `overrideWith` for the providers the widget watches, `pumpWidget` from `flutter_test`, `find.byType` / `find.text` / `find.byWidgetPredicate` for tree assertions. (No widget-test prior art in the suite yet.)

## TDD workflow

Red-green-refactor (see the `tdd` skill). Default order is bottom-up:

1. Pure helpers first — fastest feedback, densest edge-case coverage.
2. Provider thin wrappers second — verify reactivity (upstream change → re-emit) without re-asserting helper logic.
3. Widget integration third — verify composition and branch behaviour, with provider logic mocked via overrides.
4. Cleanup of dead code paths last — only after the new path is proven by the previous tests.

Top-down (failing widget test first) is acceptable when the user-facing behaviour is the primary unknown, but is not the default.

## Verification before merge

- `flutter analyze` on the changed files: no issues.
- `dart run tools/coverage.dart` — `flutter test --concurrency=16 --test-randomize-ordering-seed=random --no-test-assets --coverage`, then `lcov --remove` of `**/*.g.dart`, then `genhtml` — all tests pass; provider coverage at 100%. The single run covers both coverage and randomised ordering; add `--open` to open the HTML report. Runs on Windows, macOS and Linux (requires `lcov`: `choco install lcov` / `brew install lcov` / `apt install lcov`), but the 100% gate is authoritative on Windows — see [Coverage rules](#coverage-rules).
- The randomised seed is the only check that catches order-dependent test pollution: shared `setUpAll` state leaking between tests is invisible in declaration order, so it passes a fixed-order `flutter test` locally while failing under another seed. A test that passes alone and in declaration order but fails under a seed is at fault, not the production code. Reproduce a suspected leak with `flutter test <file> --test-randomize-ordering-seed=<n>` across several seeds.
- Manual test on device for any change with user-visible UI behaviour, with the steps captured in the issue's Acceptance criteria.
