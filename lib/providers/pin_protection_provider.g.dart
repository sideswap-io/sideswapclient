// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pin_protection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pinProtectionHelperHash() =>
    r'bbb5f4c6c3f6c61c23c78832c6673dad6461492f';

/// See also [pinProtectionHelper].
@ProviderFor(pinProtectionHelper)
final pinProtectionHelperProvider = Provider<PinProtectionHelper>.internal(
  pinProtectionHelper,
  name: r'pinProtectionHelperProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinProtectionHelperHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PinProtectionHelperRef = ProviderRef<PinProtectionHelper>;
String _$pinProtectionStateNotifierHash() =>
    r'42824a0ae9414439d969186c6a26d38d1fdcfc72';

/// See also [PinProtectionStateNotifier].
@ProviderFor(PinProtectionStateNotifier)
final pinProtectionStateNotifierProvider = AutoDisposeNotifierProvider<
    PinProtectionStateNotifier, PinProtectionState>.internal(
  PinProtectionStateNotifier.new,
  name: r'pinProtectionStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinProtectionStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PinProtectionStateNotifier = AutoDisposeNotifier<PinProtectionState>;
String _$pinCodeProtectionNotifierHash() =>
    r'31bb70c237b20e83e17f5824c55be1ebdd7f1d07';

/// See also [PinCodeProtectionNotifier].
@ProviderFor(PinCodeProtectionNotifier)
final pinCodeProtectionNotifierProvider =
    AutoDisposeNotifierProvider<PinCodeProtectionNotifier, String>.internal(
  PinCodeProtectionNotifier.new,
  name: r'pinCodeProtectionNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinCodeProtectionNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PinCodeProtectionNotifier = AutoDisposeNotifier<String>;
String _$pinDecryptedDataNotifierHash() =>
    r'daf39daeb56d9da66cdee904134fa0712346c9e7';

/// See also [PinDecryptedDataNotifier].
@ProviderFor(PinDecryptedDataNotifier)
final pinDecryptedDataNotifierProvider =
    NotifierProvider<PinDecryptedDataNotifier, PinDecryptedData>.internal(
  PinDecryptedDataNotifier.new,
  name: r'pinDecryptedDataNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pinDecryptedDataNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PinDecryptedDataNotifier = Notifier<PinDecryptedData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
