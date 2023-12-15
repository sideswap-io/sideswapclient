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
    r'b48125d27f82de20cb6ed0d0906bf04e55331ab8';

/// See also [EiCreateTransactionNotifier].
@ProviderFor(EiCreateTransactionNotifier)
final eiCreateTransactionNotifierProvider =
    NotifierProvider<EiCreateTransactionNotifier, EICreateTransaction>.internal(
  EiCreateTransactionNotifier.new,
  name: r'eiCreateTransactionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$eiCreateTransactionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EiCreateTransactionNotifier = Notifier<EICreateTransaction>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
