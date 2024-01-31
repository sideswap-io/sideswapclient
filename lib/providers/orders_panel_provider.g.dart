// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_panel_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$ordersPanelHash() => r'f641b7189e2f33d0a1f4043ba21aec0e525736dd';

/// See also [ordersPanel].
@ProviderFor(ordersPanel)
final ordersPanelProvider =
    AutoDisposeProvider<Iterable<RequestOrder>>.internal(
  ordersPanel,
  name: r'ordersPanelProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$ordersPanelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrdersPanelRef = AutoDisposeProviderRef<Iterable<RequestOrder>>;
String _$ordersPanelBidsHash() => r'272e8f60108a16744141ad99569408bcb54ef477';

/// See also [ordersPanelBids].
@ProviderFor(ordersPanelBids)
final ordersPanelBidsProvider =
    AutoDisposeProvider<List<RequestOrder>>.internal(
  ordersPanelBids,
  name: r'ordersPanelBidsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersPanelBidsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrdersPanelBidsRef = AutoDisposeProviderRef<List<RequestOrder>>;
String _$ordersPanelAsksHash() => r'dd36f764c00f1930562a7417c310d2f32e15d3b2';

/// See also [ordersPanelAsks].
@ProviderFor(ordersPanelAsks)
final ordersPanelAsksProvider =
    AutoDisposeProvider<List<RequestOrder>>.internal(
  ordersPanelAsks,
  name: r'ordersPanelAsksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersPanelAsksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrdersPanelAsksRef = AutoDisposeProviderRef<List<RequestOrder>>;
String _$ordersPanelFilterBadgeCounterHash() =>
    r'6a4a73aef093d383bb9bdbb1e3cccdf03e0be9b4';

/// See also [ordersPanelFilterBadgeCounter].
@ProviderFor(ordersPanelFilterBadgeCounter)
final ordersPanelFilterBadgeCounterProvider = AutoDisposeProvider<int>.internal(
  ordersPanelFilterBadgeCounter,
  name: r'ordersPanelFilterBadgeCounterProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersPanelFilterBadgeCounterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrdersPanelFilterBadgeCounterRef = AutoDisposeProviderRef<int>;
String _$requestOrderSortFlagNotifierHash() =>
    r'07fcb7ac5f9c32e2099111be7839e4119795c689';

/// See also [RequestOrderSortFlagNotifier].
@ProviderFor(RequestOrderSortFlagNotifier)
final requestOrderSortFlagNotifierProvider = AutoDisposeNotifierProvider<
    RequestOrderSortFlagNotifier, RequestOrderSortFlag>.internal(
  RequestOrderSortFlagNotifier.new,
  name: r'requestOrderSortFlagNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$requestOrderSortFlagNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$RequestOrderSortFlagNotifier
    = AutoDisposeNotifier<RequestOrderSortFlag>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
