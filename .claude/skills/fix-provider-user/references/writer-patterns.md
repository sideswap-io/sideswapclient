# Writer Patterns

Inject these into all Writer and Fix subagent prompts.

## Logger (prevents path_provider crash)

```dart
import 'package:logger/logger.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_logger/custom_logger.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

setUpAll(() {
  logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
});
```

## Riverpod Test Setup

```dart
final container = ProviderContainer.test(
  overrides: [
    // overrides here
  ],
);
addTearDown(container.dispose);
```

## Riverpod Gotchas

**`container.pump()`** — required after mutations when testing computed/derived providers. Without it, listeners won't fire and assertions on downstream state will fail.

**`overrideWithValue` breaks dependency chain** — never use it for providers that have dependencies. Use `overrideWithBuild((ref, notifier) => ...)` instead, which preserves the ref and lets the provider watch its dependencies.

**`ref.listen` testing** — to test ref.listen callbacks, mutate the upstream notifier's state directly. Don't use `overrideWithValue` to swap values — that bypasses the listen mechanism.

## Coverage Check (manual verification)

```bash
flutter test test/providers/<file>_test.dart --coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib/providers/
grep "DA:.*,0" coverage/lcov.info | grep <stem>
```
