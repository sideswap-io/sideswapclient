// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csv_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(csvRepository)
const csvRepositoryProvider = CsvRepositoryProvider._();

final class CsvRepositoryProvider
    extends $FunctionalProvider<CsvRepository, CsvRepository, CsvRepository>
    with $Provider<CsvRepository> {
  const CsvRepositoryProvider._()
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

String _$csvRepositoryHash() => r'3e04a7398ddfe17704bb4bb4d42aa99fb05609b5';

@ProviderFor(CsvNotifier)
const csvProvider = CsvNotifierProvider._();

final class CsvNotifierProvider
    extends $AsyncNotifierProvider<CsvNotifier, CvsState> {
  const CsvNotifierProvider._()
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

String _$csvNotifierHash() => r'3bbe56ecefa0b4254737ce10426c28eea7973f99';

abstract class _$CsvNotifier extends $AsyncNotifier<CvsState> {
  FutureOr<CvsState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<CvsState>, CvsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CvsState>, CvsState>,
              AsyncValue<CvsState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ExportCsvStateNotifier)
const exportCsvStateProvider = ExportCsvStateNotifierProvider._();

final class ExportCsvStateNotifierProvider
    extends $NotifierProvider<ExportCsvStateNotifier, ExportCsvState> {
  const ExportCsvStateNotifierProvider._()
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
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExportCsvState, ExportCsvState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ExportCsvState, ExportCsvState>,
              ExportCsvState,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
