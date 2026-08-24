# API Reference — Riverpod Testing & Mocktail

Read this file when you need detailed API semantics beyond the quick reference
in SKILL.md. Organized by library.

---

## Riverpod — Override Strategy

### `overrideWith` — replace provider creation

Use for functional providers (`Provider`, `FutureProvider`, `StreamProvider`)
or to replace entire notifier instance.

```dart
// functional provider — callback receives ref
myProvider.overrideWith((ref) => fakeValue)

// notifier provider — factory function, no ref
myNotifierProvider.overrideWith(() => MockMyNotifier())
```

### `overrideWithValue` — static value, no ref

Replaces the provider entirely with a static value — the original `build()`
body (including any `ref.watch`/`ref.listen` calls) **never executes**.
Use only when you don't need the provider's internal reactive logic.

```dart
// ✅ leaf provider, no deps
liquidAssetIdStateProvider.overrideWithValue('asset-id')

// ❌ WRONG — provider uses ref.watch internally, build() never runs
configProvider.overrideWithValue(Config(...))
```

### `overrideWithBuild` — replace only build(), preserve notifier

Replaces the `build()` method while keeping the real notifier instance.
Second callback parameter is the notifier itself — that's why public methods
still work. Ideal for testing notifier methods with controlled initial state.

```dart
myNotifierProvider.overrideWithBuild(
  (ref, notifier) => initialState,
)
```

**Caveat:** `build()` logic (ref.watch, ref.listen inside build) is replaced.
The notifier's public methods work because the instance is real.

---

## Riverpod — Container API

### `container.read(provider)` — one-shot read

```dart
final value = container.read(myProvider);
expect(value, expected);
```

### `container.listen(provider, listener)` — track state changes

Returns `ProviderSubscription<T>` with `.close()` (cancel) and `.read()` (current value).

```dart
final listener = ProviderListener<MyState>();
final sub = container.listen(myProvider, listener.call, fireImmediately: true);

final current = sub.read();  // read without separate container.read
sub.close();                  // cancel subscription early
```

`fireImmediately: true` — calls listener immediately with current value
(`previous` is `null` on first call).

### `container.pump()` — flush async/computed providers

Awaits for providers to rebuild/be disposed and for listeners to be notified.
Required when a listener observes a **computed provider** after mutating
its upstream dependency.

```dart
notifier.updateUpstream(newValue);
await container.pump(); // flush pending rebuilds

verify(() => listener(any(), newDerived)).called(1);
```

### `container.invalidate(provider)` — force re-evaluation

Disposes state immediately. Rebuild is deferred — typically next event loop
tick if the provider has active listeners, or delayed until next read/listen
if it does not.

```dart
container.invalidate(myProvider);
await container.pump(); // only needed if provider has active listeners
```

### `container.refresh(provider)` — force immediate rebuild

Like invalidate but returns new value synchronously.
For async providers returns `AsyncLoading` — resolved value not yet available.

```dart
final newValue = container.refresh(myProvider);
```

---

## Riverpod — Testing Patterns

### Testing ref.listen side effects

When a provider uses `ref.listen` to react to another provider, test by
**mutating the upstream notifier** — never by overrideWithValue on the
listened provider (that kills the reactive chain since build() never runs).

```dart
// provider under test uses: ref.listen(upstreamProvider, ...)
setUp(() {
  container = ProviderContainer.test(
    overrides: [
      upstreamProvider.overrideWithBuild((ref, notifier) => initialValue),
    ],
  );
});

test('reacts to upstream changes', () {
  final upstream = container.read(upstreamProvider.notifier);
  upstream.setValue(newValue);

  expect(container.read(providerUnderTest), expectedReaction);
});
```

### Testing async providers

```dart
test('loads data successfully', () async {
  final container = ProviderContainer.test(
    overrides: [
      apiProvider.overrideWith((ref) => mockApi),
    ],
  );

  // initial state is loading
  expect(container.read(myAsyncProvider), const AsyncLoading<Data>());

  await container.pump();

  expect(container.read(myAsyncProvider), AsyncData<Data>(expectedData));
});
```

---

## Mocktail — Mock vs Fake

- **`Mock`** — stub/verify via `when`/`verify`. No manual `@override` methods
  (those bypass mocktail's tracking). Use for dependencies where you control return values.
- **`Fake`** — manual `@override` implementations, throws `UnimplementedError`
  for non-overridden methods. Use when you need partial real behaviour.

```dart
class MockWallet extends Mock implements Wallet {}

class FakeWallet extends Fake implements Wallet {
  @override
  String get name => 'test-wallet';
}
```

### Mock declaration — top of test file, outside main()

```dart
class MockApi extends Mock implements ApiService {}
class MockWallet extends Mock implements Wallet {}
```

---

## Mocktail — Stubbing

```dart
// sync return
when(() => mock.getValue()).thenReturn('result');

// async return — thenAnswer, NOT thenReturn (throws for Future/Stream)
when(() => mock.fetchData()).thenAnswer((_) async => data);

// void-returning async method
when(() => mock.doSomething()).thenAnswer((_) async {});

// throw
when(() => mock.riskyCall()).thenThrow(Exception('fail'));

// argument matchers
when(() => mock.process(any())).thenReturn(true);
when(() => mock.find(any(that: startsWith('test')))).thenReturn(item);
```

---

## Mocktail — Verification

```dart
// called exactly once
verify(() => mock.save(expectedArg)).called(1);

// never called — do NOT use verify(...).called(0)
verifyNever(() => mock.delete(any()));

// ordered sequence
verifyInOrder([
  () => mock.init(),
  () => mock.process(any()),
  () => mock.close(),
]);

// capture arguments — flat list of all captured values across matched calls
verify(() => mock.save(captureAny())).captured; // List<dynamic>

// interaction guards
verifyZeroInteractions(mock);        // no interactions at all
verifyNoMoreInteractions(mock);      // no unverified interactions remain
```

**Note:** each `verify` call excludes matched calls from future verifications.

---

## Mocktail — registerFallbackValue

Required for `any()` / `captureAny()` with custom types.
Call once per type in `setUpAll`. Primitives are auto-registered.

```dart
setUpAll(() {
  registerFallbackValue(MyCustomType());
});
```

---

## Mocktail — reset

Clear stubs AND recorded interactions for a mock:

```dart
reset(mockApi);
```

---

## Project Utilities

### `ProviderListener<T>` — `test/utils.dart`

A Mock-based callable class matching `container.listen` signature:

```dart
class ProviderListener<T> extends Mock {
  void call(T? previous, T next);
}
```

### `NoOpLogOutput` — `test/helpers/test_utils.dart`

Suppress logger output in tests:

```dart
final container = ProviderContainer.test(
  overrides: [
    loggerProvider.overrideWith((ref) => Logger(output: NoOpLogOutput())),
  ],
);
```
