// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_selector_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$assetSelectorHash() => r'b5291961c69286b53d89102299c562ce019a2b0c';

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

/// See also [assetSelector].
@ProviderFor(assetSelector)
const assetSelectorProvider = AssetSelectorFamily();

/// See also [assetSelector].
class AssetSelectorFamily extends Family<List<AssetSelectorItem>> {
  /// See also [assetSelector].
  const AssetSelectorFamily();

  /// See also [assetSelector].
  AssetSelectorProvider call(
    MarketType marketType,
  ) {
    return AssetSelectorProvider(
      marketType,
    );
  }

  @override
  AssetSelectorProvider getProviderOverride(
    covariant AssetSelectorProvider provider,
  ) {
    return call(
      provider.marketType,
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
  String? get name => r'assetSelectorProvider';
}

/// See also [assetSelector].
class AssetSelectorProvider
    extends AutoDisposeProvider<List<AssetSelectorItem>> {
  /// See also [assetSelector].
  AssetSelectorProvider(
    MarketType marketType,
  ) : this._internal(
          (ref) => assetSelector(
            ref as AssetSelectorRef,
            marketType,
          ),
          from: assetSelectorProvider,
          name: r'assetSelectorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$assetSelectorHash,
          dependencies: AssetSelectorFamily._dependencies,
          allTransitiveDependencies:
              AssetSelectorFamily._allTransitiveDependencies,
          marketType: marketType,
        );

  AssetSelectorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.marketType,
  }) : super.internal();

  final MarketType marketType;

  @override
  Override overrideWith(
    List<AssetSelectorItem> Function(AssetSelectorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetSelectorProvider._internal(
        (ref) => create(ref as AssetSelectorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        marketType: marketType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<AssetSelectorItem>> createElement() {
    return _AssetSelectorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetSelectorProvider && other.marketType == marketType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, marketType.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AssetSelectorRef on AutoDisposeProviderRef<List<AssetSelectorItem>> {
  /// The parameter `marketType` of this provider.
  MarketType get marketType;
}

class _AssetSelectorProviderElement
    extends AutoDisposeProviderElement<List<AssetSelectorItem>>
    with AssetSelectorRef {
  _AssetSelectorProviderElement(super.provider);

  @override
  MarketType get marketType => (origin as AssetSelectorProvider).marketType;
}

String _$tokenAssetSelectorHash() =>
    r'c93542aca435aba34be56252ecbe81286ea41a9a';

/// See also [tokenAssetSelector].
@ProviderFor(tokenAssetSelector)
const tokenAssetSelectorProvider = TokenAssetSelectorFamily();

/// See also [tokenAssetSelector].
class TokenAssetSelectorFamily extends Family<List<AssetSelectorItem>> {
  /// See also [tokenAssetSelector].
  const TokenAssetSelectorFamily();

  /// See also [tokenAssetSelector].
  TokenAssetSelectorProvider call(
    Set<Asset> assetList,
  ) {
    return TokenAssetSelectorProvider(
      assetList,
    );
  }

  @override
  TokenAssetSelectorProvider getProviderOverride(
    covariant TokenAssetSelectorProvider provider,
  ) {
    return call(
      provider.assetList,
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
  String? get name => r'tokenAssetSelectorProvider';
}

/// See also [tokenAssetSelector].
class TokenAssetSelectorProvider
    extends AutoDisposeProvider<List<AssetSelectorItem>> {
  /// See also [tokenAssetSelector].
  TokenAssetSelectorProvider(
    Set<Asset> assetList,
  ) : this._internal(
          (ref) => tokenAssetSelector(
            ref as TokenAssetSelectorRef,
            assetList,
          ),
          from: tokenAssetSelectorProvider,
          name: r'tokenAssetSelectorProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$tokenAssetSelectorHash,
          dependencies: TokenAssetSelectorFamily._dependencies,
          allTransitiveDependencies:
              TokenAssetSelectorFamily._allTransitiveDependencies,
          assetList: assetList,
        );

  TokenAssetSelectorProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetList,
  }) : super.internal();

  final Set<Asset> assetList;

  @override
  Override overrideWith(
    List<AssetSelectorItem> Function(TokenAssetSelectorRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: TokenAssetSelectorProvider._internal(
        (ref) => create(ref as TokenAssetSelectorRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetList: assetList,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<AssetSelectorItem>> createElement() {
    return _TokenAssetSelectorProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TokenAssetSelectorProvider && other.assetList == assetList;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetList.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin TokenAssetSelectorRef on AutoDisposeProviderRef<List<AssetSelectorItem>> {
  /// The parameter `assetList` of this provider.
  Set<Asset> get assetList;
}

class _TokenAssetSelectorProviderElement
    extends AutoDisposeProviderElement<List<AssetSelectorItem>>
    with TokenAssetSelectorRef {
  _TokenAssetSelectorProviderElement(super.provider);

  @override
  Set<Asset> get assetList => (origin as TokenAssetSelectorProvider).assetList;
}

String _$tokenMarketOrderHash() => r'535c54106ebccf64b67d2c10ecdbe4e5aeeb0c8b';

/// See also [TokenMarketOrder].
@ProviderFor(TokenMarketOrder)
final tokenMarketOrderProvider =
    NotifierProvider<TokenMarketOrder, List<String>>.internal(
  TokenMarketOrder.new,
  name: r'tokenMarketOrderProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tokenMarketOrderHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TokenMarketOrder = Notifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
