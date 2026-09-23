# Writer Patterns

Inject these into all Writer and Fix subagent prompts.

## Logger (prevents path_provider crash)

```dart
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/test_utils.dart';

setUp(() {
  logger = CustomLogger('SideSwap', output: NoOpLogOutput());
});
```

## Riverpod Test Setup

```dart
final container = ProviderContainer.test(
  overrides: [
    // overrides here
  ],
);
```

## Riverpod Gotchas

**`overrideWithBuild` signature.** Some docs show `(ref)`. The actual typedef is
`RunNotifierBuild<NotifierT, CreatedT> = CreatedT Function(Ref ref, NotifierT notifier)`.
Always pass two arguments: `(ref, notifier) => value`.

**`container.pump()`** — required after mutations when testing computed/derived providers. Without it, listeners won't fire and assertions on downstream state will fail.

**`overrideWithValue` breaks dependency chain** — never use it for providers that have dependencies. Use `overrideWithBuild((ref, notifier) => ...)` instead, which preserves the ref and lets the provider watch its dependencies.

**`ref.listen` testing** — to test ref.listen callbacks, mutate the upstream notifier's state directly. Don't use `overrideWithValue` to swap values — that bypasses the listen mechanism.

## Coverage Check

Run `dart run tools/coverage.dart`. `docs/TESTING.md` states the rule and reads the figure.
