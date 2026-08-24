---
name: provider-test-standards
description: SideSwap Riverpod provider test standards (mocktail, overrides, state tracking). Use when writing or reviewing test/providers/.
---

# Provider Test Standards

## Quick reference

### Override choice

| Need | Method | Signature |
|------|--------|-----------|
| Replace functional provider | `overrideWith` | `(ref) => value` |
| Replace notifier instance | `overrideWith` | `() => MockNotifier()` |
| Replace only build(), keep notifier methods | `overrideWithBuild` | `(ref, notifier) => state` |
| Inject static leaf value (no deps) | `overrideWithValue` | `value` |

`overrideWithValue` skips `build()` entirely — `ref.watch`/`ref.listen` inside never run.
Use only for leaf providers with no reactive logic.

### Container API

| Method | When to use |
|--------|-------------|
| `container.read(p)` | One-shot value read |
| `container.listen(p, cb, fireImmediately: true)` | Track state change sequence |
| `await container.pump()` | Flush computed/async rebuilds after upstream mutation |
| `container.invalidate(p)` | Dispose + deferred rebuild (needs `pump()` if listeners exist) |
| `container.refresh(p)` | Dispose + immediate rebuild (returns `AsyncLoading` for async) |

### Mocktail essentials

| Pattern | Example |
|---------|---------|
| Stub sync | `when(() => m.get()).thenReturn(v)` |
| Stub async | `when(() => m.fetch()).thenAnswer((_) async => v)` |
| Stub void async | `when(() => m.run()).thenAnswer((_) async {})` |
| Verify called | `verify(() => m.save(any())).called(1)` |
| Verify never | `verifyNever(() => m.delete(any()))` |
| Verify order | `verifyInOrder([() => m.a(), () => m.b()])` |
| Capture | `verify(() => m.save(captureAny())).captured` → `List<dynamic>` |
| Fallback (custom types) | `setUpAll(() => registerFallbackValue(MyType()))` |

For detailed API docs (overrideWithBuild caveats, Mock vs Fake rules,
ref.listen testing, async provider testing) → read `references/api-reference.md`.

---

## Test scaffold — copy-paste template

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/TARGET_FILE.dart';

import '../utils.dart';

class MockDep extends Mock implements DepClass {}

void main() {
  setUpAll(() {
    // registerFallbackValue(MyType()); // if using any() with custom types
  });

  group('TargetNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test(
        overrides: [
          // depProvider.overrideWith((ref) => MockDep()),
        ],
      );
    });

    group('build', () {
      test('initial state when build has logic', () {
        final value = container.read(targetProvider);
        expect(value, expectedInitial);
      });
    });

    group('methodName', () {
      test('does X when condition Y', () {
        final listener = ProviderListener<StateType>();
        container.listen(targetProvider, listener.call, fireImmediately: true);

        // act
        container.read(targetProvider.notifier).methodName(arg);

        // verify state sequence
        verifyInOrder([
          () => listener(any(), initialState),
          () => listener(any(), expectedState),
        ]);
      });
    });
  });
}
```

---

## File conventions

- Test file: `test/providers/<provider_file>_test.dart`
- One test file per provider source file
- Do NOT test generated files (`*.g.dart`, `*.freezed.dart`)
- Import `../utils.dart` for `ProviderListener<T>`
- Import `../helpers/test_utils.dart` for `NoOpLogOutput` (logger suppression)

## What to test

Test **behaviour**, not implementation details:

- All conditional branches (`if`, `switch`, `?:`, `??`)
- Data transformations and calculations
- State change sequences (use `ProviderListener` + `verifyInOrder`)
- Error paths and edge cases (null, empty, boundary values)
- Side effects triggered by state changes

## What NOT to test — delete on sight

```dart
// ❌ trivial state setter with no branching logic
test('setAmpId updates state', () {
  notifier.setAmpId('x');
  expect(state, 'x');
});

// ❌ tautology
test('returns true', () => expect(true, true));

// ❌ tests only initial state when build() has no logic
test('initial state is empty', () {
  expect(container.read(myProvider), '');
});

// ❌ duplicate of another test hitting the same branch
test('setAmpId updates state to second value', () { ... });
```

**Exception:** keep initial-state tests when `build()` contains logic
(async loading, conditional initialisation, dependency reads).

## Test grouping

```dart
void main() {
  group('MyNotifier', () {
    group('build', () { ... });
    group('methodName', () { ... }); // one group per public method
    group('derivedValue', () { ... });
  });
}
```

## Test naming — describe behaviour, not method

```dart
// ✅
test('returns formatted amount with thousands separator when useNumberFormatter is true')
test('emits negative sign when amount is below zero')

// ❌
test('amountToString works')
test('test setAmpId')
```

## Table-driven tests for multi-branch functions

```dart
final cases = [
  (amount: Decimal.fromInt(1001), precision: 8, expected: 2),
  (amount: Decimal.fromInt(101),  precision: 8, expected: 3),
  (amount: Decimal.fromInt(11),   precision: 8, expected: 4),
  (amount: Decimal.one,           precision: 8, expected: 5),
  (amount: Decimal.zero,          precision: 8, expected: 8),
];

for (final c in cases) {
  test('returns ${c.expected} for amount ${c.amount} with precision ${c.precision}', () {
    expect(sut.scaleForAmount(c.amount, c.precision), c.expected);
  });
}
```

## State tracking pattern (ProviderListener)

Use `any()` for previous values — the preferred project pattern:

```dart
final listener = ProviderListener<String>();
container.listen(myProvider, listener.call, fireImmediately: true);

notifier.doSomething();

verifyInOrder([
  () => listener(any(), initialState),   // fireImmediately emission
  () => listener(any(), newState),        // after mutation
]);
```

For computed providers, call `await container.pump()` after upstream mutation
before verifying — computed rebuilds are async.

## Coverage requirement

Every provider must reach **100% line and branch coverage**.

```bash
flutter test test/providers/<file>_test.dart --coverage
dart run coverage:format_coverage \
  --lcov --in=coverage --out=coverage/lcov.info \
  --report-on=lib/providers/
# No DA:<n>,0 entries for lib/providers/<file>.dart = 100% covered
```
