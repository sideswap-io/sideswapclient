// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$predefinedAccountAssetsHash() =>
    r'abca1708ec6e08ed4f1ba2c21dfd975de8f2fd4f';

/// See also [predefinedAccountAssets].
@ProviderFor(predefinedAccountAssets)
final predefinedAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  predefinedAccountAssets,
  name: r'predefinedAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$predefinedAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PredefinedAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$allAlwaysShowAccountAssetsHash() =>
    r'ee4ba83fc5316634c4a6cc28385c49bf57f498e8';

/// Needed by ui which want to display limited list of assets - ex. home page wallet
///
///
/// Copied from [allAlwaysShowAccountAssets].
@ProviderFor(allAlwaysShowAccountAssets)
final allAlwaysShowAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  allAlwaysShowAccountAssets,
  name: r'allAlwaysShowAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allAlwaysShowAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllAlwaysShowAccountAssetsRef
    = AutoDisposeProviderRef<List<AccountAsset>>;
String _$allVisibleAccountAssetsHash() =>
    r'696c25f8710b15231c5e3b79685f8603b151dddc';

/// See also [allVisibleAccountAssets].
@ProviderFor(allVisibleAccountAssets)
final allVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  allVisibleAccountAssets,
  name: r'allVisibleAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allVisibleAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllVisibleAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$regularVisibleAccountAssetsHash() =>
    r'bac960fc5ade1ab3bd428fb241c591ceceeef0ab';

/// See also [regularVisibleAccountAssets].
@ProviderFor(regularVisibleAccountAssets)
final regularVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  regularVisibleAccountAssets,
  name: r'regularVisibleAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$regularVisibleAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RegularVisibleAccountAssetsRef
    = AutoDisposeProviderRef<List<AccountAsset>>;
String _$ampVisibleAccountAssetsHash() =>
    r'3589e30b440b49fb2f394553d80476abb438a8d6';

/// See also [ampVisibleAccountAssets].
@ProviderFor(ampVisibleAccountAssets)
final ampVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  ampVisibleAccountAssets,
  name: r'ampVisibleAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ampVisibleAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AmpVisibleAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$allAccountAssetsHash() => r'5cd184c82061dbf59d79167a4746fcdb47ec1c53';

/// Needed by ui parts which want to search assetid over all assets - ex. market
///
///
/// Copied from [allAccountAssets].
@ProviderFor(allAccountAssets)
final allAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  allAccountAssets,
  name: r'allAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$regularAccountAssetsHash() =>
    r'85dfb1d6ba77da48af44f01727b143fd67482d8d';

/// See also [regularAccountAssets].
@ProviderFor(regularAccountAssets)
final regularAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  regularAccountAssets,
  name: r'regularAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$regularAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef RegularAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$ampAccountAssetsHash() => r'a09cc1c6e7f263dae6e124bdea1b4cb27b9f6e55';

/// See also [ampAccountAssets].
@ProviderFor(ampAccountAssets)
final ampAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
  ampAccountAssets,
  name: r'ampAccountAssetsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ampAccountAssetsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AmpAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$marketTypeForAccountAssetHash() =>
    r'8626f6ea676e820fcef7b1944dacebb24e66de50';

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

/// See also [marketTypeForAccountAsset].
@ProviderFor(marketTypeForAccountAsset)
const marketTypeForAccountAssetProvider = MarketTypeForAccountAssetFamily();

/// See also [marketTypeForAccountAsset].
class MarketTypeForAccountAssetFamily extends Family<MarketType> {
  /// See also [marketTypeForAccountAsset].
  const MarketTypeForAccountAssetFamily();

  /// See also [marketTypeForAccountAsset].
  MarketTypeForAccountAssetProvider call(
    AccountAsset? accountAsset,
  ) {
    return MarketTypeForAccountAssetProvider(
      accountAsset,
    );
  }

  @override
  MarketTypeForAccountAssetProvider getProviderOverride(
    covariant MarketTypeForAccountAssetProvider provider,
  ) {
    return call(
      provider.accountAsset,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'marketTypeForAccountAssetProvider';
}

/// See also [marketTypeForAccountAsset].
class MarketTypeForAccountAssetProvider
    extends AutoDisposeProvider<MarketType> {
  /// See also [marketTypeForAccountAsset].
  MarketTypeForAccountAssetProvider(
    AccountAsset? accountAsset,
  ) : this._internal(
          (ref) => marketTypeForAccountAsset(
            ref as MarketTypeForAccountAssetRef,
            accountAsset,
          ),
          from: marketTypeForAccountAssetProvider,
          name: r'marketTypeForAccountAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marketTypeForAccountAssetHash,
          dependencies: MarketTypeForAccountAssetFamily._dependencies,
          allTransitiveDependencies:
              MarketTypeForAccountAssetFamily._allTransitiveDependencies,
          accountAsset: accountAsset,
        );

  MarketTypeForAccountAssetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.accountAsset,
  }) : super.internal();

