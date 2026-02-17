// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(countriesFuture)
const countriesFutureProvider = CountriesFutureProvider._();

final class CountriesFutureProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<CountryCode>>,
          List<CountryCode>,
          FutureOr<List<CountryCode>>
        >
    with
        $FutureModifier<List<CountryCode>>,
        $FutureProvider<List<CountryCode>> {
  const CountriesFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'countriesFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$countriesFutureHash();

  @$internal
  @override
  $FutureProviderElement<List<CountryCode>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<CountryCode>> create(Ref ref) {
    return countriesFuture(ref);
  }
}

String _$countriesFutureHash() => r'89d3f7207c5e6ddcfc81ce65e71af5dde97a9f0d';

@ProviderFor(DefaultSystemCountryAsyncNotifier)
const defaultSystemCountryAsyncProvider =
    DefaultSystemCountryAsyncNotifierProvider._();

final class DefaultSystemCountryAsyncNotifierProvider
    extends
        $AsyncNotifierProvider<DefaultSystemCountryAsyncNotifier, CountryCode> {
  const DefaultSystemCountryAsyncNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'defaultSystemCountryAsyncProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() =>
      _$defaultSystemCountryAsyncNotifierHash();

  @$internal
  @override
  DefaultSystemCountryAsyncNotifier create() =>
      DefaultSystemCountryAsyncNotifier();
}

String _$defaultSystemCountryAsyncNotifierHash() =>
    r'530e06e77bc6e13b38b4ac3fe0a53b36829a6b55';

abstract class _$DefaultSystemCountryAsyncNotifier
    extends $AsyncNotifier<CountryCode> {
  FutureOr<CountryCode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CountryCode>, CountryCode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CountryCode>, CountryCode>,
              AsyncValue<CountryCode>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
