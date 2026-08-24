// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_panel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RequestOrderSortFlagNotifier)
final requestOrderSortFlagProvider = RequestOrderSortFlagNotifierProvider._();

final class RequestOrderSortFlagNotifierProvider
    extends
        $NotifierProvider<RequestOrderSortFlagNotifier, RequestOrderSortFlag> {
  RequestOrderSortFlagNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestOrderSortFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestOrderSortFlagNotifierHash();

  @$internal
  @override
  RequestOrderSortFlagNotifier create() => RequestOrderSortFlagNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RequestOrderSortFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RequestOrderSortFlag>(value),
    );
  }
}

String _$requestOrderSortFlagNotifierHash() =>
    r'07fcb7ac5f9c32e2099111be7839e4119795c689';

abstract class _$RequestOrderSortFlagNotifier
    extends $Notifier<RequestOrderSortFlag> {
  RequestOrderSortFlag build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RequestOrderSortFlag, RequestOrderSortFlag>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RequestOrderSortFlag, RequestOrderSortFlag>,
              RequestOrderSortFlag,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(internalUiOrders)
final internalUiOrdersProvider = InternalUiOrdersProvider._();

final class InternalUiOrdersProvider
    extends
        $FunctionalProvider<
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>
        >
    with $Provider<Iterable<InternalUiOrder>> {
  InternalUiOrdersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'internalUiOrdersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$internalUiOrdersHash();

  @$internal
  @override
  $ProviderElement<Iterable<InternalUiOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Iterable<InternalUiOrder> create(Ref ref) {
    return internalUiOrders(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<InternalUiOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<InternalUiOrder>>(value),
    );
  }
}

String _$internalUiOrdersHash() => r'5dd8ee793c82f23338969303266c90a90437de92';

@ProviderFor(maxOrderAmount)
final maxOrderAmountProvider = MaxOrderAmountProvider._();

final class MaxOrderAmountProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  MaxOrderAmountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'maxOrderAmountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$maxOrderAmountHash();

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    return maxOrderAmount(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }
}

String _$maxOrderAmountHash() => r'8770516371abd8eb6549673fffc2342454aac366';

@ProviderFor(ordersBids)
final ordersBidsProvider = OrdersBidsProvider._();

final class OrdersBidsProvider
    extends
        $FunctionalProvider<
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>
        >
    with $Provider<Iterable<InternalUiOrder>> {
  OrdersBidsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersBidsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersBidsHash();

  @$internal
  @override
  $ProviderElement<Iterable<InternalUiOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Iterable<InternalUiOrder> create(Ref ref) {
    return ordersBids(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<InternalUiOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<InternalUiOrder>>(value),
    );
  }
}

String _$ordersBidsHash() => r'a36debc09ddfbbf6d4b79f863a098bafe531f8ed';

@ProviderFor(ordersAsks)
final ordersAsksProvider = OrdersAsksProvider._();

final class OrdersAsksProvider
    extends
        $FunctionalProvider<
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>
        >
    with $Provider<Iterable<InternalUiOrder>> {
  OrdersAsksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersAsksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersAsksHash();

  @$internal
  @override
  $ProviderElement<Iterable<InternalUiOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Iterable<InternalUiOrder> create(Ref ref) {
    return ordersAsks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<InternalUiOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<InternalUiOrder>>(value),
    );
  }
}

String _$ordersAsksHash() => r'a219b8095af5c092805bad910834c13d3af9184e';

@ProviderFor(mapRange)
final mapRangeProvider = MapRangeFamily._();

final class MapRangeProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  MapRangeProvider._({
    required MapRangeFamily super.from,
    required (double, double, double, double, double) super.argument,
  }) : super(
         retry: null,
         name: r'mapRangeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mapRangeHash();

  @override
  String toString() {
    return r'mapRangeProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    final argument = this.argument as (double, double, double, double, double);
    return mapRange(
      ref,
      argument.$1,
      argument.$2,
      argument.$3,
      argument.$4,
      argument.$5,
    );
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MapRangeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mapRangeHash() => r'b9b31cf27f8ce8e3492e8c1bced581c77f6fd535';

final class MapRangeFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Decimal,
          (double, double, double, double, double)
        > {
  MapRangeFamily._()
    : super(
        retry: null,
        name: r'mapRangeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MapRangeProvider call(
    double value,
    double inMin,
    double inMax,
    double outMin,
    double outMax,
  ) => MapRangeProvider._(
    argument: (value, inMin, inMax, outMin, outMax),
    from: this,
  );

  @override
  String toString() => r'mapRangeProvider';
}

@ProviderFor(ordersPanelBids)
final ordersPanelBidsProvider = OrdersPanelBidsProvider._();

final class OrdersPanelBidsProvider
    extends
        $FunctionalProvider<
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>
        >
    with $Provider<Iterable<InternalUiOrder>> {
  OrdersPanelBidsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersPanelBidsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersPanelBidsHash();

  @$internal
  @override
  $ProviderElement<Iterable<InternalUiOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Iterable<InternalUiOrder> create(Ref ref) {
    return ordersPanelBids(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<InternalUiOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<InternalUiOrder>>(value),
    );
  }
}

String _$ordersPanelBidsHash() => r'c18640c79c6516de2ebd5bb474e779f93cc279b4';

@ProviderFor(ordersPanelAsks)
final ordersPanelAsksProvider = OrdersPanelAsksProvider._();

final class OrdersPanelAsksProvider
    extends
        $FunctionalProvider<
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>,
          Iterable<InternalUiOrder>
        >
    with $Provider<Iterable<InternalUiOrder>> {
  OrdersPanelAsksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ordersPanelAsksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ordersPanelAsksHash();

  @$internal
  @override
  $ProviderElement<Iterable<InternalUiOrder>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Iterable<InternalUiOrder> create(Ref ref) {
    return ordersPanelAsks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Iterable<InternalUiOrder> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Iterable<InternalUiOrder>>(value),
    );
  }
}

String _$ordersPanelAsksHash() => r'6315ee5366426e4cbf5112ec258674ea38506b14';
