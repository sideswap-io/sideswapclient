// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lastIndexPriceForAssetHash() =>
    r'6e077fa9d81f4a45a742e1e0aec0d2ace8c4f1b3';

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

/// See also [lastIndexPriceForAsset].
@ProviderFor(lastIndexPriceForAsset)
const lastIndexPriceForAssetProvider = LastIndexPriceForAssetFamily();

/// See also [lastIndexPriceForAsset].
class LastIndexPriceForAssetFamily extends Family<double> {
  /// See also [lastIndexPriceForAsset].
  const LastIndexPriceForAssetFamily();

  /// See also [lastIndexPriceForAsset].
  LastIndexPriceForAssetProvider call(
    String? assetId,
  ) {
    return LastIndexPriceForAssetProvider(
      assetId,
    );
  }

  @override
  LastIndexPriceForAssetProvider getProviderOverride(
    covariant LastIndexPriceForAssetProvider provider,
  ) {
    return call(
      provider.assetId,
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
  String? get name => r'lastIndexPriceForAssetProvider';
}

/// See also [lastIndexPriceForAsset].
class LastIndexPriceForAssetProvider extends AutoDisposeProvider<double> {
  /// See also [lastIndexPriceForAsset].
  LastIndexPriceForAssetProvider(
    String? assetId,
  ) : this._internal(
          (ref) => lastIndexPriceForAsset(
            ref as LastIndexPriceForAssetRef,
            assetId,
          ),
          from: lastIndexPriceForAssetProvider,
          name: r'lastIndexPriceForAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lastIndexPriceForAssetHash,
          dependencies: LastIndexPriceForAssetFamily._dependencies,
          allTransitiveDependencies:
              LastIndexPriceForAssetFamily._allTransitiveDependencies,
          assetId: assetId,
        );

  LastIndexPriceForAssetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String? assetId;

  @override
  Override overrideWith(
    double Function(LastIndexPriceForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LastIndexPriceForAssetProvider._internal(
        (ref) => create(ref as LastIndexPriceForAssetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _LastIndexPriceForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LastIndexPriceForAssetProvider && other.assetId == assetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LastIndexPriceForAssetRef on AutoDisposeProviderRef<double> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _LastIndexPriceForAssetProviderElement
    extends AutoDisposeProviderElement<double> with LastIndexPriceForAssetRef {
  _LastIndexPriceForAssetProviderElement(super.provider);

  @override
  String? get assetId => (origin as LastIndexPriceForAssetProvider).assetId;
}

String _$lastStringIndexPriceForAssetHash() =>
    r'0c7acc3e1df5be820d36747236fca58c9a020739';

/// See also [lastStringIndexPriceForAsset].
@ProviderFor(lastStringIndexPriceForAsset)
const lastStringIndexPriceForAssetProvider =
    LastStringIndexPriceForAssetFamily();

/// See also [lastStringIndexPriceForAsset].
class LastStringIndexPriceForAssetFamily extends Family<String> {
  /// See also [lastStringIndexPriceForAsset].
  const LastStringIndexPriceForAssetFamily();

  /// See also [lastStringIndexPriceForAsset].
  LastStringIndexPriceForAssetProvider call(
    String? assetId,
  ) {
    return LastStringIndexPriceForAssetProvider(
      assetId,
    );
  }

  @override
  LastStringIndexPriceForAssetProvider getProviderOverride(
    covariant LastStringIndexPriceForAssetProvider provider,
  ) {
    return call(
      provider.assetId,
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
  String? get name => r'lastStringIndexPriceForAssetProvider';
}

/// See also [lastStringIndexPriceForAsset].
class LastStringIndexPriceForAssetProvider extends AutoDisposeProvider<String> {
  /// See also [lastStringIndexPriceForAsset].
  LastStringIndexPriceForAssetProvider(
    String? assetId,
  ) : this._internal(
          (ref) => lastStringIndexPriceForAsset(
            ref as LastStringIndexPriceForAssetRef,
            assetId,
          ),
          from: lastStringIndexPriceForAssetProvider,
          name: r'lastStringIndexPriceForAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$lastStringIndexPriceForAssetHash,
          dependencies: LastStringIndexPriceForAssetFamily._dependencies,
          allTransitiveDependencies:
              LastStringIndexPriceForAssetFamily._allTransitiveDependencies,
          assetId: assetId,
        );

  LastStringIndexPriceForAssetProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.assetId,
  }) : super.internal();

  final String? assetId;

  @override
  Override overrideWith(
    String Function(LastStringIndexPriceForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: LastStringIndexPriceForAssetProvider._internal(
        (ref) => create(ref as LastStringIndexPriceForAssetRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        assetId: assetId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _LastStringIndexPriceForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LastStringIndexPriceForAssetProvider &&
        other.assetId == assetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin LastStringIndexPriceForAssetRef on AutoDisposeProviderRef<String> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _LastStringIndexPriceForAssetProviderElement
    extends AutoDisposeProviderElement<String>
    with LastStringIndexPriceForAssetRef {
  _LastStringIndexPriceForAssetProviderElement(super.provider);

  @override
  String? get assetId =>
      (origin as LastStringIndexPriceForAssetProvider).assetId;
}

String _$makeOrderBalanceHash() => r'c4e24cde081dc54370cd4eab1ec5bd46672870ad';

/// See also [makeOrderBalance].
@ProviderFor(makeOrderBalance)
final makeOrderBalanceProvider = AutoDisposeProvider<MakeOrderBalance>.internal(
  makeOrderBalance,
  name: r'makeOrderBalanceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$makeOrderBalanceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MakeOrderBalanceRef = AutoDisposeProviderRef<MakeOrderBalance>;
String _$marketOrderAggregateVolumeAccountAssetHash() =>
    r'15b5c1a105e4d3d8c422919f898d7d6cb4302f5a';

/// See also [marketOrderAggregateVolumeAccountAsset].
@ProviderFor(marketOrderAggregateVolumeAccountAsset)
final marketOrderAggregateVolumeAccountAssetProvider =
    AutoDisposeProvider<AccountAsset?>.internal(
  marketOrderAggregateVolumeAccountAsset,
  name: r'marketOrderAggregateVolumeAccountAssetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketOrderAggregateVolumeAccountAssetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketOrderAggregateVolumeAccountAssetRef
    = AutoDisposeProviderRef<AccountAsset?>;
String _$marketOrderAggregateVolumeTickerHash() =>
    r'cd1885bc4f719da2c201c961d6782e13ac87bba1';

/// See also [marketOrderAggregateVolumeTicker].
@ProviderFor(marketOrderAggregateVolumeTicker)
final marketOrderAggregateVolumeTickerProvider =
    AutoDisposeProvider<String>.internal(
  marketOrderAggregateVolumeTicker,
  name: r'marketOrderAggregateVolumeTickerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketOrderAggregateVolumeTickerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketOrderAggregateVolumeTickerRef = AutoDisposeProviderRef<String>;
String _$marketOrderAggregateVolumeHash() =>
    r'1526bdf149e92827f288e2878afd4ef9c76b8901';

/// See also [marketOrderAggregateVolume].
@ProviderFor(marketOrderAggregateVolume)
final marketOrderAggregateVolumeProvider =
    AutoDisposeProvider<MarketOrderAggregateVolumeProvider>.internal(
  marketOrderAggregateVolume,
  name: r'marketOrderAggregateVolumeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketOrderAggregateVolumeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketOrderAggregateVolumeRef
    = AutoDisposeProviderRef<MarketOrderAggregateVolumeProvider>;
String _$marketOrderAggregateVolumeWithTickerHash() =>
    r'3d41ee98b6e1745e0b2e950c0805ae00cebf27ad';

/// See also [marketOrderAggregateVolumeWithTicker].
@ProviderFor(marketOrderAggregateVolumeWithTicker)
final marketOrderAggregateVolumeWithTickerProvider =
    AutoDisposeProvider<String>.internal(
  marketOrderAggregateVolumeWithTicker,
  name: r'marketOrderAggregateVolumeWithTickerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketOrderAggregateVolumeWithTickerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketOrderAggregateVolumeWithTickerRef
    = AutoDisposeProviderRef<String>;
String _$makeOrderAggregateVolumeTooHighHash() =>
    r'0b99b13ebec608d217ec34d06dc16301d61230f8';

/// See also [makeOrderAggregateVolumeTooHigh].
@ProviderFor(makeOrderAggregateVolumeTooHigh)
final makeOrderAggregateVolumeTooHighProvider =
    AutoDisposeProvider<bool>.internal(
  makeOrderAggregateVolumeTooHigh,
  name: r'makeOrderAggregateVolumeTooHighProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$makeOrderAggregateVolumeTooHighHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MakeOrderAggregateVolumeTooHighRef = AutoDisposeProviderRef<bool>;
String _$makeOrderLiquidAccountAssetHash() =>
    r'5617e2cb41c3c2328ac34238695fb498992412b3';

/// See also [makeOrderLiquidAccountAsset].
@ProviderFor(makeOrderLiquidAccountAsset)
final makeOrderLiquidAccountAssetProvider =
    AutoDisposeProvider<AccountAsset?>.internal(
  makeOrderLiquidAccountAsset,
  name: r'makeOrderLiquidAccountAssetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$makeOrderLiquidAccountAssetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MakeOrderLiquidAccountAssetRef = AutoDisposeProviderRef<AccountAsset?>;
String _$marketSelectedAssetIdStateHash() =>
    r'e6aea220a4e40cfa183e33b43a2edcec9b28900c';

/// See also [MarketSelectedAssetIdState].
@ProviderFor(MarketSelectedAssetIdState)
final marketSelectedAssetIdStateProvider =
    NotifierProvider<MarketSelectedAssetIdState, String>.internal(
  MarketSelectedAssetIdState.new,
  name: r'marketSelectedAssetIdStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketSelectedAssetIdStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketSelectedAssetIdState = Notifier<String>;
String _$marketOrderAmountNotifierHash() =>
    r'bd65a8e5adf4cdc72398cd7c196a5c448238ee57';

/// See also [MarketOrderAmountNotifier].
@ProviderFor(MarketOrderAmountNotifier)
final marketOrderAmountNotifierProvider = AutoDisposeNotifierProvider<
    MarketOrderAmountNotifier, MarketOrderAmount>.internal(
  MarketOrderAmountNotifier.new,
  name: r'marketOrderAmountNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketOrderAmountNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketOrderAmountNotifier = AutoDisposeNotifier<MarketOrderAmount>;
String _$marketOrderPriceNotifierHash() =>
    r'0db778cc174f7e86e94014cce5021705f9938914';

/// See also [MarketOrderPriceNotifier].
@ProviderFor(MarketOrderPriceNotifier)
final marketOrderPriceNotifierProvider = AutoDisposeNotifierProvider<
    MarketOrderPriceNotifier, MarketOrderAmount>.internal(
  MarketOrderPriceNotifier.new,
  name: r'marketOrderPriceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketOrderPriceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketOrderPriceNotifier = AutoDisposeNotifier<MarketOrderAmount>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
