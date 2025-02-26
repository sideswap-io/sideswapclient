// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_access_tab_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$networkAccessTabNotifierHash() =>
    r'b9ea4510f6a8489974ef9833324ac591464dbffd';

/// See also [NetworkAccessTabNotifier].
@ProviderFor(NetworkAccessTabNotifier)
final networkAccessTabNotifierProvider = AutoDisposeNotifierProvider<
  NetworkAccessTabNotifier,
  NetworkAccessTabState
>.internal(
  NetworkAccessTabNotifier.new,
  name: r'networkAccessTabNotifierProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$networkAccessTabNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NetworkAccessTabNotifier = AutoDisposeNotifier<NetworkAccessTabState>;
String _$useProxyNotifierHash() => r'5e53759b98a7bdf4efbf5fa95f29e981af896339';

/// See also [UseProxyNotifier].
@ProviderFor(UseProxyNotifier)
final useProxyNotifierProvider =
    AutoDisposeNotifierProvider<UseProxyNotifier, bool>.internal(
      UseProxyNotifier.new,
      name: r'useProxyNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$useProxyNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$UseProxyNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
