# ADR-0007 — `permission_handler` comes from pub.dev; only its Windows implementation is vendored

- **Status:** Accepted and verified — issue #197. Implemented on `liquid-connect-acceptance-gate`. The vendored copy is **permanent and hand-maintained**; upstreaming was considered and declined (#198, #199, both closed `wontfix`).
- **Date:** 2026-08-14
- **Driver:** the question "can we drop the `permission_handler` fork and go back to the official plugin?" — which could not be answered, because the fork's reason for existing was recorded nowhere except a one-line commit subject.
- **Supersedes nothing.** Replaces the undocumented arrangement introduced by `245c467c` (2025-06-06).

## Context

`thirdparty/sideswap_permissions` depended on `permission_handler` through a git fork,
`malcolmpl/flutter-permission-handler`, pinned at `0486bb1`. Nothing in the repository
said why. The pubspec kept a commented-out `# permission_handler: ^12.0.0` above the git
block, which reads like a temporary experiment rather than a deliberate arrangement.

It was neither. The fork is three commits on top of Baseflow's `c438a1f` (February 2025),
and exactly one of them changes behaviour. Roughly 90% of its diff is a clang-format
reflow to Allman braces, which is what made the fork unreviewable and the question hard
to answer. Stripped of the churn, the entire fork is this, in
`permission_handler_windows/windows/permission_handler_windows_plugin.cpp`:

```diff
   winrt::Windows::Devices::Geolocation::Geolocator geolocator;
-  winrt::Windows::Devices::Geolocation::Geolocator::PositionChanged_revoker m_positionChangedRevoker;

 PermissionHandlerWindowsPlugin::PermissionHandlerWindowsPlugin(){
-  m_positionChangedRevoker = geolocator.PositionChanged(winrt::auto_revoke,
-    [this](Geolocator const& geolocator, PositionChangedEventArgs e) {});
 }
```

The commit that introduced it is `245c467c "Desktop - override issue for location in use
on windows"`. Users of the desktop build had reported seeing the Windows location
indicator on every launch.

### What the measurements showed

Seven facts constrain the design, and each one killed an option that looked reasonable.
Upstream citations are against `Baseflow/flutter-permission-handler` at
`5c989b1be9abbbb325424ad96e5be4efdc0987c2` (fetched 2026-08-14).

- **Registering the handler is what starts location services.** Per Microsoft's WinRT
  documentation, `Geolocator.LocationStatus` reports `Initializing` until the application
  either calls `GetGeopositionAsync` or registers a `PositionChanged` handler. Upstream
  registers one in the constructor precisely so `IsLocationServiceEnabled` can report a
  real status — the cost is not an oversight, it is the mechanism.
- **The constructor runs whether or not anyone calls the plugin.**
  `windows/flutter/generated_plugin_registrant.cc:26` invokes
  `PermissionHandlerWindowsPluginRegisterWithRegistrar` at every launch, and
  `windows/flutter/generated_plugins.cmake` lists `permission_handler_windows` among the
  linked plugins. Both files are generated from the resolved dependency graph, so the
  only way to keep the constructor from running is to change what that graph resolves to.
- **SideSwap never calls `permission_handler` on desktop.**
  `SideswapPermissionDesktopPlugin`
  (`thirdparty/sideswap_permissions/lib/src/sideswap_permission_desktop.dart`) returns
  fixed `false`/`true` values and does not import the package. The repository contains
  exactly one import of `package:permission_handler/`, in
  `thirdparty/sideswap_permissions/lib/src/permission_handler.dart`, reachable only from
  `sideswap_permission_mobile.dart`. The desktop cost bought nothing.
- **Upstream still has the code and never fixed it.** It is present on `main` today at
  lines 67–91, introduced by `9e41a02 "Initial Windows Support (#789)"` and untouched
  since. There is no upstream issue for it. "Wait for a release" is not an option
  because nobody has asked upstream for one.
- **The fork's five vendored packages are mostly inert.** `pubspec.lock` before this
  change resolved `permission_handler_android`, `_apple`, `_html` and
  `_platform_interface` from pub.dev regardless; only `permission_handler` and
  `permission_handler_windows` actually came from the fork. The maintenance surface was
  always 2 packages and one file, presented as 5.
- **A `dependency_overrides` entry substitutes a path package for a pub.dev one, and
  Flutter honours it end to end.** Verified empirically before committing to the design:
  the symlink under `windows/flutter/ephemeral/.plugin_symlinks/` points at the vendored
  directory and `generated_plugins.cmake` picks it up unchanged.
