// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'limit_review_order_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MarketLimitTrackIndexPriceStateNotifier)
final marketLimitTrackIndexPriceStateProvider =
    MarketLimitTrackIndexPriceStateNotifierProvider._();

final class MarketLimitTrackIndexPriceStateNotifierProvider
    extends $NotifierProvider<MarketLimitTrackIndexPriceStateNotifier, bool> {
  MarketLimitTrackIndexPriceStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitTrackIndexPriceStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketLimitTrackIndexPriceStateNotifierHash();

  @$internal
  @override
  MarketLimitTrackIndexPriceStateNotifier create() =>
      MarketLimitTrackIndexPriceStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$marketLimitTrackIndexPriceStateNotifierHash() =>
    r'7fba1f0bf9fc12c1bf141637f5391df1a283accb';

abstract class _$MarketLimitTrackIndexPriceStateNotifier
    extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(MarketLimitTrackIndexPriceValueNotifier)
final marketLimitTrackIndexPriceValueProvider =
    MarketLimitTrackIndexPriceValueNotifierProvider._();

final class MarketLimitTrackIndexPriceValueNotifierProvider
    extends
        $NotifierProvider<
          MarketLimitTrackIndexPriceValueNotifier,
          TrackingValue
        > {
  MarketLimitTrackIndexPriceValueNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'marketLimitTrackIndexPriceValueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$marketLimitTrackIndexPriceValueNotifierHash();

  @$internal
  @override
  MarketLimitTrackIndexPriceValueNotifier create() =>
      MarketLimitTrackIndexPriceValueNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackingValue value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackingValue>(value),
    );
  }
}

String _$marketLimitTrackIndexPriceValueNotifierHash() =>
    r'33555dbaf5e16e67c754a846ded7b599e403b333';

abstract class _$MarketLimitTrackIndexPriceValueNotifier
    extends $Notifier<TrackingValue> {
  TrackingValue build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TrackingValue, TrackingValue>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrackingValue, TrackingValue>,
              TrackingValue,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(limitReviewOrderPrice)
final limitReviewOrderPriceProvider = LimitReviewOrderPriceProvider._();

final class LimitReviewOrderPriceProvider
    extends $FunctionalProvider<OrderAmount, OrderAmount, OrderAmount>
    with $Provider<OrderAmount> {
  LimitReviewOrderPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitReviewOrderPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitReviewOrderPriceHash();

  @$internal
  @override
  $ProviderElement<OrderAmount> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OrderAmount create(Ref ref) {
    return limitReviewOrderPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrderAmount value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrderAmount>(value),
    );
  }
}

String _$limitReviewOrderPriceHash() =>
    r'a45bfb9a7afe33950567e1d8788a8fadec0e0906';

@ProviderFor(limitReviewOrderAggregateVolume)
final limitReviewOrderAggregateVolumeProvider =
    LimitReviewOrderAggregateVolumeProvider._();

final class LimitReviewOrderAggregateVolumeProvider
    extends
        $FunctionalProvider<
          MarketOrderAggregateVolumeProvider,
          MarketOrderAggregateVolumeProvider,
          MarketOrderAggregateVolumeProvider
        >
    with $Provider<MarketOrderAggregateVolumeProvider> {
  LimitReviewOrderAggregateVolumeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitReviewOrderAggregateVolumeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$limitReviewOrderAggregateVolumeHash();

  @$internal
  @override
  $ProviderElement<MarketOrderAggregateVolumeProvider> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MarketOrderAggregateVolumeProvider create(Ref ref) {
    return limitReviewOrderAggregateVolume(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MarketOrderAggregateVolumeProvider value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MarketOrderAggregateVolumeProvider>(
        value,
      ),
    );
  }
}

String _$limitReviewOrderAggregateVolumeHash() =>
    r'9adfa8003c8865bdf6189c8a3f9b0561daa01dce';

@ProviderFor(limitReviewOrderAggregateVolumeTooHigh)
final limitReviewOrderAggregateVolumeTooHighProvider =
    LimitReviewOrderAggregateVolumeTooHighProvider._();

final class LimitReviewOrderAggregateVolumeTooHighProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  LimitReviewOrderAggregateVolumeTooHighProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitReviewOrderAggregateVolumeTooHighProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$limitReviewOrderAggregateVolumeTooHighHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return limitReviewOrderAggregateVolumeTooHigh(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$limitReviewOrderAggregateVolumeTooHighHash() =>
    r'b6bc9c9ec47578239ea07c45b1f09921e40e015f';

@ProviderFor(limitReviewOrderInsufficientPrice)
final limitReviewOrderInsufficientPriceProvider =
    LimitReviewOrderInsufficientPriceProvider._();

final class LimitReviewOrderInsufficientPriceProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  LimitReviewOrderInsufficientPriceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitReviewOrderInsufficientPriceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$limitReviewOrderInsufficientPriceHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return limitReviewOrderInsufficientPrice(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$limitReviewOrderInsufficientPriceHash() =>
    r'2c65a277c88eb2149b24e51d3053e8a96effb963';

@ProviderFor(limitReviewOrderSubmitButtonEnabled)
final limitReviewOrderSubmitButtonEnabledProvider =
    LimitReviewOrderSubmitButtonEnabledProvider._();

final class LimitReviewOrderSubmitButtonEnabledProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  LimitReviewOrderSubmitButtonEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'limitReviewOrderSubmitButtonEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$limitReviewOrderSubmitButtonEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return limitReviewOrderSubmitButtonEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$limitReviewOrderSubmitButtonEnabledHash() =>
    r'd9b42ba648052af46b27f7b86153bfa2b139f4e1';

@ProviderFor(trackingRangeConverter)
final trackingRangeConverterProvider = TrackingRangeConverterProvider._();

final class TrackingRangeConverterProvider
    extends
        $FunctionalProvider<
          TrackingRangeConverter,
          TrackingRangeConverter,
          TrackingRangeConverter
        >
    with $Provider<TrackingRangeConverter> {
  TrackingRangeConverterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackingRangeConverterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackingRangeConverterHash();

  @$internal
  @override
  $ProviderElement<TrackingRangeConverter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TrackingRangeConverter create(Ref ref) {
    return trackingRangeConverter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrackingRangeConverter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrackingRangeConverter>(value),
    );
  }
}

String _$trackingRangeConverterHash() =>
    r'b79f11fae9bb77a75cd7c0e144088df080c07f35';
