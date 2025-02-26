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
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allTxsSortedHash,
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
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allNewTxsSortedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllNewTxsSortedRef = AutoDisposeProviderRef<List<TransItem>>;
String _$accountAssetTransactionsHash() =>
    r'5c2d4b7f4d77b162653b740e57a9275b9694cb2b';

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
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$accountAssetTransactionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AccountAssetTransactionsRef =
    AutoDisposeProviderRef<Map<AccountAsset, List<TxItem>>>;
String _$transactionsForAccountHash() =>
    r'4e8fd6e93122dbe3c259ea219fdb7ef0d5a99227';

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

/// See also [transactionsForAccount].
@ProviderFor(transactionsForAccount)
const transactionsForAccountProvider = TransactionsForAccountFamily();

/// See also [transactionsForAccount].
class TransactionsForAccountFamily extends Family<List<TxItem>> {
  /// See also [transactionsForAccount].
  const TransactionsForAccountFamily();

  /// See also [transactionsForAccount].
  TransactionsForAccountProvider call(AccountType accountType) {
    return TransactionsForAccountProvider(accountType);
  }

  @override
  TransactionsForAccountProvider getProviderOverride(
    covariant TransactionsForAccountProvider provider,
  ) {
    return call(provider.accountType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'transactionsForAccountProvider';
}

/// See also [transactionsForAccount].
class TransactionsForAccountProvider extends AutoDisposeProvider<List<TxItem>> {
  /// See also [transactionsForAccount].
  TransactionsForAccountProvider(AccountType accountType)
    : this._internal(
        (ref) => transactionsForAccount(
          ref as TransactionsForAccountRef,
          accountType,
        ),
        from: transactionsForAccountProvider,
        name: r'transactionsForAccountProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$transactionsForAccountHash,
        dependencies: TransactionsForAccountFamily._dependencies,
        allTransitiveDependencies:
            TransactionsForAccountFamily._allTransitiveDependencies,
        accountType: accountType,
      );

  TransactionsForAccountProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountType,
  }) : super.internal();

  final AccountType accountType;

  @override
  Override overrideWith(
    List<TxItem> Function(TransactionsForAccountRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TransactionsForAccountProvider._internal(
        (ref) => create(ref as TransactionsForAccountRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountType: accountType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<TxItem>> createElement() {
    return _TransactionsForAccountProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TransactionsForAccountProvider &&
        other.accountType == accountType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TransactionsForAccountRef on AutoDisposeProviderRef<List<TxItem>> {
  /// The parameter `accountType` of this provider.
  AccountType get accountType;
}

class _TransactionsForAccountProviderElement
    extends AutoDisposeProviderElement<List<TxItem>>
    with TransactionsForAccountRef {
  _TransactionsForAccountProviderElement(super.provider);

  @override
  AccountType get accountType =>
      (origin as TransactionsForAccountProvider).accountType;
}

String _$distinctTransactionsForAccountHash() =>
    r'c17e3303ea6b759884ab1136bcf41894290a775f';

/// See also [distinctTransactionsForAccount].
@ProviderFor(distinctTransactionsForAccount)
final distinctTransactionsForAccountProvider =
    AutoDisposeProvider<List<TxItem>>.internal(
      distinctTransactionsForAccount,
      name: r'distinctTransactionsForAccountProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$distinctTransactionsForAccountHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DistinctTransactionsForAccountRef =
    AutoDisposeProviderRef<List<TxItem>>;
String _$transItemHelperHash() => r'23a8ee55cc9dbeb533496f3ec0d60ad53940e47a';

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
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
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

String _$allTxsNotifierHash() => r'5e1bf1ea3581a2784c2288509c21744908a6ec36';

/// See also [AllTxsNotifier].
@ProviderFor(AllTxsNotifier)
final allTxsNotifierProvider =
    NotifierProvider<AllTxsNotifier, Map<String, TransItem>>.internal(
      AllTxsNotifier.new,
      name: r'allTxsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allTxsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AllTxsNotifier = Notifier<Map<String, TransItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