- **`permission_handler` 13.0.1 costs an Android toolchain bump and nothing else.** It
  requires `permission_handler_android` ^14.0.0, whose `android/build.gradle.kts` sets
  `compileSdk = 37`; Flutter 3.47 defaults `flutter.compileSdkVersion` to 36. Its only
  functional content over 12.0.3 is that compileSdk bump plus the unused
  `ACCESS_LOCAL_NETWORK` permission. `minSdk` (24) and Java 17 already matched.

## Decision

1. **`permission_handler` is an ordinary pub.dev dependency.** No git dependency, no
   forked monorepo, no `publish_to: none` edits to a package we do not own. It is
   currently `^13.0.1` in `thirdparty/sideswap_permissions/pubspec.yaml`.

2. **Only `permission_handler_windows` is vendored**, as `thirdparty/permission_handler_windows`,
   substituted through `dependency_overrides` in the root `pubspec.yaml`. It is upstream
   0.2.2 byte for byte, minus `example/`, minus `resolution: workspace`, plus
   `publish_to: "none"`, plus the patch above and a comment explaining it. Upstream's
   MIT `LICENSE` and `AUTHORS` are retained.

3. **The invariant: no SideSwap Windows build may register a
   `Geolocator::PositionChanged` handler in a plugin constructor.** Stated this way
   rather than as "keep the patch", because a future reader can satisfy "keep the patch"
   while reintroducing the behaviour through a resync, and violating this is visible in a
   diff. `test/vendored_permission_handler_windows_test.dart` enforces it mechanically.

4. **The vendored copy is permanent and maintained by hand. Nothing is upstreamed.**
   An earlier revision of this ADR called the copy temporary and named a PR to Baseflow as
   the exit. That was reconsidered and dropped: SideSwap will not open one, and the copy
   stays for as long as the app needs it. The cost is accepted deliberately — every
   `permission_handler` bump means re-reading the package's `UPSTREAM.md`, resyncing the
   copy against the new upstream release and re-applying the patch, and the drift test is
   what makes that a hard failure rather than a silent omission.

   For the record, since it would be the first question a future reader asks: the patch as
   written is *not* upstreamable, because it leaves `checkServiceStatus` unable to report
   `DISABLED`. An upstreamable form exists — register the handler lazily on first call
   inside `IsLocationServiceEnabled` instead of at construction, preserving upstream
   semantics while never touching location services in an app that does not ask. It was
   not pursued. Reopening this means writing that patch first; do not send the one in this
   repository.

5. **`compileSdk` is pinned to 37 in `android/app/build.gradle.kts`; `targetSdk`,
   `minSdk` and `ndkVersion` are not touched.** This is a compile-time requirement of
   `permission_handler_android` 14.0.0, not an opt-in to Android 17 runtime behaviour —
   those are separate changes and mixing them would make either one impossible to revert
   alone.

### Consequences accepted

- **`checkServiceStatus` for the location permission groups always answers `ENABLED` on
  Windows and can never answer `DISABLED`.** Unobservable in SideSwap by fact 3 above,
  and recorded in `UPSTREAM.md` so the next reader does not rediscover it as a bug.
- **`dependency_overrides` ignores version constraints silently.** If a future
  `permission_handler` requires `permission_handler_windows` ^0.3.0, pub substitutes the
  0.2.2 copy without a word. This is the sharpest edge of the design, and the second
  assertion in the drift test exists solely for it: it reads the constraint from the
  resolved `permission_handler`'s own pubspec through `.dart_tool/package_config.json`
  and fails if the vendored version no longer satisfies it. Offline, no network.
- **`compileSdkMinor` is required alongside `compileSdk = 37`, and is set to 0.** API 37
  ships only as minor-versioned platforms (`android-37.0`, `android-37.1`), so
  `compileSdk = 37` alone resolves to the hash string `android-37`, which does not exist,
  and Gradle fails with `Failed to find target with hash string 'android-37'`. Minor 0 is
  chosen because `android-37.0` is what Gradle provisions on its own — it installed it
  unprompted during the failing run — so no build machine needs a manual `sdkmanager`
  step. Both `compileSdkMinor = 1` (against a hand-installed `android-37.1`) and
  `compileSdkMinor = 0` were built and both work; 0 is kept for the zero-setup property.
  `permission_handler_android` 14.0.0 declares a plain `compileSdk = 37`, and Flutter's
  plugin-vs-app comparison passed under both.
- **Two dev dependencies were added** — `yaml` and `pub_semver`, both already present
  transitively — so the drift test can parse the resolved pubspec rather than pattern-match it.

### Rejected

