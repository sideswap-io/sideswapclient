// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$countriesFutureHash() => r'f2338f81a30cc8a4f44ff965ec8761f876479569';

/// See also [countriesFuture].
@ProviderFor(countriesFuture)
final countriesFutureProvider =
    AutoDisposeFutureProvider<List<CountryCode>>.internal(
  countriesFuture,
  name: r'countriesFutureProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$countriesFutureHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CountriesFutureRef = AutoDisposeFutureProviderRef<List<CountryCode>>;
String _$defaultSystemCountryAsyncNotifierHash() =>
    r'530e06e77bc6e13b38b4ac3fe0a53b36829a6b55';

/// See also [DefaultSystemCountryAsyncNotifier].
@ProviderFor(DefaultSystemCountryAsyncNotifier)
final defaultSystemCountryAsyncNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DefaultSystemCountryAsyncNotifier,
        CountryCode>.internal(
  DefaultSystemCountryAsyncNotifier.new,
  name: r'defaultSystemCountryAsyncNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$defaultSystemCountryAsyncNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DefaultSystemCountryAsyncNotifier
    = AutoDisposeAsyncNotifier<CountryCode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
