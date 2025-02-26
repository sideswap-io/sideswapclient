// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_address_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentReceiveAddressHash() =>
    r'6db1d83036f23bfd25a5012f4283bbd09f3459d0';

/// See also [CurrentReceiveAddress].
@ProviderFor(CurrentReceiveAddress)
final currentReceiveAddressProvider =
    NotifierProvider<CurrentReceiveAddress, ReceiveAddress>.internal(
      CurrentReceiveAddress.new,
      name: r'currentReceiveAddressProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$currentReceiveAddressHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurrentReceiveAddress = Notifier<ReceiveAddress>;
String _$regularAccountAddressesHash() =>
    r'9d8fc691c03a5316337375f3a9bcc967b26bb84b';

/// See also [RegularAccountAddresses].
@ProviderFor(RegularAccountAddresses)
final regularAccountAddressesProvider =
    NotifierProvider<RegularAccountAddresses, List<ReceiveAddress>>.internal(
      RegularAccountAddresses.new,
      name: r'regularAccountAddressesProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$regularAccountAddressesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RegularAccountAddresses = Notifier<List<ReceiveAddress>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
