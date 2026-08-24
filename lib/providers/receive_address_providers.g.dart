// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_address_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CurrentReceiveAddress)
final currentReceiveAddressProvider = CurrentReceiveAddressProvider._();

final class CurrentReceiveAddressProvider
    extends $NotifierProvider<CurrentReceiveAddress, ReceiveAddress> {
  CurrentReceiveAddressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentReceiveAddressProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentReceiveAddressHash();

  @$internal
  @override
  CurrentReceiveAddress create() => CurrentReceiveAddress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiveAddress value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiveAddress>(value),
    );
  }
}

String _$currentReceiveAddressHash() =>
    r'd7ab7f67e48fa1a6e0f7bdf213e2231da6fbcc5a';

abstract class _$CurrentReceiveAddress extends $Notifier<ReceiveAddress> {
  ReceiveAddress build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReceiveAddress, ReceiveAddress>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReceiveAddress, ReceiveAddress>,
              ReceiveAddress,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(RegularAccountAddresses)
final regularAccountAddressesProvider = RegularAccountAddressesProvider._();

final class RegularAccountAddressesProvider
    extends $NotifierProvider<RegularAccountAddresses, List<ReceiveAddress>> {
  RegularAccountAddressesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regularAccountAddressesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regularAccountAddressesHash();

  @$internal
  @override
  RegularAccountAddresses create() => RegularAccountAddresses();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ReceiveAddress> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ReceiveAddress>>(value),
    );
  }
}

String _$regularAccountAddressesHash() =>
    r'63cf3a137312498d1d3d334d228a022a65160f22';

abstract class _$RegularAccountAddresses
    extends $Notifier<List<ReceiveAddress>> {
  List<ReceiveAddress> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ReceiveAddress>, List<ReceiveAddress>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ReceiveAddress>, List<ReceiveAddress>>,
              List<ReceiveAddress>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
