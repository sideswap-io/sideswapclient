// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'endpoint_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(endpointServer)
final endpointServerProvider = EndpointServerProvider._();

final class EndpointServerProvider
    extends
        $FunctionalProvider<
          EndpointServerImpl,
          EndpointServerImpl,
          EndpointServerImpl
        >
    with $Provider<EndpointServerImpl> {
  EndpointServerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'endpointServerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$endpointServerHash();

  @$internal
  @override
  $ProviderElement<EndpointServerImpl> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  EndpointServerImpl create(Ref ref) {
    return endpointServer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EndpointServerImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EndpointServerImpl>(value),
    );
  }
}

String _$endpointServerHash() => r'95431c03fd364c95b735eb86a71031ff2578a3e8';

@ProviderFor(EiCreateTransactionNotifier)
final eiCreateTransactionProvider = EiCreateTransactionNotifierProvider._();

final class EiCreateTransactionNotifierProvider
    extends
        $NotifierProvider<EiCreateTransactionNotifier, EICreateTransaction> {
  EiCreateTransactionNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eiCreateTransactionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eiCreateTransactionNotifierHash();

  @$internal
  @override
  EiCreateTransactionNotifier create() => EiCreateTransactionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EICreateTransaction value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EICreateTransaction>(value),
    );
  }
}

String _$eiCreateTransactionNotifierHash() =>
    r'b48125d27f82de20cb6ed0d0906bf04e55331ab8';

abstract class _$EiCreateTransactionNotifier
    extends $Notifier<EICreateTransaction> {
  EICreateTransaction build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<EICreateTransaction, EICreateTransaction>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<EICreateTransaction, EICreateTransaction>,
              EICreateTransaction,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
