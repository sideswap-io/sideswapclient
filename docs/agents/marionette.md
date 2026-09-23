# Marionette

`marionette_mcp` drives the running Flutter app through the Dart VM service. The app must register the `ext.flutter.marionette.*` extensions. `lib/start_app.dart` registers them in debug builds only, through `MarionetteBinding.ensureInitialized()` behind a `kDebugMode` guard. A release build compiles the branch out.

## One-time setup

```
dart pub global activate marionette_mcp 0.6.0
claude mcp add --transport stdio marionette -- marionette_mcp
```

The repository holds no `.mcp.json`. The MCP server is configured once in the user-scope Claude Code configuration.

## Version pairing

`marionette_mcp` refuses a `connect` when the binding version differs from its own. It compares `bindingVersion` against its own version in `vm_service_context.dart`. Therefore `marionette_flutter` in `pubspec.yaml` is pinned exactly (`marionette_flutter: 0.6.0`), not with a caret. When you move that pin, run `dart pub global activate marionette_mcp <same version>` in the same change.

## Run the app on Windows

Start the app with `flutter run -d windows`. This is the main procedure.

```
flutter run -d windows --debug
```

`flutter run` owns the process, so `hot_reload` and `hot_restart` work on this path.

An alternative path builds the application and starts the executable directly. Use it only when `flutter run` fails. Nothing owns the process on that path, so `hot_reload` and `hot_restart` cannot work.

```
flutter build windows --debug
build/windows/x64/runner/Debug/sideswap.exe
```

## One instance at a time

A stale `sideswap` process makes every new start exit 0 with an empty log. Kill it by name before each relaunch. From `cmd` or PowerShell:

```
taskkill /IM sideswap.exe /F
```

From Git Bash, which the Bash tool uses, double each slash. A single slash becomes a path.

```
taskkill //IM sideswap.exe //F
```

## Connect

`flutter run` prints the VM service URI to its console, in the form `A Dart VM Service on Windows is available at: http://127.0.0.1:<port>/<token>/`. A directly started executable prints `The Dart VM service is listening on http://127.0.0.1:<port>/<token>/`. Pass the WebSocket form to `connect`: replace the scheme with `ws` and append `ws`, so `ws://127.0.0.1:<port>/<token>/ws`.

After `connect` succeeds, use `get_interactive_elements` to list widgets, and `tap`, `enter_text`, `press_key`, `swipe` and `take_screenshots` to drive the app.

## Logs

This change wires no `logCollector`. `get_logs` answers with its "no collector configured" message. Wiring `marionette_logger` into `SideswapOutput` is separate work.

## Widget recognition

The default `MarionetteConfiguration` needs no change for this app. `DButton` renders a `GestureDetector` through `DHoverButton`. `CustomBigButton` renders a `TextButton`. Marionette recognizes both out of the box.
