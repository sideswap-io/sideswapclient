// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$csvRepositoryHash() => r'972bfb7cf8fa7e0cd6c52eaa32bb42746f925fd0';

/// See also [csvRepository].
@ProviderFor(csvRepository)
final csvRepositoryProvider = AutoDisposeProvider<CsvRepository>.internal(
  csvRepository,
  name: r'csvRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$csvRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CsvRepositoryRef = AutoDisposeProviderRef<CsvRepository>;
String _$csvNotifierHash() => r'3bbe56ecefa0b4254737ce10426c28eea7973f99';

/// See also [CsvNotifier].
@ProviderFor(CsvNotifier)
final csvNotifierProvider =
    AutoDisposeAsyncNotifierProvider<CsvNotifier, CvsState>.internal(
      CsvNotifier.new,
      name: r'csvNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$csvNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CsvNotifier = AutoDisposeAsyncNotifier<CvsState>;
String _$exportCsvStateNotifierHash() =>
    r'bd8d48b545b617b456a470d6e69a7d975765dc9c';

/// See also [ExportCsvStateNotifier].
@ProviderFor(ExportCsvStateNotifier)
final exportCsvStateNotifierProvider =
    AutoDisposeNotifierProvider<
      ExportCsvStateNotifier,
      ExportCsvState
    >.internal(
      ExportCsvStateNotifier.new,
      name: r'exportCsvStateNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exportCsvStateNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExportCsvStateNotifier = AutoDisposeNotifier<ExportCsvState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
