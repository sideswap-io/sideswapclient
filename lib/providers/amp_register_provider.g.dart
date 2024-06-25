// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amp_register_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stokrSecuritiesHash() => r'0cce61ed6065095ac4a8597d7f02ed270f2dfcac';

/// See also [stokrSecurities].
@ProviderFor(stokrSecurities)
final stokrSecuritiesProvider =
    AutoDisposeProvider<List<SecuritiesItem>>.internal(
  stokrSecurities,
  name: r'stokrSecuritiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stokrSecuritiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef StokrSecuritiesRef = AutoDisposeProviderRef<List<SecuritiesItem>>;
String _$pegxSecuritiesHash() => r'2f06b5d4964a766ad8d6e92271e11ca8703ce8da';

/// See also [pegxSecurities].
@ProviderFor(pegxSecurities)
final pegxSecuritiesProvider =
    AutoDisposeProvider<List<SecuritiesItem>>.internal(
  pegxSecurities,
  name: r'pegxSecuritiesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pegxSecuritiesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PegxSecuritiesRef = AutoDisposeProviderRef<List<SecuritiesItem>>;
String _$checkAmpStatusHash() => r'4d123a68f1915c4fecdabed2aa69dc906dddf42f';

/// See also [checkAmpStatus].
@ProviderFor(checkAmpStatus)
final checkAmpStatusProvider =
    AutoDisposeProvider<CheckAmpStatusProvider>.internal(
  checkAmpStatus,
  name: r'checkAmpStatusProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$checkAmpStatusHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CheckAmpStatusRef = AutoDisposeProviderRef<CheckAmpStatusProvider>;
String _$stokrGaidNotifierHash() => r'8673920fa61f49de33d9cfeefdfd63d3d3602706';

/// See also [StokrGaidNotifier].
@ProviderFor(StokrGaidNotifier)
final stokrGaidNotifierProvider =
    NotifierProvider<StokrGaidNotifier, StokrGaidState>.internal(
  StokrGaidNotifier.new,
  name: r'stokrGaidNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stokrGaidNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StokrGaidNotifier = Notifier<StokrGaidState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
