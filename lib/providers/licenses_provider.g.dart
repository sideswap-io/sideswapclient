// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'licenses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(licensesLoaderFuture)
const licensesLoaderFutureProvider = LicensesLoaderFutureProvider._();

final class LicensesLoaderFutureProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const LicensesLoaderFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'licensesLoaderFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$licensesLoaderFutureHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return licensesLoaderFuture(ref);
  }
}

String _$licensesLoaderFutureHash() =>
    r'649d47303507c2009ee19395c4ec1550612b0373';

@ProviderFor(licensesEntries)
const licensesEntriesProvider = LicensesEntriesProvider._();

final class LicensesEntriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LicensesData>>,
          List<LicensesData>,
          FutureOr<List<LicensesData>>
        >
    with
        $FutureModifier<List<LicensesData>>,
        $FutureProvider<List<LicensesData>> {
  const LicensesEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'licensesEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$licensesEntriesHash();

  @$internal
  @override
  $FutureProviderElement<List<LicensesData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LicensesData>> create(Ref ref) {
    return licensesEntries(ref);
  }
}

String _$licensesEntriesHash() => r'24d3d37ae71ee70a55415d1e390797d897374a94';
