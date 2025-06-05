// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_address_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentReceiveAddressHash() =>
    r'd7ab7f67e48fa1a6e0f7bdf213e2231da6fbcc5a';

/// See also [CurrentReceiveAddress].
@ProviderFor(CurrentReceiveAddress)
final currentReceiveAddressProvider =
    NotifierProvider<CurrentReceiveAddress, ReceiveAddress>.internal(
      CurrentReceiveAddress.new,
      name: r'currentReceiveAddressProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$currentReceiveAddressHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentReceiveAddress = Notifier<ReceiveAddress>;
String _$regularAccountAddressesHash() =>
    r'63cf3a137312498d1d3d334d228a022a65160f22';

/// See also [RegularAccountAddresses].
@ProviderFor(RegularAccountAddresses)
final regularAccountAddressesProvider =
    NotifierProvider<RegularAccountAddresses, List<ReceiveAddress>>.internal(
      RegularAccountAddresses.new,
      name: r'regularAccountAddressesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$regularAccountAddressesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RegularAccountAddresses = Notifier<List<ReceiveAddress>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
