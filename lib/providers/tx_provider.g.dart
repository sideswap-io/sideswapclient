// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTxsSortedHash() => r'af028e95f0e8e8b32413880b9af6a9b510027812';

/// See also [allTxsSorted].
@ProviderFor(allTxsSorted)
final allTxsSortedProvider = AutoDisposeProvider<List<TransItem>>.internal(
  allTxsSorted,
  name: r'allTxsSortedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTxsSortedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllTxsSortedRef = AutoDisposeProviderRef<List<TransItem>>;
String _$allNewTxsSortedHash() => r'02ca6cf446fdd027627d1c33d2f5bd6efa4319fa';

/// See also [allNewTxsSorted].
@ProviderFor(allNewTxsSorted)
final allNewTxsSortedProvider = AutoDisposeProvider<List<TransItem>>.internal(
  allNewTxsSorted,
  name: r'allNewTxsSortedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allNewTxsSortedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllNewTxsSortedRef = AutoDisposeProviderRef<List<TransItem>>;
String _$allTxsNotifierHash() => r'54b9c9d194f6be22f95afa841d5eadfdea863748';

/// See also [AllTxsNotifier].
@ProviderFor(AllTxsNotifier)
final allTxsNotifierProvider =
    NotifierProvider<AllTxsNotifier, Map<String, TransItem>>.internal(
  AllTxsNotifier.new,
  name: r'allTxsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allTxsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AllTxsNotifier = Notifier<Map<String, TransItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
