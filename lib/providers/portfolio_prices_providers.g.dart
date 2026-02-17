// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'portfolio_prices_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RequestPortfolioPrices)
const requestPortfolioPricesProvider = RequestPortfolioPricesProvider._();

final class RequestPortfolioPricesProvider
    extends $NotifierProvider<RequestPortfolioPrices, void> {
  const RequestPortfolioPricesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'requestPortfolioPricesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$requestPortfolioPricesHash();

  @$internal
  @override
  RequestPortfolioPrices create() => RequestPortfolioPrices();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$requestPortfolioPricesHash() =>
    r'70ea8ac302018dccd8ba1ed35940eb2c2f0c2cdd';

abstract class _$RequestPortfolioPrices extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(PortfolioPricesNotifier)
const portfolioPricesProvider = PortfolioPricesNotifierProvider._();

final class PortfolioPricesNotifierProvider
    extends $NotifierProvider<PortfolioPricesNotifier, Map<String, double>> {
  const PortfolioPricesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'portfolioPricesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$portfolioPricesNotifierHash();

  @$internal
  @override
  PortfolioPricesNotifier create() => PortfolioPricesNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double>>(value),
    );
  }
}

String _$portfolioPricesNotifierHash() =>
    r'4d75b711c74303bc3e478383a80ced04195037d0';

abstract class _$PortfolioPricesNotifier
    extends $Notifier<Map<String, double>> {
  Map<String, double> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, double>, Map<String, double>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, double>, Map<String, double>>,
              Map<String, double>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
