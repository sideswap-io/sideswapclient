// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pegx_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pegxLoginStateNotifierHash() =>
    r'e3993e0430e20d1e3ebd9a7a433e09093e3edb6d';

/// See also [PegxLoginStateNotifier].
@ProviderFor(PegxLoginStateNotifier)
final pegxLoginStateNotifierProvider =
    AutoDisposeNotifierProvider<
      PegxLoginStateNotifier,
      PegxLoginState
    >.internal(
      PegxLoginStateNotifier.new,
      name: r'pegxLoginStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pegxLoginStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PegxLoginStateNotifier = AutoDisposeNotifier<PegxLoginState>;
String _$pegxGaidNotifierHash() => r'664deec870ded7b5d5a7079f293bc851fb85008a';

/// See also [PegxGaidNotifier].
@ProviderFor(PegxGaidNotifier)
final pegxGaidNotifierProvider =
    NotifierProvider<PegxGaidNotifier, PegxGaidState>.internal(
      PegxGaidNotifier.new,
      name: r'pegxGaidNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pegxGaidNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PegxGaidNotifier = Notifier<PegxGaidState>;
String _$pegxRegisterFailedNotifierHash() =>
    r'244183a1847376e84eca93daabd7bf0d89f3afd1';

/// See also [PegxRegisterFailedNotifier].
@ProviderFor(PegxRegisterFailedNotifier)
final pegxRegisterFailedNotifierProvider =
    NotifierProvider<PegxRegisterFailedNotifier, String>.internal(
      PegxRegisterFailedNotifier.new,
      name: r'pegxRegisterFailedNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pegxRegisterFailedNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PegxRegisterFailedNotifier = Notifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
