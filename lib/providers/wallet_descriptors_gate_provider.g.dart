// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_descriptors_gate_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(walletDescriptorsGate)
final walletDescriptorsGateProvider = WalletDescriptorsGateProvider._();

final class WalletDescriptorsGateProvider
    extends
        $FunctionalProvider<
          WalletDescriptorsGate,
          WalletDescriptorsGate,
          WalletDescriptorsGate
        >
    with $Provider<WalletDescriptorsGate> {
  WalletDescriptorsGateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletDescriptorsGateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletDescriptorsGateHash();

  @$internal
  @override
  $ProviderElement<WalletDescriptorsGate> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  WalletDescriptorsGate create(Ref ref) {
    return walletDescriptorsGate(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletDescriptorsGate value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletDescriptorsGate>(value),
    );
  }
}

String _$walletDescriptorsGateHash() =>
    r'eed7ee5b2938c779120609728bfcc48904d5d3d7';
