// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$endpointServerHash() => r'197af97bc56a4d41ff5ef8386f43d4a22afd2564';

/// See also [endpointServer].
@ProviderFor(endpointServer)
final endpointServerProvider =
    AutoDisposeProvider<EndpointServerProvider>.internal(
  endpointServer,
  name: r'endpointServerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$endpointServerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef EndpointServerRef = AutoDisposeProviderRef<EndpointServerProvider>;
String _$eiCreateTransactionNotifierHash() =>
    r'a13c5b766bad18fe26479166577e3ae46d047e07';

/// See also [EiCreateTransactionNotifier].
@ProviderFor(EiCreateTransactionNotifier)
final eiCreateTransactionNotifierProvider = AutoDisposeNotifierProvider<
    EiCreateTransactionNotifier, EICreateTransaction>.internal(
  EiCreateTransactionNotifier.new,
  name: r'eiCreateTransactionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eiCreateTransactionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EiCreateTransactionNotifier
    = AutoDisposeNotifier<EICreateTransaction>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
