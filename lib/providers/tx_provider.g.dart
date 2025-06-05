// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allTxsSortedHash() => r'5b86b4c5a01de97c59304ad83a0aaac222869731';

/// See also [allTxsSorted].
@ProviderFor(allTxsSorted)
final allTxsSortedProvider = AutoDisposeProvider<List<TransItem>>.internal(
  allTxsSorted,
  name: r'allTxsSortedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allTxsSortedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllTxsSortedRef = AutoDisposeProviderRef<List<TransItem>>;
String _$allNewTxsSortedHash() => r'ef0553a60d0973cb7475a27d812df09433ba78d1';

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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllNewTxsSortedRef = AutoDisposeProviderRef<List<TransItem>>;
String _$accountAssetTransactionsHash() =>
    r'47022ce38e1c51ff2dc79d21b248817bd789bef0';

/// Returns map of AccountAsset and list of TxItem.
/// List of TxItem is based on tx balances list. Balances list can include multiple different assets.
/// AccountAsset hold AccountType and assetId information.
/// Each pair of AccountAsset and list of TxItem can hold duplicates of TxItem.
///
/// Copied from [accountAssetTransactions].
@ProviderFor(accountAssetTransactions)
final accountAssetTransactionsProvider =
    AutoDisposeProvider<Map<AccountAsset, List<TxItem>>>.internal(
      accountAssetTransactions,
      name: r'accountAssetTransactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountAssetTransactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountAssetTransactionsRef =
    AutoDisposeProviderRef<Map<AccountAsset, List<TxItem>>>;
String _$assetTransactionsHash() => r'8c454b291be9d516619120910da9cfd06954572c';

/// See also [assetTransactions].
@ProviderFor(assetTransactions)
final assetTransactionsProvider =
    AutoDisposeProvider<Map<String, List<TxItem>>>.internal(
      assetTransactions,
      name: r'assetTransactionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$assetTransactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AssetTransactionsRef =
    AutoDisposeProviderRef<Map<String, List<TxItem>>>;
String _$distinctTransactionsForAccountHash() =>
    r'c17e3303ea6b759884ab1136bcf41894290a775f';

/// See also [distinctTransactionsForAccount].
@ProviderFor(distinctTransactionsForAccount)
final distinctTransactionsForAccountProvider =
    AutoDisposeProvider<List<TxItem>>.internal(
      distinctTransactionsForAccount,
      name: r'distinctTransactionsForAccountProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$distinctTransactionsForAccountHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DistinctTransactionsForAccountRef =
    AutoDisposeProviderRef<List<TxItem>>;
String _$transItemHelperHash() => r'fd1c3c8b842ae65aa33e9c1fe384c70f37a7dd5c';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [transItemHelper].
@ProviderFor(transItemHelper)
const transItemHelperProvider = TransItemHelperFamily();

/// See also [transItemHelper].
class TransItemHelperFamily extends Family<TransItemHelper> {
  /// See also [transItemHelper].
  const TransItemHelperFamily();

  /// See also [transItemHelper].
  TransItemHelperProvider call(TransItem transItem) {
    return TransItemHelperProvider(transItem);
  }

  @override
  TransItemHelperProvider getProviderOverride(
    covariant TransItemHelperProvider provider,
  ) {
    return call(provider.transItem);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transItemHelperProvider';
}

/// See also [transItemHelper].
class TransItemHelperProvider extends AutoDisposeProvider<TransItemHelper> {
  /// See also [transItemHelper].
  TransItemHelperProvider(TransItem transItem)
    : this._internal(
        (ref) => transItemHelper(ref as TransItemHelperRef, transItem),
        from: transItemHelperProvider,
        name: r'transItemHelperProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$transItemHelperHash,
        dependencies: TransItemHelperFamily._dependencies,
        allTransitiveDependencies:
            TransItemHelperFamily._allTransitiveDependencies,
        transItem: transItem,
      );

  TransItemHelperProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.transItem,
  }) : super.internal();

  final TransItem transItem;

  @override
  Override overrideWith(
    TransItemHelper Function(TransItemHelperRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransItemHelperProvider._internal(
        (ref) => create(ref as TransItemHelperRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        transItem: transItem,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<TransItemHelper> createElement() {
    return _TransItemHelperProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransItemHelperProvider && other.transItem == transItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, transItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransItemHelperRef on AutoDisposeProviderRef<TransItemHelper> {
  /// The parameter `transItem` of this provider.
  TransItem get transItem;
}

class _TransItemHelperProviderElement
    extends AutoDisposeProviderElement<TransItemHelper>
    with TransItemHelperRef {
  _TransItemHelperProviderElement(super.provider);

  @override
  TransItem get transItem => (origin as TransItemHelperProvider).transItem;
}

String _$loadTransactionsStateNotifierHash() =>
    r'9fd91d0c39b7a51bd740f7e518949f4cdbeaf082';

/// See also [LoadTransactionsStateNotifier].
@ProviderFor(LoadTransactionsStateNotifier)
final loadTransactionsStateNotifierProvider =
    AutoDisposeNotifierProvider<
      LoadTransactionsStateNotifier,
      LoadTransactionsState
    >.internal(
      LoadTransactionsStateNotifier.new,
      name: r'loadTransactionsStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$loadTransactionsStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LoadTransactionsStateNotifier =
    AutoDisposeNotifier<LoadTransactionsState>;
String _$allTxsNotifierHash() => r'74f3c3e6653b873271e3cb7d219b35293bcde25d';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
