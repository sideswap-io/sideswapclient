// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(csvRepository)
final csvRepositoryProvider = CsvRepositoryProvider._();

final class CsvRepositoryProvider
    extends $FunctionalProvider<CsvRepository, CsvRepository, CsvRepository>
    with $Provider<CsvRepository> {
  CsvRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'csvRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$csvRepositoryHash();

  @$internal
  @override
  $ProviderElement<CsvRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CsvRepository create(Ref ref) {
    return csvRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CsvRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CsvRepository>(value),
    );
  }
}

String _$csvRepositoryHash() => r'29df674b5d24760e6868b51cfe1aac6ad6357011';

@ProviderFor(CsvNotifier)
final csvProvider = CsvNotifierProvider._();

final class CsvNotifierProvider
    extends $AsyncNotifierProvider<CsvNotifier, CvsState> {
  CsvNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'csvProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$csvNotifierHash();

  @$internal
  @override
  CsvNotifier create() => CsvNotifier();
}

String _$csvNotifierHash() => r'5c598dbad13eae6b231970c24c1272d81169de1f';

abstract class _$CsvNotifier extends $AsyncNotifier<CvsState> {
  FutureOr<CvsState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CvsState>, CvsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CvsState>, CvsState>,
              AsyncValue<CvsState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(ExportCsvStateNotifier)
final exportCsvStateProvider = ExportCsvStateNotifierProvider._();

final class ExportCsvStateNotifierProvider
    extends $NotifierProvider<ExportCsvStateNotifier, ExportCsvState> {
  ExportCsvStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportCsvStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportCsvStateNotifierHash();

  @$internal
  @override
  ExportCsvStateNotifier create() => ExportCsvStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportCsvState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportCsvState>(value),
    );
  }
}

String _$exportCsvStateNotifierHash() =>
    r'4a2b88cc09ba5f3a3ee213393481fd2166a18241';

abstract class _$ExportCsvStateNotifier extends $Notifier<ExportCsvState> {
  ExportCsvState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ExportCsvState, ExportCsvState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportCsvState, ExportCsvState>,
              ExportCsvState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
