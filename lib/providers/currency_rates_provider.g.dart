// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_rates_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$defaultConversionRateMultiplierHash() =>
    r'1dd0bcb252377233de4cc5af4efd0c90b52c9388';

/// See also [defaultConversionRateMultiplier].
@ProviderFor(defaultConversionRateMultiplier)
final defaultConversionRateMultiplierProvider =
    AutoDisposeProvider<Decimal>.internal(
      defaultConversionRateMultiplier,
      name: r'defaultConversionRateMultiplierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$defaultConversionRateMultiplierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefaultConversionRateMultiplierRef = AutoDisposeProviderRef<Decimal>;
String _$requestConversionRatesHash() =>
    r'0fbf0c36dd2aabb24a681ff4da5ed63beb3bb799';

/// See also [RequestConversionRates].
@ProviderFor(RequestConversionRates)
final requestConversionRatesProvider =
    NotifierProvider<RequestConversionRates, void>.internal(
      RequestConversionRates.new,
      name: r'requestConversionRatesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$requestConversionRatesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RequestConversionRates = Notifier<void>;
String _$conversionRatesNotifierHash() =>
    r'd2d2975bcaebd2085767977c1b3a56b823b04f67';

/// See also [ConversionRatesNotifier].
@ProviderFor(ConversionRatesNotifier)
final conversionRatesNotifierProvider =
    NotifierProvider<ConversionRatesNotifier, ConversionRates>.internal(
      ConversionRatesNotifier.new,
      name: r'conversionRatesNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$conversionRatesNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ConversionRatesNotifier = Notifier<ConversionRates>;
String _$defaultConversionRateNotifierHash() =>
    r'e4dbc3426994bd57dc3a1e8a52bbed5b032d7f09';

/// Default conversion rate helpers ============
///
/// Copied from [DefaultConversionRateNotifier].
@ProviderFor(DefaultConversionRateNotifier)
final defaultConversionRateNotifierProvider =
    AutoDisposeNotifierProvider<
      DefaultConversionRateNotifier,
      ConversionRate?
    >.internal(
      DefaultConversionRateNotifier.new,
      name: r'defaultConversionRateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$defaultConversionRateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$DefaultConversionRateNotifier = AutoDisposeNotifier<ConversionRate?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
