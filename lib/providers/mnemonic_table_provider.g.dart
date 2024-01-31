// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mnemonic_table_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$wordListFutureHash() => r'4e95b3fa9cedc00ed07a88eb151d5f50c5a56cdd';

/// See also [wordListFuture].
@ProviderFor(wordListFuture)
final wordListFutureProvider = AutoDisposeFutureProvider<List<String>>.internal(
  wordListFuture,
  name: r'wordListFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$wordListFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef WordListFutureRef = AutoDisposeFutureProviderRef<List<String>>;
String _$currentMnemonicIndexNotifierHash() =>
    r'a65a762a7477c5df5ccbcc21658c12c0b5da13b6';

/// See also [CurrentMnemonicIndexNotifier].
@ProviderFor(CurrentMnemonicIndexNotifier)
final currentMnemonicIndexNotifierProvider =
    AutoDisposeNotifierProvider<CurrentMnemonicIndexNotifier, int>.internal(
  CurrentMnemonicIndexNotifier.new,
  name: r'currentMnemonicIndexNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMnemonicIndexNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentMnemonicIndexNotifier = AutoDisposeNotifier<int>;
String _$mnemonicWordsCounterNotifierHash() =>
    r'c7d1d4a52fcf275557cc20cec522ff3609ab8de6';

/// See also [MnemonicWordsCounterNotifier].
@ProviderFor(MnemonicWordsCounterNotifier)
final mnemonicWordsCounterNotifierProvider =
    NotifierProvider<MnemonicWordsCounterNotifier, int>.internal(
  MnemonicWordsCounterNotifier.new,
  name: r'mnemonicWordsCounterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mnemonicWordsCounterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MnemonicWordsCounterNotifier = Notifier<int>;
String _$mnemonicWordItemsNotifierHash() =>
    r'66405177fefb00bb4ac13a1b4134fa2951db36d4';

/// See also [MnemonicWordItemsNotifier].
@ProviderFor(MnemonicWordItemsNotifier)
final mnemonicWordItemsNotifierProvider =
    NotifierProvider<MnemonicWordItemsNotifier, Map<int, WordItem>>.internal(
  MnemonicWordItemsNotifier.new,
  name: r'mnemonicWordItemsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mnemonicWordItemsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MnemonicWordItemsNotifier = Notifier<Map<int, WordItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
