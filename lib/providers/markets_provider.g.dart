// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketTypeNameHash() => r'e217a3b36b49ccf77552080f23079cbad61eed5f';

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

/// See also [marketTypeName].
@ProviderFor(marketTypeName)
const marketTypeNameProvider = MarketTypeNameFamily();

/// See also [marketTypeName].
class MarketTypeNameFamily extends Family<String> {
  /// See also [marketTypeName].
  const MarketTypeNameFamily();

  /// See also [marketTypeName].
  MarketTypeNameProvider call(MarketType_ type) {
    return MarketTypeNameProvider(type);
  }

  @override
  MarketTypeNameProvider getProviderOverride(
    covariant MarketTypeNameProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'marketTypeNameProvider';
}

/// See also [marketTypeName].
class MarketTypeNameProvider extends AutoDisposeProvider<String> {
  /// See also [marketTypeName].
  MarketTypeNameProvider(MarketType_ type)
    : this._internal(
        (ref) => marketTypeName(ref as MarketTypeNameRef, type),
        from: marketTypeNameProvider,
        name: r'marketTypeNameProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$marketTypeNameHash,
        dependencies: MarketTypeNameFamily._dependencies,
        allTransitiveDependencies:
            MarketTypeNameFamily._allTransitiveDependencies,
        type: type,
      );

  MarketTypeNameProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final MarketType_ type;

