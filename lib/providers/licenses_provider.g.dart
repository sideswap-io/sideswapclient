// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'licenses_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assetBundle)
final assetBundleProvider = AssetBundleProvider._();

final class AssetBundleProvider
    extends $FunctionalProvider<AssetBundle, AssetBundle, AssetBundle>
    with $Provider<AssetBundle> {
  AssetBundleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetBundleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetBundleHash();

  @$internal
  @override
  $ProviderElement<AssetBundle> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AssetBundle create(Ref ref) {
    return assetBundle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AssetBundle value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AssetBundle>(value),
    );
  }
}

String _$assetBundleHash() => r'c8b3f8b421eb270854b13c74f343816c76c0617e';

@ProviderFor(licensesLoaderFuture)
final licensesLoaderFutureProvider = LicensesLoaderFutureProvider._();

final class LicensesLoaderFutureProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  LicensesLoaderFutureProvider._()
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
    r'a41e0c70c2dca390f9979fe239e82bce46d342d2';

@ProviderFor(licensesEntries)
final licensesEntriesProvider = LicensesEntriesProvider._();

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
  LicensesEntriesProvider._()
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

String _$licensesEntriesHash() => r'928d6965014ac9909c1d5cab1b6c6861d92658b6';
