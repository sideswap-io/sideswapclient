// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'3a9f8412df34c1653d08100c9826aa2125b80f7f';

/// See also [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = Provider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = ProviderRef<SharedPreferences>;
String _$configurationHash() => r'ea9afd2f47999aa111a1b64b14d2bc55dffd83d1';

/// See also [Configuration].
@ProviderFor(Configuration)
final configurationProvider =
    AutoDisposeNotifierProvider<Configuration, SideswapSettings>.internal(
  Configuration.new,
  name: r'configurationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$configurationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Configuration = AutoDisposeNotifier<SideswapSettings>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