  @override
  Override overrideWith(String Function(MarketTypeNameRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: MarketTypeNameProvider._internal(
        (ref) => create(ref as MarketTypeNameRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _MarketTypeNameProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketTypeNameProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarketTypeNameRef on AutoDisposeProviderRef<String> {
  /// The parameter `type` of this provider.
  MarketType_ get type;
}

class _MarketTypeNameProviderElement extends AutoDisposeProviderElement<String>
    with MarketTypeNameRef {
  _MarketTypeNameProviderElement(super.provider);

  @override
  MarketType_ get type => (origin as MarketTypeNameProvider).type;
}

String _$assetMarketTypeHash() => r'1cd997dcaa8c150fb9334d0c1fc00d891e438583';

/// See also [assetMarketType].
@ProviderFor(assetMarketType)
const assetMarketTypeProvider = AssetMarketTypeFamily();

/// See also [assetMarketType].
class AssetMarketTypeFamily extends Family<MarketType_> {
  /// See also [assetMarketType].
  const AssetMarketTypeFamily();

  /// See also [assetMarketType].
  AssetMarketTypeProvider call(Asset? asset) {
    return AssetMarketTypeProvider(asset);
  }

  @override
  AssetMarketTypeProvider getProviderOverride(
    covariant AssetMarketTypeProvider provider,
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
  String? get name => r'assetMarketTypeProvider';
}

/// See also [assetMarketType].
class AssetMarketTypeProvider extends AutoDisposeProvider<MarketType_> {
  /// See also [assetMarketType].
  AssetMarketTypeProvider(Asset? asset)
    : this._internal(
        (ref) => assetMarketType(ref as AssetMarketTypeRef, asset),
        from: assetMarketTypeProvider,
        name: r'assetMarketTypeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$assetMarketTypeHash,
        dependencies: AssetMarketTypeFamily._dependencies,
        allTransitiveDependencies:
            AssetMarketTypeFamily._allTransitiveDependencies,
        asset: asset,
      );

  AssetMarketTypeProvider._internal(
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
    MarketType_ Function(AssetMarketTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AssetMarketTypeProvider._internal(
        (ref) => create(ref as AssetMarketTypeRef),
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
  AutoDisposeProviderElement<MarketType_> createElement() {
    return _AssetMarketTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AssetMarketTypeProvider && other.asset == asset;
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
mixin AssetMarketTypeRef on AutoDisposeProviderRef<MarketType_> {
  /// The parameter `asset` of this provider.
  Asset? get asset;
}

class _AssetMarketTypeProviderElement
    extends AutoDisposeProviderElement<MarketType_>
    with AssetMarketTypeRef {
  _AssetMarketTypeProviderElement(super.provider);

  @override
  Asset? get asset => (origin as AssetMarketTypeProvider).asset;
}

String _$marketInfoByMarketTypeHash() =>
    r'2eafab9bb8ed20c3f4a2853da213bd7925af4c43';

/// See also [marketInfoByMarketType].
@ProviderFor(marketInfoByMarketType)
const marketInfoByMarketTypeProvider = MarketInfoByMarketTypeFamily();

/// See also [marketInfoByMarketType].
class MarketInfoByMarketTypeFamily extends Family<List<MarketInfo>> {
  /// See also [marketInfoByMarketType].
  const MarketInfoByMarketTypeFamily();

  /// See also [marketInfoByMarketType].
  MarketInfoByMarketTypeProvider call(MarketType_ marketType) {
    return MarketInfoByMarketTypeProvider(marketType);
  }

  @override
  MarketInfoByMarketTypeProvider getProviderOverride(
    covariant MarketInfoByMarketTypeProvider provider,
  ) {
    return call(provider.marketType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'marketInfoByMarketTypeProvider';
}

/// See also [marketInfoByMarketType].
class MarketInfoByMarketTypeProvider
    extends AutoDisposeProvider<List<MarketInfo>> {
  /// See also [marketInfoByMarketType].
  MarketInfoByMarketTypeProvider(MarketType_ marketType)
    : this._internal(
        (ref) => marketInfoByMarketType(
          ref as MarketInfoByMarketTypeRef,
          marketType,
        ),
        from: marketInfoByMarketTypeProvider,
        name: r'marketInfoByMarketTypeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$marketInfoByMarketTypeHash,
        dependencies: MarketInfoByMarketTypeFamily._dependencies,
        allTransitiveDependencies:
            MarketInfoByMarketTypeFamily._allTransitiveDependencies,
        marketType: marketType,
      );

  MarketInfoByMarketTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.marketType,
  }) : super.internal();

  final MarketType_ marketType;

  @override
  Override overrideWith(
    List<MarketInfo> Function(MarketInfoByMarketTypeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarketInfoByMarketTypeProvider._internal(
        (ref) => create(ref as MarketInfoByMarketTypeRef),
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
  AutoDisposeProviderElement<List<MarketInfo>> createElement() {
    return _MarketInfoByMarketTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketInfoByMarketTypeProvider &&
        other.marketType == marketType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, marketType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MarketInfoByMarketTypeRef on AutoDisposeProviderRef<List<MarketInfo>> {
  /// The parameter `marketType` of this provider.
  MarketType_ get marketType;
}

class _MarketInfoByMarketTypeProviderElement
    extends AutoDisposeProviderElement<List<MarketInfo>>
    with MarketInfoByMarketTypeRef {
  _MarketInfoByMarketTypeProviderElement(super.provider);

  @override
  MarketType_ get marketType =>
      (origin as MarketInfoByMarketTypeProvider).marketType;
}

String _$baseAssetByMarketInfoHash() =>
    r'3320120e9ba1099dfedc24e51cc4a616036455de';

/// See also [baseAssetByMarketInfo].
@ProviderFor(baseAssetByMarketInfo)
const baseAssetByMarketInfoProvider = BaseAssetByMarketInfoFamily();

/// See also [baseAssetByMarketInfo].
class BaseAssetByMarketInfoFamily extends Family<Option<Asset>> {
  /// See also [baseAssetByMarketInfo].
  const BaseAssetByMarketInfoFamily();

  /// See also [baseAssetByMarketInfo].
  BaseAssetByMarketInfoProvider call(MarketInfo marketInfo) {
    return BaseAssetByMarketInfoProvider(marketInfo);
  }

  @override
  BaseAssetByMarketInfoProvider getProviderOverride(
    covariant BaseAssetByMarketInfoProvider provider,
  ) {
    return call(provider.marketInfo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'baseAssetByMarketInfoProvider';
}

/// See also [baseAssetByMarketInfo].
class BaseAssetByMarketInfoProvider extends AutoDisposeProvider<Option<Asset>> {
  /// See also [baseAssetByMarketInfo].
  BaseAssetByMarketInfoProvider(MarketInfo marketInfo)
    : this._internal(
        (ref) =>
            baseAssetByMarketInfo(ref as BaseAssetByMarketInfoRef, marketInfo),
        from: baseAssetByMarketInfoProvider,
        name: r'baseAssetByMarketInfoProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$baseAssetByMarketInfoHash,
        dependencies: BaseAssetByMarketInfoFamily._dependencies,
        allTransitiveDependencies:
            BaseAssetByMarketInfoFamily._allTransitiveDependencies,
        marketInfo: marketInfo,
      );

  BaseAssetByMarketInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.marketInfo,
  }) : super.internal();

  final MarketInfo marketInfo;

  @override
  Override overrideWith(
    Option<Asset> Function(BaseAssetByMarketInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BaseAssetByMarketInfoProvider._internal(
        (ref) => create(ref as BaseAssetByMarketInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        marketInfo: marketInfo,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Option<Asset>> createElement() {
    return _BaseAssetByMarketInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BaseAssetByMarketInfoProvider &&
        other.marketInfo == marketInfo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, marketInfo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BaseAssetByMarketInfoRef on AutoDisposeProviderRef<Option<Asset>> {
  /// The parameter `marketInfo` of this provider.
  MarketInfo get marketInfo;
}

class _BaseAssetByMarketInfoProviderElement
    extends AutoDisposeProviderElement<Option<Asset>>
    with BaseAssetByMarketInfoRef {
  _BaseAssetByMarketInfoProviderElement(super.provider);

  @override
  MarketInfo get marketInfo =>
      (origin as BaseAssetByMarketInfoProvider).marketInfo;
}

String _$baseAssetIconByMarketInfoHash() =>
    r'e062bce0c9a0a3c3b09a9f283d212d8d373c5cd8';

/// See also [baseAssetIconByMarketInfo].
@ProviderFor(baseAssetIconByMarketInfo)
const baseAssetIconByMarketInfoProvider = BaseAssetIconByMarketInfoFamily();

/// See also [baseAssetIconByMarketInfo].
class BaseAssetIconByMarketInfoFamily extends Family<Widget> {
  /// See also [baseAssetIconByMarketInfo].
  const BaseAssetIconByMarketInfoFamily();

  /// See also [baseAssetIconByMarketInfo].
  BaseAssetIconByMarketInfoProvider call(MarketInfo marketInfo) {
    return BaseAssetIconByMarketInfoProvider(marketInfo);
  }

  @override
  BaseAssetIconByMarketInfoProvider getProviderOverride(
    covariant BaseAssetIconByMarketInfoProvider provider,
  ) {
    return call(provider.marketInfo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'baseAssetIconByMarketInfoProvider';
}

/// See also [baseAssetIconByMarketInfo].
class BaseAssetIconByMarketInfoProvider extends AutoDisposeProvider<Widget> {
  /// See also [baseAssetIconByMarketInfo].
  BaseAssetIconByMarketInfoProvider(MarketInfo marketInfo)
    : this._internal(
        (ref) => baseAssetIconByMarketInfo(
          ref as BaseAssetIconByMarketInfoRef,
          marketInfo,
        ),
        from: baseAssetIconByMarketInfoProvider,
        name: r'baseAssetIconByMarketInfoProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$baseAssetIconByMarketInfoHash,
        dependencies: BaseAssetIconByMarketInfoFamily._dependencies,
        allTransitiveDependencies:
            BaseAssetIconByMarketInfoFamily._allTransitiveDependencies,
        marketInfo: marketInfo,
      );

  BaseAssetIconByMarketInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.marketInfo,
  }) : super.internal();

  final MarketInfo marketInfo;

  @override
  Override overrideWith(
    Widget Function(BaseAssetIconByMarketInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BaseAssetIconByMarketInfoProvider._internal(
        (ref) => create(ref as BaseAssetIconByMarketInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        marketInfo: marketInfo,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Widget> createElement() {
    return _BaseAssetIconByMarketInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BaseAssetIconByMarketInfoProvider &&
        other.marketInfo == marketInfo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, marketInfo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BaseAssetIconByMarketInfoRef on AutoDisposeProviderRef<Widget> {
  /// The parameter `marketInfo` of this provider.
  MarketInfo get marketInfo;
}

class _BaseAssetIconByMarketInfoProviderElement
    extends AutoDisposeProviderElement<Widget>
    with BaseAssetIconByMarketInfoRef {
  _BaseAssetIconByMarketInfoProviderElement(super.provider);

  @override
  MarketInfo get marketInfo =>
      (origin as BaseAssetIconByMarketInfoProvider).marketInfo;
}

String _$quoteAssetByMarketInfoHash() =>
    r'7e664016dd3eebe2a6fbc65444f60a9ba4568f7f';

/// See also [quoteAssetByMarketInfo].
@ProviderFor(quoteAssetByMarketInfo)
const quoteAssetByMarketInfoProvider = QuoteAssetByMarketInfoFamily();

/// See also [quoteAssetByMarketInfo].
class QuoteAssetByMarketInfoFamily extends Family<Option<Asset>> {
  /// See also [quoteAssetByMarketInfo].
  const QuoteAssetByMarketInfoFamily();

  /// See also [quoteAssetByMarketInfo].
  QuoteAssetByMarketInfoProvider call(MarketInfo marketInfo) {
    return QuoteAssetByMarketInfoProvider(marketInfo);
  }

  @override
  QuoteAssetByMarketInfoProvider getProviderOverride(
    covariant QuoteAssetByMarketInfoProvider provider,
  ) {
    return call(provider.marketInfo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quoteAssetByMarketInfoProvider';
}

/// See also [quoteAssetByMarketInfo].
class QuoteAssetByMarketInfoProvider
    extends AutoDisposeProvider<Option<Asset>> {
  /// See also [quoteAssetByMarketInfo].
  QuoteAssetByMarketInfoProvider(MarketInfo marketInfo)
    : this._internal(
        (ref) => quoteAssetByMarketInfo(
          ref as QuoteAssetByMarketInfoRef,
          marketInfo,
        ),
        from: quoteAssetByMarketInfoProvider,
        name: r'quoteAssetByMarketInfoProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$quoteAssetByMarketInfoHash,
        dependencies: QuoteAssetByMarketInfoFamily._dependencies,
        allTransitiveDependencies:
            QuoteAssetByMarketInfoFamily._allTransitiveDependencies,
        marketInfo: marketInfo,
      );

  QuoteAssetByMarketInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.marketInfo,
  }) : super.internal();

  final MarketInfo marketInfo;

  @override
  Override overrideWith(
    Option<Asset> Function(QuoteAssetByMarketInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuoteAssetByMarketInfoProvider._internal(
        (ref) => create(ref as QuoteAssetByMarketInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        marketInfo: marketInfo,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Option<Asset>> createElement() {
    return _QuoteAssetByMarketInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteAssetByMarketInfoProvider &&
        other.marketInfo == marketInfo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, marketInfo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuoteAssetByMarketInfoRef on AutoDisposeProviderRef<Option<Asset>> {
  /// The parameter `marketInfo` of this provider.
  MarketInfo get marketInfo;
}

class _QuoteAssetByMarketInfoProviderElement
    extends AutoDisposeProviderElement<Option<Asset>>
    with QuoteAssetByMarketInfoRef {
  _QuoteAssetByMarketInfoProviderElement(super.provider);

  @override
  MarketInfo get marketInfo =>
      (origin as QuoteAssetByMarketInfoProvider).marketInfo;
}

String _$quoteAssetIconByMarketInfoHash() =>
    r'e1372b7216654bde9ef345ca4cc47db9fd59fb7a';

/// See also [quoteAssetIconByMarketInfo].
@ProviderFor(quoteAssetIconByMarketInfo)
const quoteAssetIconByMarketInfoProvider = QuoteAssetIconByMarketInfoFamily();

/// See also [quoteAssetIconByMarketInfo].
class QuoteAssetIconByMarketInfoFamily extends Family<Widget> {
  /// See also [quoteAssetIconByMarketInfo].
  const QuoteAssetIconByMarketInfoFamily();

  /// See also [quoteAssetIconByMarketInfo].
  QuoteAssetIconByMarketInfoProvider call(MarketInfo marketInfo) {
    return QuoteAssetIconByMarketInfoProvider(marketInfo);
  }

  @override
  QuoteAssetIconByMarketInfoProvider getProviderOverride(
    covariant QuoteAssetIconByMarketInfoProvider provider,
  ) {
    return call(provider.marketInfo);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'quoteAssetIconByMarketInfoProvider';
}

/// See also [quoteAssetIconByMarketInfo].
class QuoteAssetIconByMarketInfoProvider extends AutoDisposeProvider<Widget> {
  /// See also [quoteAssetIconByMarketInfo].
  QuoteAssetIconByMarketInfoProvider(MarketInfo marketInfo)
    : this._internal(
        (ref) => quoteAssetIconByMarketInfo(
          ref as QuoteAssetIconByMarketInfoRef,
          marketInfo,
        ),
        from: quoteAssetIconByMarketInfoProvider,
        name: r'quoteAssetIconByMarketInfoProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$quoteAssetIconByMarketInfoHash,
        dependencies: QuoteAssetIconByMarketInfoFamily._dependencies,
        allTransitiveDependencies:
            QuoteAssetIconByMarketInfoFamily._allTransitiveDependencies,
        marketInfo: marketInfo,
      );

  QuoteAssetIconByMarketInfoProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.marketInfo,
  }) : super.internal();

  final MarketInfo marketInfo;

  @override
  Override overrideWith(
    Widget Function(QuoteAssetIconByMarketInfoRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: QuoteAssetIconByMarketInfoProvider._internal(
        (ref) => create(ref as QuoteAssetIconByMarketInfoRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        marketInfo: marketInfo,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Widget> createElement() {
    return _QuoteAssetIconByMarketInfoProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is QuoteAssetIconByMarketInfoProvider &&
        other.marketInfo == marketInfo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, marketInfo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin QuoteAssetIconByMarketInfoRef on AutoDisposeProviderRef<Widget> {
  /// The parameter `marketInfo` of this provider.
  MarketInfo get marketInfo;
}

class _QuoteAssetIconByMarketInfoProviderElement
    extends AutoDisposeProviderElement<Widget>
    with QuoteAssetIconByMarketInfoRef {
  _QuoteAssetIconByMarketInfoProviderElement(super.provider);

  @override
  MarketInfo get marketInfo =>
      (origin as QuoteAssetIconByMarketInfoProvider).marketInfo;
}

String _$marketUiOwnOrdersHash() => r'bbd1557f7b250c5234b99821f427b7071faac8ee';

/// See also [marketUiOwnOrders].
@ProviderFor(marketUiOwnOrders)
final marketUiOwnOrdersProvider =
    AutoDisposeProvider<List<UiOwnOrder>>.internal(
      marketUiOwnOrders,
      name: r'marketUiOwnOrdersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketUiOwnOrdersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketUiOwnOrdersRef = AutoDisposeProviderRef<List<UiOwnOrder>>;
String _$subscribedMarketInfoHash() =>
    r'ee6fde0f686d5d3af57f11d7d207f9fb79780c2d';

/// See also [subscribedMarketInfo].
@ProviderFor(subscribedMarketInfo)
final subscribedMarketInfoProvider =
    AutoDisposeProvider<Option<MarketInfo>>.internal(
      subscribedMarketInfo,
      name: r'subscribedMarketInfoProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$subscribedMarketInfoHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscribedMarketInfoRef = AutoDisposeProviderRef<Option<MarketInfo>>;
String _$subscribedMarketProductNameHash() =>
    r'9c801467900b87fc082e0ffb8c2532423c8bea5d';

/// See also [subscribedMarketProductName].
@ProviderFor(subscribedMarketProductName)
final subscribedMarketProductNameProvider =
    AutoDisposeProvider<String>.internal(
      subscribedMarketProductName,
      name: r'subscribedMarketProductNameProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$subscribedMarketProductNameHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SubscribedMarketProductNameRef = AutoDisposeProviderRef<String>;
String _$marketSubscribedBaseAssetHash() =>
    r'3c236c8986cec5dc9e5fd6fc70daa0e37ea6a3e3';

/// See also [marketSubscribedBaseAsset].
@ProviderFor(marketSubscribedBaseAsset)
final marketSubscribedBaseAssetProvider =
    AutoDisposeProvider<Option<Asset>>.internal(
      marketSubscribedBaseAsset,
      name: r'marketSubscribedBaseAssetProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketSubscribedBaseAssetHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketSubscribedBaseAssetRef = AutoDisposeProviderRef<Option<Asset>>;
String _$marketSubscribedQuoteAssetHash() =>
    r'990dd2bc7639a938afefe8e5b486b84555edeb80';

/// See also [marketSubscribedQuoteAsset].
@ProviderFor(marketSubscribedQuoteAsset)
final marketSubscribedQuoteAssetProvider =
    AutoDisposeProvider<Option<Asset>>.internal(
      marketSubscribedQuoteAsset,
      name: r'marketSubscribedQuoteAssetProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketSubscribedQuoteAssetHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketSubscribedQuoteAssetRef = AutoDisposeProviderRef<Option<Asset>>;
String _$marketIndexPriceHash() => r'495d5c07896ccafd3e0a5acc8310ad461e3ed6cb';

/// See also [marketIndexPrice].
@ProviderFor(marketIndexPrice)
final marketIndexPriceProvider = AutoDisposeProvider<
  Option<({String indexPrice, Option<Asset> quoteAsset})>
>.internal(
  marketIndexPrice,
  name: r'marketIndexPriceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketIndexPriceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketIndexPriceRef =
    AutoDisposeProviderRef<
      Option<({String indexPrice, Option<Asset> quoteAsset})>
    >;
String _$marketLastPriceHash() => r'dcdb657ec7995343c05f28540db70a6aeccb14dc';

/// See also [marketLastPrice].
@ProviderFor(marketLastPrice)
final marketLastPriceProvider = AutoDisposeProvider<
  Option<({String lastPrice, Option<Asset> quoteAsset})>
>.internal(
  marketLastPrice,
  name: r'marketLastPriceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketLastPriceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketLastPriceRef =
    AutoDisposeProviderRef<
      Option<({String lastPrice, Option<Asset> quoteAsset})>
    >;
String _$marketOrderAmountHash() => r'ba175fac7ac0364835248b01106a904fd7e0c4e2';

/// See also [marketOrderAmount].
@ProviderFor(marketOrderAmount)
final marketOrderAmountProvider = AutoDisposeProvider<OrderAmount>.internal(
  marketOrderAmount,
  name: r'marketOrderAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketOrderAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketOrderAmountRef = AutoDisposeProviderRef<OrderAmount>;
String _$marketOrderTradeButtonEnabledHash() =>
    r'242fbcfc419bb086606e5d50cd70d5ed8d007e63';

/// See also [marketOrderTradeButtonEnabled].
@ProviderFor(marketOrderTradeButtonEnabled)
final marketOrderTradeButtonEnabledProvider =
    AutoDisposeProvider<bool>.internal(
      marketOrderTradeButtonEnabled,
      name: r'marketOrderTradeButtonEnabledProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketOrderTradeButtonEnabledHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketOrderTradeButtonEnabledRef = AutoDisposeProviderRef<bool>;
String _$marketQuoteErrorHash() => r'6f74144c5dc7fe5729aad8c1bc0bb92ce0abf6ad';

/// See also [marketQuoteError].
@ProviderFor(marketQuoteError)
final marketQuoteErrorProvider =
    AutoDisposeProvider<Option<QuoteError>>.internal(
      marketQuoteError,
      name: r'marketQuoteErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketQuoteErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketQuoteErrorRef = AutoDisposeProviderRef<Option<QuoteError>>;
String _$marketQuoteLowBalanceErrorHash() =>
    r'f75577bbc339ae7e7a23b55f2d9175272e42ae10';

/// See also [marketQuoteLowBalanceError].
@ProviderFor(marketQuoteLowBalanceError)
final marketQuoteLowBalanceErrorProvider =
    AutoDisposeProvider<Option<QuoteLowBalance>>.internal(
      marketQuoteLowBalanceError,
      name: r'marketQuoteLowBalanceErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketQuoteLowBalanceErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketQuoteLowBalanceErrorRef =
    AutoDisposeProviderRef<Option<QuoteLowBalance>>;
String _$marketQuoteSuccessHash() =>
    r'f6ee9d60c6ce134c8c122e5e404d3746c1a069e1';

/// See also [marketQuoteSuccess].
@ProviderFor(marketQuoteSuccess)
final marketQuoteSuccessProvider =
    AutoDisposeProvider<Option<QuoteSuccess>>.internal(
      marketQuoteSuccess,
      name: r'marketQuoteSuccessProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketQuoteSuccessHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketQuoteSuccessRef = AutoDisposeProviderRef<Option<QuoteSuccess>>;
String _$marketQuoteUnregisteredGaidHash() =>
    r'37744a860de57ccd8794fd37bedfd4d295f91534';

/// See also [marketQuoteUnregisteredGaid].
@ProviderFor(marketQuoteUnregisteredGaid)
final marketQuoteUnregisteredGaidProvider =
    AutoDisposeProvider<Option<QuoteUnregisteredGaid>>.internal(
      marketQuoteUnregisteredGaid,
      name: r'marketQuoteUnregisteredGaidProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketQuoteUnregisteredGaidHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketQuoteUnregisteredGaidRef =
    AutoDisposeProviderRef<Option<QuoteUnregisteredGaid>>;
String _$marketAcceptQuoteSuccessHash() =>
    r'9f600156a0dcafd1efa6b50488770bd39a6a420c';

/// See also [marketAcceptQuoteSuccess].
@ProviderFor(marketAcceptQuoteSuccess)
final marketAcceptQuoteSuccessProvider =
    AutoDisposeProvider<Option<String>>.internal(
      marketAcceptQuoteSuccess,
      name: r'marketAcceptQuoteSuccessProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketAcceptQuoteSuccessHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketAcceptQuoteSuccessRef = AutoDisposeProviderRef<Option<String>>;
String _$acceptQuoteErrorHash() => r'189c83c899726743b828e027317134b81afaad81';

/// See also [acceptQuoteError].
@ProviderFor(acceptQuoteError)
final acceptQuoteErrorProvider = AutoDisposeProvider<Option<String>>.internal(
  acceptQuoteError,
  name: r'acceptQuoteErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$acceptQuoteErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AcceptQuoteErrorRef = AutoDisposeProviderRef<Option<String>>;
String _$limitOrderAmountHash() => r'05e38c12f52c93f5bc920760ed38e29faee79144';

/// See also [limitOrderAmount].
@ProviderFor(limitOrderAmount)
final limitOrderAmountProvider = AutoDisposeProvider<OrderAmount>.internal(
  limitOrderAmount,
  name: r'limitOrderAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitOrderAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LimitOrderAmountRef = AutoDisposeProviderRef<OrderAmount>;
String _$limitPriceAmountHash() => r'5587603fa6fe3340a35e5bf4d8674e003eb9354f';

/// See also [limitPriceAmount].
@ProviderFor(limitPriceAmount)
final limitPriceAmountProvider = AutoDisposeProvider<OrderAmount>.internal(
  limitPriceAmount,
  name: r'limitPriceAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitPriceAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LimitPriceAmountRef = AutoDisposeProviderRef<OrderAmount>;
String _$limitOrderTradeButtonEnabledHash() =>
    r'd923081e60a05c11279f8ea6115929b1d25b9d7a';

/// See also [limitOrderTradeButtonEnabled].
@ProviderFor(limitOrderTradeButtonEnabled)
final limitOrderTradeButtonEnabledProvider = AutoDisposeProvider<bool>.internal(
  limitOrderTradeButtonEnabled,
  name: r'limitOrderTradeButtonEnabledProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitOrderTradeButtonEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LimitOrderTradeButtonEnabledRef = AutoDisposeProviderRef<bool>;
String _$orderSubmitSuccessHash() =>
    r'2b3c85ecbc63cbb35cea76b261ed27f34134ff1c';

/// See also [orderSubmitSuccess].
@ProviderFor(orderSubmitSuccess)
final orderSubmitSuccessProvider =
    AutoDisposeProvider<Option<UiOwnOrder>>.internal(
      orderSubmitSuccess,
      name: r'orderSubmitSuccessProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$orderSubmitSuccessHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderSubmitSuccessRef = AutoDisposeProviderRef<Option<UiOwnOrder>>;
String _$orderSubmitErrorHash() => r'd646972443916b63c5f9b440067f77a40a8f2728';

/// See also [orderSubmitError].
@ProviderFor(orderSubmitError)
final orderSubmitErrorProvider = AutoDisposeProvider<Option<String>>.internal(
  orderSubmitError,
  name: r'orderSubmitErrorProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$orderSubmitErrorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderSubmitErrorRef = AutoDisposeProviderRef<Option<String>>;
String _$orderSubmitUnregisteredGaidHash() =>
    r'7c59145e649fcd5d8d1b1bb74b084f5f0f888302';

/// See also [orderSubmitUnregisteredGaid].
@ProviderFor(orderSubmitUnregisteredGaid)
final orderSubmitUnregisteredGaidProvider =
    AutoDisposeProvider<Option<String>>.internal(
      orderSubmitUnregisteredGaid,
      name: r'orderSubmitUnregisteredGaidProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$orderSubmitUnregisteredGaidHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrderSubmitUnregisteredGaidRef = AutoDisposeProviderRef<Option<String>>;
String _$marketEditOrderAmountHash() =>
    r'9cc3b9d65db3f61358fc311a301e8c459273edd0';

/// See also [marketEditOrderAmount].
@ProviderFor(marketEditOrderAmount)
final marketEditOrderAmountProvider =
    AutoDisposeProvider<Option<OrderAmount>>.internal(
      marketEditOrderAmount,
      name: r'marketEditOrderAmountProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketEditOrderAmountHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketEditOrderAmountRef = AutoDisposeProviderRef<Option<OrderAmount>>;
String _$marketEditOrderPriceHash() =>
    r'e54a3d2725b8272da6a8107fbaf2c8edc40a4e8c';

/// See also [marketEditOrderPrice].
@ProviderFor(marketEditOrderPrice)
final marketEditOrderPriceProvider =
    AutoDisposeProvider<Option<OrderAmount>>.internal(
      marketEditOrderPrice,
      name: r'marketEditOrderPriceProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketEditOrderPriceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketEditOrderPriceRef = AutoDisposeProviderRef<Option<OrderAmount>>;
String _$marketEditOrderAcceptEnabledHash() =>
    r'72e8749934d9b0efc4f5266e462ab109cd66ce4c';

/// See also [marketEditOrderAcceptEnabled].
@ProviderFor(marketEditOrderAcceptEnabled)
final marketEditOrderAcceptEnabledProvider = AutoDisposeProvider<bool>.internal(
  marketEditOrderAcceptEnabled,
  name: r'marketEditOrderAcceptEnabledProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketEditOrderAcceptEnabledHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketEditOrderAcceptEnabledRef = AutoDisposeProviderRef<bool>;
String _$addressToShareByOrderHash() =>
    r'6b46f55b929ecde6444b1cdcbdf14e1498a2bd03';

/// See also [addressToShareByOrder].
@ProviderFor(addressToShareByOrder)
const addressToShareByOrderProvider = AddressToShareByOrderFamily();

/// See also [addressToShareByOrder].
class AddressToShareByOrderFamily extends Family<String> {
  /// See also [addressToShareByOrder].
  const AddressToShareByOrderFamily();

  /// See also [addressToShareByOrder].
  AddressToShareByOrderProvider call(UiOwnOrder order) {
    return AddressToShareByOrderProvider(order);
  }

  @override
  AddressToShareByOrderProvider getProviderOverride(
    covariant AddressToShareByOrderProvider provider,
  ) {
    return call(provider.order);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'addressToShareByOrderProvider';
}

/// See also [addressToShareByOrder].
class AddressToShareByOrderProvider extends AutoDisposeProvider<String> {
  /// See also [addressToShareByOrder].
  AddressToShareByOrderProvider(UiOwnOrder order)
    : this._internal(
        (ref) => addressToShareByOrder(ref as AddressToShareByOrderRef, order),
        from: addressToShareByOrderProvider,
        name: r'addressToShareByOrderProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$addressToShareByOrderHash,
        dependencies: AddressToShareByOrderFamily._dependencies,
        allTransitiveDependencies:
            AddressToShareByOrderFamily._allTransitiveDependencies,
        order: order,
      );

  AddressToShareByOrderProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.order,
  }) : super.internal();

  final UiOwnOrder order;

  @override
  Override overrideWith(
    String Function(AddressToShareByOrderRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AddressToShareByOrderProvider._internal(
        (ref) => create(ref as AddressToShareByOrderRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        order: order,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _AddressToShareByOrderProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AddressToShareByOrderProvider && other.order == order;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, order.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AddressToShareByOrderRef on AutoDisposeProviderRef<String> {
  /// The parameter `order` of this provider.
  UiOwnOrder get order;
}

class _AddressToShareByOrderProviderElement
    extends AutoDisposeProviderElement<String>
    with AddressToShareByOrderRef {
  _AddressToShareByOrderProviderElement(super.provider);

  @override
  UiOwnOrder get order => (origin as AddressToShareByOrderProvider).order;
}

String _$marketUiHistoryOrdersHash() =>
    r'1dc29ff227c1dadb988c6034504ff472faa189b0';

/// See also [marketUiHistoryOrders].
@ProviderFor(marketUiHistoryOrders)
final marketUiHistoryOrdersProvider =
    AutoDisposeProvider<List<UiHistoryOrder>>.internal(
      marketUiHistoryOrders,
      name: r'marketUiHistoryOrdersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketUiHistoryOrdersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketUiHistoryOrdersRef = AutoDisposeProviderRef<List<UiHistoryOrder>>;
String _$orderExpireDescriptionHash() =>
    r'48a6139fd494d6210f22931be4e94dfcd5bdb7be';

/// See also [orderExpireDescription].
@ProviderFor(orderExpireDescription)
const orderExpireDescriptionProvider = OrderExpireDescriptionFamily();

/// See also [orderExpireDescription].
class OrderExpireDescriptionFamily extends Family<String> {
  /// See also [orderExpireDescription].
  const OrderExpireDescriptionFamily();

  /// See also [orderExpireDescription].
  OrderExpireDescriptionProvider call(Option<UiOwnOrder> optionOrder) {
    return OrderExpireDescriptionProvider(optionOrder);
  }

  @override
  OrderExpireDescriptionProvider getProviderOverride(
    covariant OrderExpireDescriptionProvider provider,
  ) {
    return call(provider.optionOrder);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'orderExpireDescriptionProvider';
}

/// See also [orderExpireDescription].
class OrderExpireDescriptionProvider extends AutoDisposeProvider<String> {
  /// See also [orderExpireDescription].
  OrderExpireDescriptionProvider(Option<UiOwnOrder> optionOrder)
    : this._internal(
        (ref) => orderExpireDescription(
          ref as OrderExpireDescriptionRef,
          optionOrder,
        ),
        from: orderExpireDescriptionProvider,
        name: r'orderExpireDescriptionProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$orderExpireDescriptionHash,
        dependencies: OrderExpireDescriptionFamily._dependencies,
        allTransitiveDependencies:
            OrderExpireDescriptionFamily._allTransitiveDependencies,
        optionOrder: optionOrder,
      );

  OrderExpireDescriptionProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.optionOrder,
  }) : super.internal();

  final Option<UiOwnOrder> optionOrder;

  @override
  Override overrideWith(
    String Function(OrderExpireDescriptionRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OrderExpireDescriptionProvider._internal(
        (ref) => create(ref as OrderExpireDescriptionRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        optionOrder: optionOrder,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _OrderExpireDescriptionProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OrderExpireDescriptionProvider &&
        other.optionOrder == optionOrder;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, optionOrder.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OrderExpireDescriptionRef on AutoDisposeProviderRef<String> {
  /// The parameter `optionOrder` of this provider.
  Option<UiOwnOrder> get optionOrder;
}

class _OrderExpireDescriptionProviderElement
    extends AutoDisposeProviderElement<String>
    with OrderExpireDescriptionRef {
  _OrderExpireDescriptionProviderElement(super.provider);

  @override
  Option<UiOwnOrder> get optionOrder =>
      (origin as OrderExpireDescriptionProvider).optionOrder;
}

String _$marketStartOrderQuoteSuccessHash() =>
    r'a6487b80fe873d007c4aa33eac1304075d06f877';

/// See also [marketStartOrderQuoteSuccess].
@ProviderFor(marketStartOrderQuoteSuccess)
final marketStartOrderQuoteSuccessProvider =
    AutoDisposeProvider<Option<QuoteSuccess>>.internal(
      marketStartOrderQuoteSuccess,
      name: r'marketStartOrderQuoteSuccessProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketStartOrderQuoteSuccessHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketStartOrderQuoteSuccessRef =
    AutoDisposeProviderRef<Option<QuoteSuccess>>;
String _$marketStartOrderLowBalanceErrorHash() =>
    r'1fd7990efd18a0ae6bb497f144ba863c61a747f9';

/// See also [marketStartOrderLowBalanceError].
@ProviderFor(marketStartOrderLowBalanceError)
final marketStartOrderLowBalanceErrorProvider =
    AutoDisposeProvider<Option<QuoteLowBalance>>.internal(
      marketStartOrderLowBalanceError,
      name: r'marketStartOrderLowBalanceErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketStartOrderLowBalanceErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketStartOrderLowBalanceErrorRef =
    AutoDisposeProviderRef<Option<QuoteLowBalance>>;
String _$marketStartOrderQuoteErrorHash() =>
    r'264285e6da2f9b34f3474e4af58b4e53a6ff1188';

/// See also [marketStartOrderQuoteError].
@ProviderFor(marketStartOrderQuoteError)
final marketStartOrderQuoteErrorProvider =
    AutoDisposeProvider<Option<QuoteError>>.internal(
      marketStartOrderQuoteError,
      name: r'marketStartOrderQuoteErrorProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketStartOrderQuoteErrorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketStartOrderQuoteErrorRef =
    AutoDisposeProviderRef<Option<QuoteError>>;
String _$marketTradeRepositoryHash() =>
    r'dc3cf0dfe476b780fe5537aa2fb5d64f77206813';

/// See also [marketTradeRepository].
@ProviderFor(marketTradeRepository)
final marketTradeRepositoryProvider =
    AutoDisposeProvider<AbstractMarketTradeRepository>.internal(
      marketTradeRepository,
      name: r'marketTradeRepositoryProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketTradeRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MarketTradeRepositoryRef =
    AutoDisposeProviderRef<AbstractMarketTradeRepository>;
String _$limitFeeAssetHash() => r'1a882be15d4d90369c2cc7e6bbf4817b026a4dc5';

/// See also [limitFeeAsset].
@ProviderFor(limitFeeAsset)
final limitFeeAssetProvider = AutoDisposeProvider<Option<Asset>>.internal(
  limitFeeAsset,
  name: r'limitFeeAssetProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitFeeAssetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LimitFeeAssetRef = AutoDisposeProviderRef<Option<Asset>>;
String _$limitMinimumFeeAmountHash() =>
    r'b2e3574a7ef52cb36f9bc6eeb41b166e75152f2d';

/// See also [limitMinimumFeeAmount].
@ProviderFor(limitMinimumFeeAmount)
final limitMinimumFeeAmountProvider = AutoDisposeProvider<String>.internal(
  limitMinimumFeeAmount,
  name: r'limitMinimumFeeAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitMinimumFeeAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LimitMinimumFeeAmountRef = AutoDisposeProviderRef<String>;
String _$limitInsufficientAmountHash() =>
    r'e170c0a04513a3fd2ebc840dcc1c68a96063c8b8';

/// See also [limitInsufficientAmount].
@ProviderFor(limitInsufficientAmount)
final limitInsufficientAmountProvider = AutoDisposeProvider<bool>.internal(
  limitInsufficientAmount,
  name: r'limitInsufficientAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitInsufficientAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LimitInsufficientAmountRef = AutoDisposeProviderRef<bool>;
String _$limitInsufficientPriceHash() =>
    r'bbd7fbb7e2c07077e5d9e3fb9bee0bf7f7f1aa9b';

/// See also [limitInsufficientPrice].
@ProviderFor(limitInsufficientPrice)
final limitInsufficientPriceProvider = AutoDisposeProvider<bool>.internal(
  limitInsufficientPrice,
  name: r'limitInsufficientPriceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitInsufficientPriceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LimitInsufficientPriceRef = AutoDisposeProviderRef<bool>;
String _$tradeDirStateNotifierHash() =>
    r'5a70559c300307c02ed10ff386851d086b4e93bf';

/// See also [TradeDirStateNotifier].
@ProviderFor(TradeDirStateNotifier)
final tradeDirStateNotifierProvider =
    NotifierProvider<TradeDirStateNotifier, TradeDir>.internal(
      TradeDirStateNotifier.new,
      name: r'tradeDirStateNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$tradeDirStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TradeDirStateNotifier = Notifier<TradeDir>;
String _$marketsNotifierHash() => r'd48f2ec1a9d78e03afde2fea12220abb01935696';

/// Market list
///
/// Copied from [MarketsNotifier].
@ProviderFor(MarketsNotifier)
final marketsNotifierProvider =
    NotifierProvider<MarketsNotifier, List<MarketInfo>>.internal(
      MarketsNotifier.new,
      name: r'marketsNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketsNotifier = Notifier<List<MarketInfo>>;
String _$marketPublicOrdersNotifierHash() =>
    r'fda6ab2978ca643ec2437450dee980dc0e1b3585';

/// Public orders
///
/// Copied from [MarketPublicOrdersNotifier].
@ProviderFor(MarketPublicOrdersNotifier)
final marketPublicOrdersNotifierProvider = AutoDisposeNotifierProvider<
  MarketPublicOrdersNotifier,
  Map<AssetPair, List<PublicOrder>>
>.internal(
  MarketPublicOrdersNotifier.new,
  name: r'marketPublicOrdersNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketPublicOrdersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketPublicOrdersNotifier =
    AutoDisposeNotifier<Map<AssetPair, List<PublicOrder>>>;
String _$marketOwnOrdersNotifierHash() =>
    r'd08c11d040f8b76d187434986f8cd7569e157ea9';

/// Own orders
///
/// Copied from [MarketOwnOrdersNotifier].
@ProviderFor(MarketOwnOrdersNotifier)
final marketOwnOrdersNotifierProvider =
    NotifierProvider<MarketOwnOrdersNotifier, List<OwnOrder>>.internal(
      MarketOwnOrdersNotifier.new,
      name: r'marketOwnOrdersNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketOwnOrdersNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketOwnOrdersNotifier = Notifier<List<OwnOrder>>;
String _$marketSubscribedAssetPairNotifierHash() =>
    r'3d5d25991cfb32b8e20e18f1f391d279203d1b1e';

/// See also [MarketSubscribedAssetPairNotifier].
@ProviderFor(MarketSubscribedAssetPairNotifier)
final marketSubscribedAssetPairNotifierProvider = AutoDisposeNotifierProvider<
  MarketSubscribedAssetPairNotifier,
  Option<AssetPair>
>.internal(
  MarketSubscribedAssetPairNotifier.new,
  name: r'marketSubscribedAssetPairNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketSubscribedAssetPairNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketSubscribedAssetPairNotifier =
    AutoDisposeNotifier<Option<AssetPair>>;
String _$marketPriceNotifierHash() =>
    r'e7e51919d349b9a7b9252cdd3c6120149c38e262';

/// Index price
///
/// Copied from [MarketPriceNotifier].
@ProviderFor(MarketPriceNotifier)
final marketPriceNotifierProvider = AutoDisposeNotifierProvider<
  MarketPriceNotifier,
  Map<AssetPair, ({double indexPrice, double lastPrice})>
>.internal(
  MarketPriceNotifier.new,
  name: r'marketPriceNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketPriceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketPriceNotifier =
    AutoDisposeNotifier<
      Map<AssetPair, ({double indexPrice, double lastPrice})>
    >;
String _$marketSideStateNotifierHash() =>
    r'020f92d5c1c5c2d1d74398fa32eba5d0e4b44d75';

/// See also [MarketSideStateNotifier].
@ProviderFor(MarketSideStateNotifier)
final marketSideStateNotifierProvider = AutoDisposeNotifierProvider<
  MarketSideStateNotifier,
  MarketSideState
>.internal(
  MarketSideStateNotifier.new,
  name: r'marketSideStateNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketSideStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketSideStateNotifier = AutoDisposeNotifier<MarketSideState>;
String _$marketTypeSwitchStateNotifierHash() =>
    r'224ebaec567a018acd7475019073e6ed221f5452';

/// See also [MarketTypeSwitchStateNotifier].
@ProviderFor(MarketTypeSwitchStateNotifier)
final marketTypeSwitchStateNotifierProvider = AutoDisposeNotifierProvider<
  MarketTypeSwitchStateNotifier,
  MarketTypeSwitchState
>.internal(
  MarketTypeSwitchStateNotifier.new,
  name: r'marketTypeSwitchStateNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketTypeSwitchStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketTypeSwitchStateNotifier =
    AutoDisposeNotifier<MarketTypeSwitchState>;
String _$marketOrderAmountControllerNotifierHash() =>
    r'97277c4f5581707d7b9695103476a3adb6c83d9e';

/// See also [MarketOrderAmountControllerNotifier].
@ProviderFor(MarketOrderAmountControllerNotifier)
final marketOrderAmountControllerNotifierProvider = AutoDisposeNotifierProvider<
  MarketOrderAmountControllerNotifier,
  String
>.internal(
  MarketOrderAmountControllerNotifier.new,
  name: r'marketOrderAmountControllerNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketOrderAmountControllerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketOrderAmountControllerNotifier = AutoDisposeNotifier<String>;
String _$marketQuoteNotifierHash() =>
    r'91762b3ac218fd682a1db84875c14fb42c5e8bd2';

/// See also [MarketQuoteNotifier].
@ProviderFor(MarketQuoteNotifier)
final marketQuoteNotifierProvider = AutoDisposeNotifierProvider<
  MarketQuoteNotifier,
  Option<From_Quote>
>.internal(
  MarketQuoteNotifier.new,
  name: r'marketQuoteNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketQuoteNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketQuoteNotifier = AutoDisposeNotifier<Option<From_Quote>>;
String _$marketPreviewOrderQuoteNotifierHash() =>
    r'240a2ffa2af01242e4d7287c1c1ca67a63a43781';

/// See also [MarketPreviewOrderQuoteNotifier].
@ProviderFor(MarketPreviewOrderQuoteNotifier)
final marketPreviewOrderQuoteNotifierProvider = NotifierProvider<
  MarketPreviewOrderQuoteNotifier,
  Option<QuoteSuccess>
>.internal(
  MarketPreviewOrderQuoteNotifier.new,
  name: r'marketPreviewOrderQuoteNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketPreviewOrderQuoteNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketPreviewOrderQuoteNotifier = Notifier<Option<QuoteSuccess>>;
String _$marketPreviewOrderTtlHash() =>
    r'cd2bfe7578585ba9e1c340f15e6b5925a515933a';

/// See also [MarketPreviewOrderTtl].
@ProviderFor(MarketPreviewOrderTtl)
final marketPreviewOrderTtlProvider =
    AutoDisposeNotifierProvider<MarketPreviewOrderTtl, int>.internal(
      MarketPreviewOrderTtl.new,
      name: r'marketPreviewOrderTtlProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketPreviewOrderTtlHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketPreviewOrderTtl = AutoDisposeNotifier<int>;
String _$marketAcceptQuoteNotifierHash() =>
    r'2e8f0e4a97fba71f22043dae48b4fec088723ad6';

/// See also [MarketAcceptQuoteNotifier].
@ProviderFor(MarketAcceptQuoteNotifier)
final marketAcceptQuoteNotifierProvider = AutoDisposeNotifierProvider<
  MarketAcceptQuoteNotifier,
  Option<From_AcceptQuote>
>.internal(
  MarketAcceptQuoteNotifier.new,
  name: r'marketAcceptQuoteNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketAcceptQuoteNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketAcceptQuoteNotifier =
    AutoDisposeNotifier<Option<From_AcceptQuote>>;
String _$marketAcceptQuoteSuccessShowDialogNotifierHash() =>
    r'5c1f0ee5f5a4bda4c6576ce07ca31c5a00c252fd';

/// See also [MarketAcceptQuoteSuccessShowDialogNotifier].
@ProviderFor(MarketAcceptQuoteSuccessShowDialogNotifier)
final marketAcceptQuoteSuccessShowDialogNotifierProvider =
    AutoDisposeNotifierProvider<
      MarketAcceptQuoteSuccessShowDialogNotifier,
      bool
    >.internal(
      MarketAcceptQuoteSuccessShowDialogNotifier.new,
      name: r'marketAcceptQuoteSuccessShowDialogNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketAcceptQuoteSuccessShowDialogNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketAcceptQuoteSuccessShowDialogNotifier =
    AutoDisposeNotifier<bool>;
String _$limitTtlFlagNotifierHash() =>
    r'44f7e5c237f7e7c2cf3f4b8ce04c61e834bd4174';

/// See also [LimitTtlFlagNotifier].
@ProviderFor(LimitTtlFlagNotifier)
final limitTtlFlagNotifierProvider =
    AutoDisposeNotifierProvider<LimitTtlFlagNotifier, LimitTtlFlag>.internal(
      LimitTtlFlagNotifier.new,
      name: r'limitTtlFlagNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$limitTtlFlagNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LimitTtlFlagNotifier = AutoDisposeNotifier<LimitTtlFlag>;
String _$limitOrderAmountControllerNotifierHash() =>
    r'cdb9f2f94a3d57faa8605b289c851873d6f7cbef';

/// See also [LimitOrderAmountControllerNotifier].
@ProviderFor(LimitOrderAmountControllerNotifier)
final limitOrderAmountControllerNotifierProvider = AutoDisposeNotifierProvider<
  LimitOrderAmountControllerNotifier,
  String
>.internal(
  LimitOrderAmountControllerNotifier.new,
  name: r'limitOrderAmountControllerNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$limitOrderAmountControllerNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LimitOrderAmountControllerNotifier = AutoDisposeNotifier<String>;
String _$limitOrderPriceAmountControllerNotifierHash() =>
    r'f9dd77a4c3220c06fd2f70da72e97efdec5103cb';

/// See also [LimitOrderPriceAmountControllerNotifier].
@ProviderFor(LimitOrderPriceAmountControllerNotifier)
final limitOrderPriceAmountControllerNotifierProvider =
    AutoDisposeNotifierProvider<
      LimitOrderPriceAmountControllerNotifier,
      String
    >.internal(
      LimitOrderPriceAmountControllerNotifier.new,
      name: r'limitOrderPriceAmountControllerNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$limitOrderPriceAmountControllerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LimitOrderPriceAmountControllerNotifier = AutoDisposeNotifier<String>;
String _$orderSubmitNotifierHash() =>
    r'e029689020453e06ce8769ab983b38f384aed3ea';

/// See also [OrderSubmitNotifier].
@ProviderFor(OrderSubmitNotifier)
final orderSubmitNotifierProvider = AutoDisposeNotifierProvider<
  OrderSubmitNotifier,
  Option<From_OrderSubmit>
>.internal(
  OrderSubmitNotifier.new,
  name: r'orderSubmitNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$orderSubmitNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrderSubmitNotifier = AutoDisposeNotifier<Option<From_OrderSubmit>>;
String _$marketEditOrderErrorNotifierHash() =>
    r'e4c2bf12555c514fcf171a71c12cb74830fb1de6';

/// See also [MarketEditOrderErrorNotifier].
@ProviderFor(MarketEditOrderErrorNotifier)
final marketEditOrderErrorNotifierProvider = AutoDisposeNotifierProvider<
  MarketEditOrderErrorNotifier,
  Option<String>
>.internal(
  MarketEditOrderErrorNotifier.new,
  name: r'marketEditOrderErrorNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketEditOrderErrorNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketEditOrderErrorNotifier = AutoDisposeNotifier<Option<String>>;
String _$marketEditDetailsOrderNotifierHash() =>
    r'a6c4ccce88be01835f2b953731a04c7ba59e473b';

/// Edit order
///
/// Copied from [MarketEditDetailsOrderNotifier].
@ProviderFor(MarketEditDetailsOrderNotifier)
final marketEditDetailsOrderNotifierProvider = NotifierProvider<
  MarketEditDetailsOrderNotifier,
  Option<UiOwnOrder>
>.internal(
  MarketEditDetailsOrderNotifier.new,
  name: r'marketEditDetailsOrderNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketEditDetailsOrderNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketEditDetailsOrderNotifier = Notifier<Option<UiOwnOrder>>;
String _$marketEditOrderAmountControllerNotifierHash() =>
    r'7be8a01f977efdb612b5cb5c74b6563b94868a3d';

/// See also [MarketEditOrderAmountControllerNotifier].
@ProviderFor(MarketEditOrderAmountControllerNotifier)
final marketEditOrderAmountControllerNotifierProvider =
    AutoDisposeNotifierProvider<
      MarketEditOrderAmountControllerNotifier,
      String
    >.internal(
      MarketEditOrderAmountControllerNotifier.new,
      name: r'marketEditOrderAmountControllerNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketEditOrderAmountControllerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketEditOrderAmountControllerNotifier = AutoDisposeNotifier<String>;
String _$marketEditOrderPriceControllerNotifierHash() =>
    r'5bc9048d52ba2cebc7a070d7f0542bafed419653';

/// See also [MarketEditOrderPriceControllerNotifier].
@ProviderFor(MarketEditOrderPriceControllerNotifier)
final marketEditOrderPriceControllerNotifierProvider =
    AutoDisposeNotifierProvider<
      MarketEditOrderPriceControllerNotifier,
      String
    >.internal(
      MarketEditOrderPriceControllerNotifier.new,
      name: r'marketEditOrderPriceControllerNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketEditOrderPriceControllerNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketEditOrderPriceControllerNotifier = AutoDisposeNotifier<String>;
String _$marketLimitOrderTypeNotifierHash() =>
    r'89ab24438c3387f804836d2d7ab98182899bfa6f';

/// See also [MarketLimitOrderTypeNotifier].
@ProviderFor(MarketLimitOrderTypeNotifier)
final marketLimitOrderTypeNotifierProvider = AutoDisposeNotifierProvider<
  MarketLimitOrderTypeNotifier,
  OrderType
>.internal(
  MarketLimitOrderTypeNotifier.new,
  name: r'marketLimitOrderTypeNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketLimitOrderTypeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketLimitOrderTypeNotifier = AutoDisposeNotifier<OrderType>;
String _$marketLimitOfflineSwapHash() =>
    r'588f374bbd96127d847d6817ed61776bb2c1a032';

/// See also [MarketLimitOfflineSwap].
@ProviderFor(MarketLimitOfflineSwap)
final marketLimitOfflineSwapProvider = AutoDisposeNotifierProvider<
  MarketLimitOfflineSwap,
  OfflineSwapType
>.internal(
  MarketLimitOfflineSwap.new,
  name: r'marketLimitOfflineSwapProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketLimitOfflineSwapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketLimitOfflineSwap = AutoDisposeNotifier<OfflineSwapType>;
String _$marketHistoryTotalHash() =>
    r'394ab8e725c04578eee3dffe861a33f935e9b6d7';

/// See also [MarketHistoryTotal].
@ProviderFor(MarketHistoryTotal)
final marketHistoryTotalProvider =
    AutoDisposeNotifierProvider<MarketHistoryTotal, int>.internal(
      MarketHistoryTotal.new,
      name: r'marketHistoryTotalProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketHistoryTotalHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketHistoryTotal = AutoDisposeNotifier<int>;
String _$marketHistoryOrderNotifierHash() =>
    r'4d64088ad99e317c630acab75d957641f12ca67e';

/// See also [MarketHistoryOrderNotifier].
@ProviderFor(MarketHistoryOrderNotifier)
final marketHistoryOrderNotifierProvider = AutoDisposeNotifierProvider<
  MarketHistoryOrderNotifier,
  List<HistoryOrder>
>.internal(
  MarketHistoryOrderNotifier.new,
  name: r'marketHistoryOrderNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketHistoryOrderNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketHistoryOrderNotifier = AutoDisposeNotifier<List<HistoryOrder>>;
String _$indexPriceButtonAsyncNotifierHash() =>
    r'8a87ac6b0417c993de1de12a561a770f91fc93bd';

/// See also [IndexPriceButtonAsyncNotifier].
@ProviderFor(IndexPriceButtonAsyncNotifier)
final indexPriceButtonAsyncNotifierProvider = AutoDisposeNotifierProvider<
  IndexPriceButtonAsyncNotifier,
  AsyncValue<String>
>.internal(
  IndexPriceButtonAsyncNotifier.new,
  name: r'indexPriceButtonAsyncNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$indexPriceButtonAsyncNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IndexPriceButtonAsyncNotifier =
    AutoDisposeNotifier<AsyncValue<String>>;
String _$marketStartOrderNotifierHash() =>
    r'aca30b4faa36400ccadbf8e1bd9baea8321ab47a';

/// See also [MarketStartOrderNotifier].
@ProviderFor(MarketStartOrderNotifier)
final marketStartOrderNotifierProvider =
    NotifierProvider<MarketStartOrderNotifier, Option<int>>.internal(
      MarketStartOrderNotifier.new,
      name: r'marketStartOrderNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketStartOrderNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketStartOrderNotifier = Notifier<Option<int>>;
String _$marketStartOrderErrorNotifierHash() =>
    r'ea1da45c324cea796fe6ff40c978a6ac20a55e9f';

/// See also [MarketStartOrderErrorNotifier].
@ProviderFor(MarketStartOrderErrorNotifier)
final marketStartOrderErrorNotifierProvider = AutoDisposeNotifierProvider<
  MarketStartOrderErrorNotifier,
  Option<StartOrderError>
>.internal(
  MarketStartOrderErrorNotifier.new,
  name: r'marketStartOrderErrorNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$marketStartOrderErrorNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketStartOrderErrorNotifier =
    AutoDisposeNotifier<Option<StartOrderError>>;
String _$marketOneTimeAuthorizedHash() =>
    r'4b663a09c9f578ae97b70f816cfa31dbe90e5ebc';

/// See also [MarketOneTimeAuthorized].
@ProviderFor(MarketOneTimeAuthorized)
final marketOneTimeAuthorizedProvider =
    AutoDisposeNotifierProvider<MarketOneTimeAuthorized, bool>.internal(
      MarketOneTimeAuthorized.new,
      name: r'marketOneTimeAuthorizedProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketOneTimeAuthorizedHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketOneTimeAuthorized = AutoDisposeNotifier<bool>;
String _$marketMinimalAmountsNotfierHash() =>
    r'f5c08326d9de968c56c855822b3d5d4196ff3dbf';

/// See also [MarketMinimalAmountsNotfier].
@ProviderFor(MarketMinimalAmountsNotfier)
final marketMinimalAmountsNotfierProvider =
    NotifierProvider<MarketMinimalAmountsNotfier, Map<String, int>>.internal(
      MarketMinimalAmountsNotfier.new,
      name: r'marketMinimalAmountsNotfierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$marketMinimalAmountsNotfierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MarketMinimalAmountsNotfier = Notifier<Map<String, int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
