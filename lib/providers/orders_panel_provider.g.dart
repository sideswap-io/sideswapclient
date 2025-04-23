// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_panel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$internalUiOrdersHash() => r'f33866cf468a8a65bb5cdf76b2dadac47c01e067';

/// See also [internalUiOrders].
@ProviderFor(internalUiOrders)
final internalUiOrdersProvider =
    AutoDisposeProvider<Iterable<InternalUiOrder>>.internal(
      internalUiOrders,
      name: r'internalUiOrdersProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$internalUiOrdersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef InternalUiOrdersRef = AutoDisposeProviderRef<Iterable<InternalUiOrder>>;
String _$maxOrderAmountHash() => r'8770516371abd8eb6549673fffc2342454aac366';

/// See also [maxOrderAmount].
@ProviderFor(maxOrderAmount)
final maxOrderAmountProvider = AutoDisposeProvider<Decimal>.internal(
  maxOrderAmount,
  name: r'maxOrderAmountProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$maxOrderAmountHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MaxOrderAmountRef = AutoDisposeProviderRef<Decimal>;
String _$ordersBidsHash() => r'a36debc09ddfbbf6d4b79f863a098bafe531f8ed';

/// See also [ordersBids].
@ProviderFor(ordersBids)
final ordersBidsProvider =
    AutoDisposeProvider<Iterable<InternalUiOrder>>.internal(
      ordersBids,
      name: r'ordersBidsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$ordersBidsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrdersBidsRef = AutoDisposeProviderRef<Iterable<InternalUiOrder>>;
String _$ordersAsksHash() => r'a219b8095af5c092805bad910834c13d3af9184e';

/// See also [ordersAsks].
@ProviderFor(ordersAsks)
final ordersAsksProvider =
    AutoDisposeProvider<Iterable<InternalUiOrder>>.internal(
      ordersAsks,
      name: r'ordersAsksProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$ordersAsksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrdersAsksRef = AutoDisposeProviderRef<Iterable<InternalUiOrder>>;
String _$mapRangeHash() => r'b9b31cf27f8ce8e3492e8c1bced581c77f6fd535';

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

/// See also [mapRange].
@ProviderFor(mapRange)
const mapRangeProvider = MapRangeFamily();

/// See also [mapRange].
class MapRangeFamily extends Family<Decimal> {
  /// See also [mapRange].
  const MapRangeFamily();

  /// See also [mapRange].
  MapRangeProvider call(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) {
    return MapRangeProvider(value, inMin, inMax, outMin, outMax);
  }

  @override
  MapRangeProvider getProviderOverride(covariant MapRangeProvider provider) {
    return call(
      provider.value,
      provider.inMin,
      provider.inMax,
      provider.outMin,
      provider.outMax,
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
  String? get name => r'mapRangeProvider';
}

/// See also [mapRange].
class MapRangeProvider extends AutoDisposeProvider<Decimal> {
  /// See also [mapRange].
  MapRangeProvider(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) : this._internal(
        (ref) =>
            mapRange(ref as MapRangeRef, value, inMin, inMax, outMin, outMax),
        from: mapRangeProvider,
        name: r'mapRangeProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$mapRangeHash,
        dependencies: MapRangeFamily._dependencies,
        allTransitiveDependencies: MapRangeFamily._allTransitiveDependencies,
        value: value,
        inMin: inMin,
        inMax: inMax,
        outMin: outMin,
        outMax: outMax,
      );

  MapRangeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.value,
    required this.inMin,
    required this.inMax,
    required this.outMin,
    required this.outMax,
  }) : super.internal();

  final double value;
  final double inMin;
  final double inMax;
  final double outMin;
  final double outMax;

  @override
  Override overrideWith(Decimal Function(MapRangeRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: MapRangeProvider._internal(
        (ref) => create(ref as MapRangeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        value: value,
        inMin: inMin,
        inMax: inMax,
        outMin: outMin,
        outMax: outMax,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Decimal> createElement() {
    return _MapRangeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MapRangeProvider &&
        other.value == value &&
        other.inMin == inMin &&
        other.inMax == inMax &&
        other.outMin == outMin &&
        other.outMax == outMax;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, value.hashCode);
    hash = _SystemHash.combine(hash, inMin.hashCode);
    hash = _SystemHash.combine(hash, inMax.hashCode);
    hash = _SystemHash.combine(hash, outMin.hashCode);
    hash = _SystemHash.combine(hash, outMax.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MapRangeRef on AutoDisposeProviderRef<Decimal> {
  /// The parameter `value` of this provider.
  double get value;

  /// The parameter `inMin` of this provider.
  double get inMin;

  /// The parameter `inMax` of this provider.
  double get inMax;

  /// The parameter `outMin` of this provider.
  double get outMin;

  /// The parameter `outMax` of this provider.
  double get outMax;
}

class _MapRangeProviderElement extends AutoDisposeProviderElement<Decimal>
    with MapRangeRef {
  _MapRangeProviderElement(super.provider);

  @override
  double get value => (origin as MapRangeProvider).value;
  @override
  double get inMin => (origin as MapRangeProvider).inMin;
  @override
  double get inMax => (origin as MapRangeProvider).inMax;
  @override
  double get outMin => (origin as MapRangeProvider).outMin;
  @override
  double get outMax => (origin as MapRangeProvider).outMax;
}

String _$ordersPanelBidsHash() => r'c18640c79c6516de2ebd5bb474e779f93cc279b4';

/// See also [ordersPanelBids].
@ProviderFor(ordersPanelBids)
final ordersPanelBidsProvider =
    AutoDisposeProvider<Iterable<InternalUiOrder>>.internal(
      ordersPanelBids,
      name: r'ordersPanelBidsProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$ordersPanelBidsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrdersPanelBidsRef = AutoDisposeProviderRef<Iterable<InternalUiOrder>>;
String _$ordersPanelAsksHash() => r'6315ee5366426e4cbf5112ec258674ea38506b14';

/// See also [ordersPanelAsks].
@ProviderFor(ordersPanelAsks)
final ordersPanelAsksProvider =
    AutoDisposeProvider<Iterable<InternalUiOrder>>.internal(
      ordersPanelAsks,
      name: r'ordersPanelAsksProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$ordersPanelAsksHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef OrdersPanelAsksRef = AutoDisposeProviderRef<Iterable<InternalUiOrder>>;
String _$requestOrderSortFlagNotifierHash() =>
    r'07fcb7ac5f9c32e2099111be7839e4119795c689';

/// See also [RequestOrderSortFlagNotifier].
@ProviderFor(RequestOrderSortFlagNotifier)
final requestOrderSortFlagNotifierProvider = AutoDisposeNotifierProvider<
  RequestOrderSortFlagNotifier,
  RequestOrderSortFlag
>.internal(
  RequestOrderSortFlagNotifier.new,
  name: r'requestOrderSortFlagNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$requestOrderSortFlagNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RequestOrderSortFlagNotifier =
    AutoDisposeNotifier<RequestOrderSortFlag>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
