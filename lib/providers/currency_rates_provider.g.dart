// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_rates_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RequestConversionRates)
final requestConversionRatesProvider = RequestConversionRatesProvider._();

final class RequestConversionRatesProvider
    extends $NotifierProvider<RequestConversionRates, void> {
  RequestConversionRatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestConversionRatesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestConversionRatesHash();

  @$internal
  @override
  RequestConversionRates create() => RequestConversionRates();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$requestConversionRatesHash() =>
    r'0fbf0c36dd2aabb24a681ff4da5ed63beb3bb799';

abstract class _$RequestConversionRates extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ConversionRatesNotifier)
final conversionRatesProvider = ConversionRatesNotifierProvider._();

final class ConversionRatesNotifierProvider
    extends $NotifierProvider<ConversionRatesNotifier, ConversionRates> {
  ConversionRatesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversionRatesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversionRatesNotifierHash();

  @$internal
  @override
  ConversionRatesNotifier create() => ConversionRatesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversionRates value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversionRates>(value),
    );
  }
}

String _$conversionRatesNotifierHash() =>
    r'd2d2975bcaebd2085767977c1b3a56b823b04f67';

abstract class _$ConversionRatesNotifier extends $Notifier<ConversionRates> {
  ConversionRates build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ConversionRates, ConversionRates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConversionRates, ConversionRates>,
              ConversionRates,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Default conversion rate helpers ============

@ProviderFor(DefaultConversionRateNotifier)
final defaultConversionRateProvider = DefaultConversionRateNotifierProvider._();

/// Default conversion rate helpers ============
final class DefaultConversionRateNotifierProvider
    extends $NotifierProvider<DefaultConversionRateNotifier, ConversionRate?> {
  /// Default conversion rate helpers ============
  DefaultConversionRateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultConversionRateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultConversionRateNotifierHash();

  @$internal
  @override
  DefaultConversionRateNotifier create() => DefaultConversionRateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversionRate? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversionRate?>(value),
    );
  }
}

String _$defaultConversionRateNotifierHash() =>
    r'afe76159f28ec17884c506718b6ed41342f736ca';

/// Default conversion rate helpers ============

abstract class _$DefaultConversionRateNotifier
    extends $Notifier<ConversionRate?> {
  ConversionRate? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ConversionRate?, ConversionRate?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ConversionRate?, ConversionRate?>,
              ConversionRate?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(defaultConversionRateMultiplier)
final defaultConversionRateMultiplierProvider =
    DefaultConversionRateMultiplierProvider._();

final class DefaultConversionRateMultiplierProvider
    extends $FunctionalProvider<Decimal, Decimal, Decimal>
    with $Provider<Decimal> {
  DefaultConversionRateMultiplierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultConversionRateMultiplierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$defaultConversionRateMultiplierHash();

  @$internal
  @override
  $ProviderElement<Decimal> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Decimal create(Ref ref) {
    return defaultConversionRateMultiplier(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Decimal value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Decimal>(value),
    );
  }
}

String _$defaultConversionRateMultiplierHash() =>
    r'afb9c595ce11e912472d78b10870ce614b4fe1d5';
