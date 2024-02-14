// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warmup_app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$navigatorKeyHash() => r'617ac70ebc4c30db56eb48981eab39d3987bb6b3';

/// See also [navigatorKey].
@ProviderFor(navigatorKey)
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>.internal(
  navigatorKey,
  name: r'navigatorKeyProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$navigatorKeyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NavigatorKeyRef = ProviderRef<GlobalKey<NavigatorState>>;
String _$warmupAppHash() => r'd5b52c40a4d040a007708a01d41ca817fd1afb11';

/// See also [WarmupApp].
@ProviderFor(WarmupApp)
final warmupAppProvider =
    AsyncNotifierProvider<WarmupApp, WarmupAppState>.internal(
  WarmupApp.new,
  name: r'warmupAppProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$warmupAppHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WarmupApp = AsyncNotifier<WarmupAppState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
