# Vendored `permission_handler_windows`

This directory is a copy of Baseflow's `permission_handler_windows`, carrying two patches.
`permission_handler` itself is **not** vendored — it comes from pub.dev like any other
dependency. Only the Windows federated implementation is substituted, through
`dependency_overrides` in the app's root `pubspec.yaml`.

The decision, and the invariant it protects, are recorded in
[ADR-0007](../../docs/adr/0007-vendored-permission-handler-windows.md).

## Upstream base

| | |
|---|---|
| Repository | <https://github.com/Baseflow/flutter-permission-handler> |
| Commit | `5c989b1be9abbbb325424ad96e5be4efdc0987c2` |
| Package version | `permission_handler_windows` 0.2.2 |
| Licence | MIT — see [`LICENSE`](LICENSE), retained verbatim |

`example/` is not vendored. Everything else is upstream's, byte for byte, except for the
patch below and three additions of ours: two `pubspec.yaml` edits — `resolution: workspace`
is dropped (we are not a member of upstream's pub workspace) and `publish_to: "none"` is
added — and a root `.gitignore`, since this package is consumed only as a path dependency
and a lockfile of its own would be churn.

## The patch

Upstream registers a `Geolocator::PositionChanged` handler in the plugin constructor.
Per the WinRT documentation, `LocationStatus` stays `Initializing` until the application
either calls `GetGeopositionAsync` or registers a `PositionChanged` handler — so that
registration is precisely what starts Windows location services, and upstream does it
deliberately, to make `IsLocationServiceEnabled` able to report a real status.

The constructor runs from `windows/flutter/generated_plugin_registrant.cc` at every
launch, whether or not Dart ever calls the plugin. SideSwap's desktop build therefore
appeared under **Settings → Privacy → Location** on every start. Users reported it.

SideSwap never calls `permission_handler` on desktop: `SideswapPermissionDesktopPlugin`
(`thirdparty/sideswap_permissions/lib/src/sideswap_permission_desktop.dart`) returns
fixed values and does not import the package. The only import of
`package:permission_handler/` in the repository is on the mobile-only path. The
subscription is therefore dropped:

```diff
--- upstream/permission_handler_windows_plugin.cpp
+++ windows/permission_handler_windows_plugin.cpp
@@ -65,7 +65,6 @@ class PermissionHandlerWindowsPlugin : public Plugin {
   winrt::Windows::Devices::Geolocation::Geolocator geolocator;
-  winrt::Windows::Devices::Geolocation::Geolocator::PositionChanged_revoker m_positionChangedRevoker;
 };
@@ -86,11 +85,14 @@ void PermissionHandlerWindowsPlugin::RegisterWithRegistrar(
 PermissionHandlerWindowsPlugin::PermissionHandlerWindowsPlugin(){
-  m_positionChangedRevoker = geolocator.PositionChanged(winrt::auto_revoke,
-    [this](Geolocator const& geolocator, PositionChangedEventArgs e)
-    {
-    });
 }
```

(plus the explanatory comment above the constructor.)

**Known consequence.** Without the handler, `LocationStatus()` returns `Initializing`,
which is `!= NotAvailable`, so `checkServiceStatus` for the location permission groups
always answers `ENABLED` on Windows and can never answer `DISABLED`. This is a real
divergence from upstream. It is unobservable in SideSwap, which never reaches that code,
and it is the reason the patch is not upstreamable as written — see
[This copy is permanent](#this-copy-is-permanent).

`upstream/permission_handler_windows_plugin.cpp` is the unmodified upstream file, kept
so the patch stays reviewable as a diff rather than as prose. It is not compiled:
`windows/CMakeLists.txt` lists its sources explicitly and does not glob.

## The second patch

Upstream's `windows/CMakeLists.txt` asks for C++20 and then also passes `/await`:

```diff
--- upstream/windows/CMakeLists.txt
+++ windows/CMakeLists.txt
@@
 target_compile_features(${PLUGIN_NAME} PRIVATE cxx_std_20)
-target_compile_options(${PLUGIN_NAME} PRIVATE /await)
```

`/await` selects the pre-standard `<experimental/coroutine>`. MSVC 14.51, which ships with
Visual Studio 18 and is what the `windows-latest` GitHub runner carries, turns that header
into a hard error:

```
error C2338: static assertion failed: 'error STL1011: The /await compiler option,
<experimental/coroutine>, <experimental/generator>, and <experimental/resumable> are
deprecated by Microsoft and will be REMOVED SOON.'
```

The option is redundant, not load-bearing. `cxx_std_20` on the line above already gives
`<coroutine>`, and C++/WinRT's `winrt::fire_and_forget` — the only coroutine this plugin
uses, in `IsBluetoothServiceEnabled` — works with the standard header. Dropping `/await`
therefore changes no behaviour and unblocks every toolchain from MSVC 14.51 onward.

`_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS` was rejected as the fix. It
suppresses the diagnostic without moving off a path Microsoft says will be removed, so it
buys one toolchain release and then fails again.

Unlike [The patch](#the-patch), this one **is** upstreamable as written and carries no
semantic divergence.

There is no `upstream/windows/CMakeLists.txt` copy beside the vendored one, and
`test/vendored_permission_handler_windows_test.dart` compares only
`permission_handler_windows_plugin.cpp`. This patch is therefore guarded by prose and by
review, not by a test.

## Before bumping `permission_handler`

`dependency_overrides` ignores version constraints **silently**. If a future
`permission_handler` requires `permission_handler_windows: ^0.3.0`, pub will substitute
this 0.2.2 copy without a word, and the failure surfaces as a compile error at best.

`test/vendored_permission_handler_windows_test.dart` guards both halves of that: it
asserts the vendored source still differs from `upstream/` by exactly the patch above,
and that the version declared here satisfies the constraint the resolved
`permission_handler` actually asks for. Run it (`flutter test`) after every bump.

To resync with a newer upstream: replace every file here from the new upstream tag,
re-apply the patch, update the commit and version in the table above, and update the
expected diff in the test.

## This copy is permanent

There is no plan to remove this directory. Upstreaming the fix was considered and
declined — SideSwap will not open a PR against Baseflow — so hand-maintaining the copy is
the accepted cost, not a stopgap. See decision 4 in
[ADR-0007](../../docs/adr/0007-vendored-permission-handler-windows.md).

That makes [Before bumping `permission_handler`](#before-bumping-permission_handler) the
important section of this file rather than a footnote. Read it every time.

If someone ever does reconsider: **do not send the patch in this repository.** It leaves
`checkServiceStatus` unable to report `DISABLED`, which is a semantic regression Baseflow
would reasonably refuse. The upstreamable form is lazy — move the registration into
`IsLocationServiceEnabled` so it happens on first use rather than at construction, which
preserves upstream's semantics exactly while still never touching location services in an
app that does not ask. The upstream code has been unchanged since
`9e41a02 Initial Windows Support (#789)` and has never been reported.
