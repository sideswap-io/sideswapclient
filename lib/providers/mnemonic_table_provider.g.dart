// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mnemonic_table_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentMnemonicIndexNotifier)
final currentMnemonicIndexProvider = CurrentMnemonicIndexNotifierProvider._();

final class CurrentMnemonicIndexNotifierProvider
    extends $NotifierProvider<CurrentMnemonicIndexNotifier, int> {
  CurrentMnemonicIndexNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentMnemonicIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentMnemonicIndexNotifierHash();

  @$internal
  @override
  CurrentMnemonicIndexNotifier create() => CurrentMnemonicIndexNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$currentMnemonicIndexNotifierHash() =>
    r'a65a762a7477c5df5ccbcc21658c12c0b5da13b6';

abstract class _$CurrentMnemonicIndexNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(wordListFuture)
final wordListFutureProvider = WordListFutureProvider._();

final class WordListFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  WordListFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'wordListFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$wordListFutureHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return wordListFuture(ref);
  }
}

String _$wordListFutureHash() => r'5cbab2211b41a3434e8fe43c6517e021b2207e4d';

@ProviderFor(MnemonicWordsCounterNotifier)
final mnemonicWordsCounterProvider = MnemonicWordsCounterNotifierProvider._();

final class MnemonicWordsCounterNotifierProvider
    extends $NotifierProvider<MnemonicWordsCounterNotifier, int> {
  MnemonicWordsCounterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mnemonicWordsCounterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mnemonicWordsCounterNotifierHash();

  @$internal
  @override
  MnemonicWordsCounterNotifier create() => MnemonicWordsCounterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$mnemonicWordsCounterNotifierHash() =>
    r'c7d1d4a52fcf275557cc20cec522ff3609ab8de6';

abstract class _$MnemonicWordsCounterNotifier extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MnemonicWordItemsNotifier)
final mnemonicWordItemsProvider = MnemonicWordItemsNotifierProvider._();

final class MnemonicWordItemsNotifierProvider
    extends $NotifierProvider<MnemonicWordItemsNotifier, Map<int, WordItem>> {
  MnemonicWordItemsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mnemonicWordItemsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mnemonicWordItemsNotifierHash();

  @$internal
  @override
  MnemonicWordItemsNotifier create() => MnemonicWordItemsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, WordItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, WordItem>>(value),
    );
  }
}

String _$mnemonicWordItemsNotifierHash() =>
    r'fb0f5377b2b4e2d30f5a6b9869dd9b15e3bed201';

abstract class _$MnemonicWordItemsNotifier
    extends $Notifier<Map<int, WordItem>> {
  Map<int, WordItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<int, WordItem>, Map<int, WordItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, WordItem>, Map<int, WordItem>>,
              Map<int, WordItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
