// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'markets_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$marketsHelperHash() => r'36771d3f7d831b88bb06fdf1a1576704b430fcaa';

/// See also [marketsHelper].
@ProviderFor(marketsHelper)
final marketsHelperProvider = AutoDisposeProvider<MarketsHelper>.internal(
  marketsHelper,
  name: r'marketsHelperProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketsHelperHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketsHelperRef = AutoDisposeProviderRef<MarketsHelper>;
String _$indexPriceForAssetHash() =>
    r'1c5b8a313471b95480b8238b4cd492efc31157d3';

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

/// See also [indexPriceForAsset].
@ProviderFor(indexPriceForAsset)
const indexPriceForAssetProvider = IndexPriceForAssetFamily();

/// See also [indexPriceForAsset].
class IndexPriceForAssetFamily extends Family<IndexPriceForAsset> {
  /// See also [indexPriceForAsset].
  const IndexPriceForAssetFamily();

  /// See also [indexPriceForAsset].
  IndexPriceForAssetProvider call(
    String? assetId,
  ) {
    return IndexPriceForAssetProvider(
      assetId,
    );
  }

  @override
  IndexPriceForAssetProvider getProviderOverride(
    covariant IndexPriceForAssetProvider provider,
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
  String? get name => r'indexPriceForAssetProvider';
}

/// See also [indexPriceForAsset].
class IndexPriceForAssetProvider
    extends AutoDisposeProvider<IndexPriceForAsset> {
  /// See also [indexPriceForAsset].
  IndexPriceForAssetProvider(
    String? assetId,
  ) : this._internal(
          (ref) => indexPriceForAsset(
            ref as IndexPriceForAssetRef,
            assetId,
          ),
          from: indexPriceForAssetProvider,
          name: r'indexPriceForAssetProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$indexPriceForAssetHash,
          dependencies: IndexPriceForAssetFamily._dependencies,
          allTransitiveDependencies:
              IndexPriceForAssetFamily._allTransitiveDependencies,
          assetId: assetId,
        );

  IndexPriceForAssetProvider._internal(
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
    IndexPriceForAsset Function(IndexPriceForAssetRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IndexPriceForAssetProvider._internal(
        (ref) => create(ref as IndexPriceForAssetRef),
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
  AutoDisposeProviderElement<IndexPriceForAsset> createElement() {
    return _IndexPriceForAssetProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IndexPriceForAssetProvider && other.assetId == assetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, assetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IndexPriceForAssetRef on AutoDisposeProviderRef<IndexPriceForAsset> {
  /// The parameter `assetId` of this provider.
  String? get assetId;
}

class _IndexPriceForAssetProviderElement
    extends AutoDisposeProviderElement<IndexPriceForAsset>
    with IndexPriceForAssetRef {
  _IndexPriceForAssetProviderElement(super.provider);

  @override
  String? get assetId => (origin as IndexPriceForAssetProvider).assetId;
}

String _$lastIndexPriceForAssetHash() =>
    r'a46c2e3a869efcfc0dc47e5609b65717a93cd739';

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

String _$marketRequestOrderListHash() =>
    r'94a3c8c08df5fae5cf9c48a214474c7cabd70f45';

/// See also [marketRequestOrderList].
@ProviderFor(marketRequestOrderList)
final marketRequestOrderListProvider =
    AutoDisposeProvider<List<RequestOrder>>.internal(
  marketRequestOrderList,
  name: r'marketRequestOrderListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketRequestOrderListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketRequestOrderListRef = AutoDisposeProviderRef<List<RequestOrder>>;
String _$marketRequestOrderByIdHash() =>
    r'58c0cc7eb57cfec19a16628fa9e15ba84a3b753a';

/// See also [marketRequestOrderById].
@ProviderFor(marketRequestOrderById)
const marketRequestOrderByIdProvider = MarketRequestOrderByIdFamily();

/// See also [marketRequestOrderById].
class MarketRequestOrderByIdFamily extends Family<RequestOrder?> {
  /// See also [marketRequestOrderById].
  const MarketRequestOrderByIdFamily();

  /// See also [marketRequestOrderById].
  MarketRequestOrderByIdProvider call(
    String orderId,
  ) {
    return MarketRequestOrderByIdProvider(
      orderId,
    );
  }

  @override
  MarketRequestOrderByIdProvider getProviderOverride(
    covariant MarketRequestOrderByIdProvider provider,
  ) {
    return call(
      provider.orderId,
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
  String? get name => r'marketRequestOrderByIdProvider';
}

/// See also [marketRequestOrderById].
class MarketRequestOrderByIdProvider
    extends AutoDisposeProvider<RequestOrder?> {
  /// See also [marketRequestOrderById].
  MarketRequestOrderByIdProvider(
    String orderId,
  ) : this._internal(
          (ref) => marketRequestOrderById(
            ref as MarketRequestOrderByIdRef,
            orderId,
          ),
          from: marketRequestOrderByIdProvider,
          name: r'marketRequestOrderByIdProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$marketRequestOrderByIdHash,
          dependencies: MarketRequestOrderByIdFamily._dependencies,
          allTransitiveDependencies:
              MarketRequestOrderByIdFamily._allTransitiveDependencies,
          orderId: orderId,
        );

  MarketRequestOrderByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.orderId,
  }) : super.internal();

  final String orderId;

  @override
  Override overrideWith(
    RequestOrder? Function(MarketRequestOrderByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MarketRequestOrderByIdProvider._internal(
        (ref) => create(ref as MarketRequestOrderByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        orderId: orderId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<RequestOrder?> createElement() {
    return _MarketRequestOrderByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MarketRequestOrderByIdProvider && other.orderId == orderId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, orderId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin MarketRequestOrderByIdRef on AutoDisposeProviderRef<RequestOrder?> {
  /// The parameter `orderId` of this provider.
  String get orderId;
}

class _MarketRequestOrderByIdProviderElement
    extends AutoDisposeProviderElement<RequestOrder?>
    with MarketRequestOrderByIdRef {
  _MarketRequestOrderByIdProviderElement(super.provider);

  @override
  String get orderId => (origin as MarketRequestOrderByIdProvider).orderId;
}

String _$marketOwnRequestOrdersHash() =>
    r'78d0b087efe68599ec7a5d2f574422c23f292428';

/// See also [marketOwnRequestOrders].
@ProviderFor(marketOwnRequestOrders)
final marketOwnRequestOrdersProvider =
    AutoDisposeProvider<List<RequestOrder>>.internal(
  marketOwnRequestOrders,
  name: r'marketOwnRequestOrdersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketOwnRequestOrdersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MarketOwnRequestOrdersRef = AutoDisposeProviderRef<List<RequestOrder>>;
String _$makeOrderBalanceAccountAssetHash() =>
    r'28f2168218952cefea936746dcbd284f58e923bf';

/// See also [makeOrderBalanceAccountAsset].
@ProviderFor(makeOrderBalanceAccountAsset)
final makeOrderBalanceAccountAssetProvider =
    AutoDisposeProvider<AccountAsset?>.internal(
  makeOrderBalanceAccountAsset,
  name: r'makeOrderBalanceAccountAssetProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$makeOrderBalanceAccountAssetHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MakeOrderBalanceAccountAssetRef = AutoDisposeProviderRef<AccountAsset?>;
String _$makeOrderBalanceHash() => r'44037793a2734d9eab8fd41148e978b9205f33e6';

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
    r'65518176f48768955b98761f535b9e28716fe594';

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
    r'b1b990c314a443645ba5e4b77712124f99aadd96';

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
String _$selectedAssetIsTokenHash() =>
    r'25a6c7bc80b1db58624a8b3c20c27df2153bcb42';

/// See also [selectedAssetIsToken].
@ProviderFor(selectedAssetIsToken)
final selectedAssetIsTokenProvider = AutoDisposeProvider<bool>.internal(
  selectedAssetIsToken,
  name: r'selectedAssetIsTokenProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedAssetIsTokenHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedAssetIsTokenRef = AutoDisposeProviderRef<bool>;
String _$targetIndexPriceHash() => r'd25dcd84774683567ec1688b781f41f69ff2dfa4';

/// See also [targetIndexPrice].
@ProviderFor(targetIndexPrice)
final targetIndexPriceProvider = AutoDisposeProvider<String>.internal(
  targetIndexPrice,
  name: r'targetIndexPriceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$targetIndexPriceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TargetIndexPriceRef = AutoDisposeProviderRef<String>;
String _$selectedAssetTickerHash() =>
    r'8505ca9b33eb56d542a4b62bb0992201e737fe05';

/// See also [selectedAssetTicker].
@ProviderFor(selectedAssetTicker)
final selectedAssetTickerProvider = AutoDisposeProvider<String>.internal(
  selectedAssetTicker,
  name: r'selectedAssetTickerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedAssetTickerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SelectedAssetTickerRef = AutoDisposeProviderRef<String>;
String _$orderEntryCallbackHandlersHash() =>
    r'017802e56b1e85eb855dd591f1511149f6002e98';

/// See also [orderEntryCallbackHandlers].
@ProviderFor(orderEntryCallbackHandlers)
final orderEntryCallbackHandlersProvider =
    AutoDisposeProvider<OrderEntryCallbackHandlers>.internal(
  orderEntryCallbackHandlers,
  name: r'orderEntryCallbackHandlersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderEntryCallbackHandlersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrderEntryCallbackHandlersRef
    = AutoDisposeProviderRef<OrderEntryCallbackHandlers>;
String _$indexPriceSubscriberNotifierHash() =>
    r'599c5c73c7f18c29f779fe2cade92afc071e9875';

/// See also [IndexPriceSubscriberNotifier].
@ProviderFor(IndexPriceSubscriberNotifier)
final indexPriceSubscriberNotifierProvider =
    NotifierProvider<IndexPriceSubscriberNotifier, Set<String>>.internal(
  IndexPriceSubscriberNotifier.new,
  name: r'indexPriceSubscriberNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$indexPriceSubscriberNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IndexPriceSubscriberNotifier = Notifier<Set<String>>;
String _$marketAssetSubscriberNotifierHash() =>
    r'be2f2931eba9d73c029a999b2098e84be2926fd0';

/// See also [MarketAssetSubscriberNotifier].
@ProviderFor(MarketAssetSubscriberNotifier)
final marketAssetSubscriberNotifierProvider = NotifierProvider<
    MarketAssetSubscriberNotifier,
    Set<
        ({
          String assetId,
          SubscribedMarketEnumType subscribedMarketType
        })>>.internal(
  MarketAssetSubscriberNotifier.new,
  name: r'marketAssetSubscriberNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketAssetSubscriberNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketAssetSubscriberNotifier = Notifier<
    Set<({String assetId, SubscribedMarketEnumType subscribedMarketType})>>;
String _$marketsIndexPriceNotifierHash() =>
    r'b72df652205dcb349e15d10846f72fae57028f1d';

/// See also [MarketsIndexPriceNotifier].
@ProviderFor(MarketsIndexPriceNotifier)
final marketsIndexPriceNotifierProvider =
    NotifierProvider<MarketsIndexPriceNotifier, Map<String, double>>.internal(
  MarketsIndexPriceNotifier.new,
  name: r'marketsIndexPriceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketsIndexPriceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketsIndexPriceNotifier = Notifier<Map<String, double>>;
String _$marketsLastIndexPriceNotifierHash() =>
    r'e4da25b4944673dafc5dac242c596d90ee494898';

/// See also [MarketsLastIndexPriceNotifier].
@ProviderFor(MarketsLastIndexPriceNotifier)
final marketsLastIndexPriceNotifierProvider = NotifierProvider<
    MarketsLastIndexPriceNotifier, Map<String, double>>.internal(
  MarketsLastIndexPriceNotifier.new,
  name: r'marketsLastIndexPriceNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketsLastIndexPriceNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketsLastIndexPriceNotifier = Notifier<Map<String, double>>;
String _$indexPriceButtonStreamNotifierHash() =>
    r'fb66822555e37894b93d54a7cdb66f6621d324a9';

/// See also [IndexPriceButtonStreamNotifier].
@ProviderFor(IndexPriceButtonStreamNotifier)
final indexPriceButtonStreamNotifierProvider =
    AutoDisposeStreamNotifierProvider<IndexPriceButtonStreamNotifier,
        String>.internal(
  IndexPriceButtonStreamNotifier.new,
  name: r'indexPriceButtonStreamNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$indexPriceButtonStreamNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IndexPriceButtonStreamNotifier = AutoDisposeStreamNotifier<String>;
String _$marketsRequestOrdersNotifierHash() =>
    r'95238085e6791b1726c0d0b3d9c8361f4968dd70';

/// See also [MarketsRequestOrdersNotifier].
@ProviderFor(MarketsRequestOrdersNotifier)
final marketsRequestOrdersNotifierProvider = NotifierProvider<
    MarketsRequestOrdersNotifier, Map<String, RequestOrder>>.internal(
  MarketsRequestOrdersNotifier.new,
  name: r'marketsRequestOrdersNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketsRequestOrdersNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketsRequestOrdersNotifier = Notifier<Map<String, RequestOrder>>;
String _$marketSelectedAccountAssetStateHash() =>
    r'2d7562ababf278bb0e58f1c8b565f8d46efe5631';

/// See also [MarketSelectedAccountAssetState].
@ProviderFor(MarketSelectedAccountAssetState)
final marketSelectedAccountAssetStateProvider =
    NotifierProvider<MarketSelectedAccountAssetState, AccountAsset>.internal(
  MarketSelectedAccountAssetState.new,
  name: r'marketSelectedAccountAssetStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$marketSelectedAccountAssetStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MarketSelectedAccountAssetState = Notifier<AccountAsset>;
String _$makeOrderSideStateHash() =>
    r'1f5389bde146900b057350e5ad2d05736f8a4097';

/// See also [MakeOrderSideState].
@ProviderFor(MakeOrderSideState)
final makeOrderSideStateProvider =
    NotifierProvider<MakeOrderSideState, MakeOrderSide>.internal(
  MakeOrderSideState.new,
  name: r'makeOrderSideStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$makeOrderSideStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MakeOrderSideState = Notifier<MakeOrderSide>;
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