  final AccountAsset? accountAsset;

  @override
  Override overrideWith(
    MarketType Function(MarketTypeForAccountAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarketTypeForAccountAssetProvider._internal(
        (ref) => create(ref as MarketTypeForAccountAssetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        accountAsset: accountAsset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<MarketType> createElement() {
    return _MarketTypeForAccountAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketTypeForAccountAssetProvider &&
        other.accountAsset == accountAsset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, accountAsset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MarketTypeForAccountAssetRef on AutoDisposeProviderRef<MarketType> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset? get accountAsset;
}

class _MarketTypeForAccountAssetProviderElement
    extends AutoDisposeProviderElement<MarketType>
    with MarketTypeForAccountAssetRef {
  _MarketTypeForAccountAssetProviderElement(super.provider);

  @override
  AccountAsset? get accountAsset =>
      (origin as MarketTypeForAccountAssetProvider).accountAsset;
}

String _$accountAssetFromAssetHash() =>
    r'087047285382bca97a179e83d08e5d02efdafcfa';

/// See also [accountAssetFromAsset].
@ProviderFor(accountAssetFromAsset)
const accountAssetFromAssetProvider = AccountAssetFromAssetFamily();

/// See also [accountAssetFromAsset].
class AccountAssetFromAssetFamily extends Family<AccountAsset> {
  /// See also [accountAssetFromAsset].
  const AccountAssetFromAssetFamily();

  /// See also [accountAssetFromAsset].
  AccountAssetFromAssetProvider call(
    Asset? asset,
  ) {
    return AccountAssetFromAssetProvider(
      asset,
    );
  }

  @override
  AccountAssetFromAssetProvider getProviderOverride(
    covariant AccountAssetFromAssetProvider provider,
  ) {
    return call(
      provider.asset,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'accountAssetFromAssetProvider';
}

/// See also [accountAssetFromAsset].
class AccountAssetFromAssetProvider extends AutoDisposeProvider<AccountAsset> {
  /// See also [accountAssetFromAsset].
  AccountAssetFromAssetProvider(
    Asset? asset,
  ) : this._internal(
          (ref) => accountAssetFromAsset(
            ref as AccountAssetFromAssetRef,
            asset,
          ),
          from: accountAssetFromAssetProvider,
          name: r'accountAssetFromAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$accountAssetFromAssetHash,
          dependencies: AccountAssetFromAssetFamily._dependencies,
          allTransitiveDependencies:
              AccountAssetFromAssetFamily._allTransitiveDependencies,
          asset: asset,
        );

  AccountAssetFromAssetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.asset,
  }) : super.internal();

  final Asset? asset;

  @override
  Override overrideWith(
    AccountAsset Function(AccountAssetFromAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AccountAssetFromAssetProvider._internal(
        (ref) => create(ref as AccountAssetFromAssetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        asset: asset,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AccountAsset> createElement() {
    return _AccountAssetFromAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AccountAssetFromAssetProvider && other.asset == asset;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, asset.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AccountAssetFromAssetRef on AutoDisposeProviderRef<AccountAsset> {
  /// The parameter `asset` of this provider.
  Asset? get asset;
}

class _AccountAssetFromAssetProviderElement
    extends AutoDisposeProviderElement<AccountAsset>
    with AccountAssetFromAssetRef {
  _AccountAssetFromAssetProviderElement(super.provider);

  @override
  Asset? get asset => (origin as AccountAssetFromAssetProvider).asset;
}

String _$defaultAccountsStateHash() =>
    r'0a26ce887126dd07a2a2525def2d0665757d8c95';

/// See also [DefaultAccountsState].
@ProviderFor(DefaultAccountsState)
final defaultAccountsStateProvider =
    NotifierProvider<DefaultAccountsState, Set<AccountAsset>>.internal(
  DefaultAccountsState.new,
  name: r'defaultAccountsStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$defaultAccountsStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DefaultAccountsState = Notifier<Set<AccountAsset>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
