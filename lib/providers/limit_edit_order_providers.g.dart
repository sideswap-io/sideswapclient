// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit_edit_order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(limitEditOrderPrice)
final limitEditOrderPriceProvider = LimitEditOrderPriceProvider._();

final class LimitEditOrderPriceProvider
    extends $FunctionalProvider<OrderAmount, OrderAmount, OrderAmount>
    with $Provider<OrderAmount> {
  LimitEditOrderPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitEditOrderPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitEditOrderPriceHash();

  @$internal
  @override
  $ProviderElement<OrderAmount> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderAmount create(Ref ref) {
    return limitEditOrderPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderAmount value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderAmount>(value),
    );
  }
}

String _$limitEditOrderPriceHash() =>
    r'668dc285cf6d33efcbbfaee3278b628f4d816a07';