- **Straight swap to the official plugin.** Reintroduces the reported bug. This was the
  question that opened the investigation, and facts 1, 2 and 4 are the answer to it.
- **Rebasing the fork onto current upstream.** Keeps a whole monorepo forked, and its
  `publish_to: none` and path-dependency edits, to carry five lines. A git-path dependency
  into upstream's now-`resolution: workspace` monorepo does still resolve — checked — so
  the option was available and was rejected on maintenance cost, not feasibility.
- **Removing the `Geolocator` entirely.** Bulletproof, but a behaviour change relative to
  the fork, and the fork's behaviour is exactly what this change set out to preserve — the
  source-equivalence result in [Verification](#verification) is only meaningful because
  nothing beyond the fork's own five lines was touched.
- **Upstreaming the fix to Baseflow.** Considered at length and declined; see decision 4.
  It would have ended the vendoring for good, at the cost of writing a different (lazy)
  patch and then waiting on a project that has not touched this file since 2021. Tracked
  as #198 and #199, both closed `wontfix`. Hand-maintaining the copy is the accepted cost.
- **Staying on 12.0.3 to avoid the Android bump.** Functionally free, and kept as the
  documented fallback while the compileSdk 37 build was unproven. It built, so the
  fallback was not taken.
- **A drift check that queries pub.dev.** Genuinely detects new upstream releases, but
  needs network and a deliberate run. The repository has no CI (`.github/workflows` does
  not exist), so a check nobody runs is worse than none — it reads as coverage that is
  not there.

## Verification

`flutter build windows --debug` and `flutter build apk --release --flavor full` both
succeed with the vendored package and `permission_handler` 13.0.1. The drift test passes,
and was mutation-checked: reinstating the subscription fails the first assertion and
declaring a stale version fails the second, both restored to green afterwards.

**The Windows privacy indicator turned out not to be observable on the development
machine, and the check that replaced it is better.** A release build did not appear under
Settings → Privacy → Location — but neither did a control build with the subscription
restored, so that observation proves nothing. Reading the store behind that UI,
`HKCU\...\CapabilityAccessManager\ConsentStore\location\NonPackaged`, explains why: it
holds 36 entries and the newest is 2026-03-07. Nothing on the machine has recorded
location access in five months.

The same store corroborates the driver retrospectively. It still carries
`2025-06-05 11:20` for the Release build and `2025-06-06 11:12` for the Debug build —
the latter forty-three minutes before `245c467c` was committed. Pre-fix builds did record
location access.

What establishes the result instead is source equivalence against the fork, which has
been in production for fourteen months. With comments and all whitespace stripped — which
collapses the fork's clang-format reflow — `permission_handler_windows_plugin.cpp` (5825
chars), its header (631) and `CMakeLists.txt` (1955) are character-identical to the
vendored copies. `permission_constants.h` differs by exactly one appended enum value,
`ACCESS_LOCAL_NETWORK = 40`, from the 0.2.1 → 0.2.2 bump; it shifts no existing ordinal
and the plugin never branches on it. This change was never "fix the indicator" — the fork
already fixed it — it was "carry that fix without a forked monorepo", and identical
sources are the direct proof of that.

On Android the permission flows were exercised on a device after a clean reinstall, since
`permission_handler_android` moved 13.0.1 → 14.0.0: the camera prompt in the QR scanner
grants and scans, a denial closes the screen instead of hanging, a re-entry after denial
closes again, and Jade's two Bluetooth prompts (`SCAN` then `CONNECT`) grant and proceed
while a denial leaves the app intact. Contacts are **not** part of this: the plugin
exposes `hasContactPermission` / `requestContactPermission`, but nothing in `lib/` calls
them and `READ_CONTACTS` is commented out in the manifest — dead surface, not a regression.

Still outstanding, and optional: the `sdkInt <= 30` branch of
`hasBluetoothConnectPermission`, which asks for `bluetooth` + `location` +
`locationWhenInUse` and is the only path in the app that touches location at all. It needs
an Android 11 or older device, and none was at hand.

## Related

- `thirdparty/permission_handler_windows/UPSTREAM.md` — upstream base, the patch, and the
  resync procedure.
- `test/vendored_permission_handler_windows_test.dart` — the two enforcement assertions.
- `CONTEXT.md` § *Third-party code under `thirdparty/`* — *vendored package*, *fork
  dependency* and *upstream drift*, the vocabulary this decision pinned down.
- #197 — this change, with the outstanding manual acceptance criteria.
- #198, #199 — the upstream PR and the subsequent removal of the vendoring. Both closed
  `wontfix`: hand-maintaining the copy was chosen over engaging with upstream.
