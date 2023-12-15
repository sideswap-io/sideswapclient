// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pegs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$allPegsByIdHash() => r'c4eef627c31a8bb4bf180175746b2f38f5ca7a12';

/// See also [allPegsById].
@ProviderFor(allPegsById)
final allPegsByIdProvider = Provider<Map<String, TransItem>>.internal(
  allPegsById,
  name: r'allPegsByIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$allPegsByIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AllPegsByIdRef = ProviderRef<Map<String, TransItem>>;
String _$allPegsNotifierHash() => r'10feab44adbb2324e0998ba62643062f79e64ca0';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
