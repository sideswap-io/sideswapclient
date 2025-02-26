// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_account_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$predefinedAccountAssetsHash() =>
    r'89def1e915459b3f5172efeb81df8d2d5f4f8ba6';

/// See also [predefinedAccountAssets].
@ProviderFor(predefinedAccountAssets)
final predefinedAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      predefinedAccountAssets,
      name: r'predefinedAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$predefinedAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PredefinedAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$allAlwaysShowAccountAssetsHash() =>
    r'9a00b290a32fc4e82645b31ab971cfeaf7cb072a';

/// Needed by ui which want to display limited list of assets - ex. home page wallet
///
///
/// Copied from [allAlwaysShowAccountAssets].
@ProviderFor(allAlwaysShowAccountAssets)
final allAlwaysShowAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      allAlwaysShowAccountAssets,
      name: r'allAlwaysShowAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allAlwaysShowAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllAlwaysShowAccountAssetsRef =
    AutoDisposeProviderRef<List<AccountAsset>>;
String _$allVisibleAccountAssetsHash() =>
    r'd09469f54f23bc8d4cdc6572fbc5c801583ba04a';

/// See also [allVisibleAccountAssets].
@ProviderFor(allVisibleAccountAssets)
final allVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      allVisibleAccountAssets,
      name: r'allVisibleAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allVisibleAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllVisibleAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$regularVisibleAccountAssetsHash() =>
    r'c906223ee8517b45f91f4df7637b1326e79458f8';

/// See also [regularVisibleAccountAssets].
@ProviderFor(regularVisibleAccountAssets)
final regularVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      regularVisibleAccountAssets,
      name: r'regularVisibleAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$regularVisibleAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegularVisibleAccountAssetsRef =
    AutoDisposeProviderRef<List<AccountAsset>>;
String _$ampVisibleAccountAssetsHash() =>
    r'0c45ed5683b0c459a46d4096a873bcc3ac91f69a';

/// See also [ampVisibleAccountAssets].
@ProviderFor(ampVisibleAccountAssets)
final ampVisibleAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      ampVisibleAccountAssets,
      name: r'ampVisibleAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$ampVisibleAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AmpVisibleAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$allAccountAssetsHash() => r'72b00df35b3f64ed728be763c8df386d1300bbde';

/// Needed by ui parts which want to search assetid over all assets - ex. market
///
///
/// Copied from [allAccountAssets].
@ProviderFor(allAccountAssets)
final allAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      allAccountAssets,
      name: r'allAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$allAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$regularAccountAssetsHash() =>
    r'71f72fd60273c02755728eee5c840daa3416e40c';

/// See also [regularAccountAssets].
@ProviderFor(regularAccountAssets)
final regularAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      regularAccountAssets,
      name: r'regularAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$regularAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RegularAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$ampAccountAssetsHash() => r'8baaa9bb59511c43c0e820a1710ebf44b242be7f';

/// See also [ampAccountAssets].
@ProviderFor(ampAccountAssets)
final ampAccountAssetsProvider =
    AutoDisposeProvider<List<AccountAsset>>.internal(
      ampAccountAssets,
      name: r'ampAccountAssetsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$ampAccountAssetsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AmpAccountAssetsRef = AutoDisposeProviderRef<List<AccountAsset>>;
String _$marketTypeForAccountAssetHash() =>
    r'cbecb3f453d7ba82de1cd75ace20092e85430b16';

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
class MarketTypeForAccountAssetFamily extends Family<MarketType_> {
  /// See also [marketTypeForAccountAsset].
  const MarketTypeForAccountAssetFamily();

  /// See also [marketTypeForAccountAsset].
  MarketTypeForAccountAssetProvider call(AccountAsset? accountAsset) {
    return MarketTypeForAccountAssetProvider(accountAsset);
  }

  @override
  MarketTypeForAccountAssetProvider getProviderOverride(
    covariant MarketTypeForAccountAssetProvider provider,
  ) {
    return call(provider.accountAsset);
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
    extends AutoDisposeProvider<MarketType_> {
  /// See also [marketTypeForAccountAsset].
  MarketTypeForAccountAssetProvider(AccountAsset? accountAsset)
    : this._internal(
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
    MarketType_ Function(MarketTypeForAccountAssetRef provider) create,
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
  AutoDisposeProviderElement<MarketType_> createElement() {
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarketTypeForAccountAssetRef on AutoDisposeProviderRef<MarketType_> {
  /// The parameter `accountAsset` of this provider.
  AccountAsset? get accountAsset;
}

class _MarketTypeForAccountAssetProviderElement
    extends AutoDisposeProviderElement<MarketType_>
    with MarketTypeForAccountAssetRef {
  _MarketTypeForAccountAssetProviderElement(super.provider);

  @override
  AccountAsset? get accountAsset =>
      (origin as MarketTypeForAccountAssetProvider).accountAsset;
}

String _$accountAssetFromAssetHash() =>
    r'16448fc516a834a60875fd98cd887940e4f9d882';

/// See also [accountAssetFromAsset].
@ProviderFor(accountAssetFromAsset)
const accountAssetFromAssetProvider = AccountAssetFromAssetFamily();

/// See also [accountAssetFromAsset].
class AccountAssetFromAssetFamily extends Family<AccountAsset> {
  /// See also [accountAssetFromAsset].
  const AccountAssetFromAssetFamily();

  /// See also [accountAssetFromAsset].
  AccountAssetFromAssetProvider call(Asset? asset) {
    return AccountAssetFromAssetProvider(asset);
  }

  @override
  AccountAssetFromAssetProvider getProviderOverride(
    covariant AccountAssetFromAssetProvider provider,
  ) {
    return call(provider.asset);
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
  AccountAssetFromAssetProvider(Asset? asset)
    : this._internal(
        (ref) => accountAssetFromAsset(ref as AccountAssetFromAssetRef, asset),
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

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
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
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$defaultAccountsStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DefaultAccountsState = Notifier<Set<AccountAsset>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
