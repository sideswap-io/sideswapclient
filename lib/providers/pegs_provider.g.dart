// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pegs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$pegRepositoryHash() => r'16907ee8269d75ac0b7dee69da75aeadd7bc6b1e';

/// See also [pegRepository].
@ProviderFor(pegRepository)
final pegRepositoryProvider =
    AutoDisposeProvider<AbstractPegRepository>.internal(
      pegRepository,
      name: r'pegRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pegRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PegRepositoryRef = AutoDisposeProviderRef<AbstractPegRepository>;
String _$allPegsByIdHash() => r'7b18515605c1569d0529896ce29d896b64e46194';

/// See also [allPegsById].
@ProviderFor(allPegsById)
final allPegsByIdProvider = Provider<Map<String, TransItem>>.internal(
  allPegsById,
  name: r'allPegsByIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$allPegsByIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AllPegsByIdRef = ProviderRef<Map<String, TransItem>>;
String _$allPegsNotifierHash() => r'eeba1a71e3b28acc27a2232e2b3613be4e59a82c';

/// See also [AllPegsNotifier].
@ProviderFor(AllPegsNotifier)
final allPegsNotifierProvider =
    NotifierProvider<AllPegsNotifier, Map<String, List<TransItem>>>.internal(
      AllPegsNotifier.new,
      name: r'allPegsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$allPegsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AllPegsNotifier = Notifier<Map<String, List<TransItem>>>;
String _$pegSubscribedValueNotifierHash() =>
    r'db4cf671b744a208dd745009001413272804fe2d';

/// See also [PegSubscribedValueNotifier].
@ProviderFor(PegSubscribedValueNotifier)
final pegSubscribedValueNotifierProvider =
    NotifierProvider<PegSubscribedValueNotifier, PegSubscribedValues>.internal(
      PegSubscribedValueNotifier.new,
      name: r'pegSubscribedValueNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pegSubscribedValueNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PegSubscribedValueNotifier = Notifier<PegSubscribedValues>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
