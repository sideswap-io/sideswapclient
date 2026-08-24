// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assets_precache_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assetManifest)
final assetManifestProvider = AssetManifestProvider._();

final class AssetManifestProvider
    extends
        $FunctionalProvider<
          AsyncValue<AssetManifest>,
          AssetManifest,
          FutureOr<AssetManifest>
        >
    with $FutureModifier<AssetManifest>, $FutureProvider<AssetManifest> {
  AssetManifestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetManifestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetManifestHash();

  @$internal
  @override
  $FutureProviderElement<AssetManifest> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AssetManifest> create(Ref ref) {
    return assetManifest(ref);
  }
}

String _$assetManifestHash() => r'1e516ef481982acd9bd948b9018daa7d535ba8ab';

@ProviderFor(svgCache)
final svgCacheProvider = SvgCacheProvider._();

final class SvgCacheProvider extends $FunctionalProvider<Cache, Cache, Cache>
    with $Provider<Cache> {
  SvgCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'svgCacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$svgCacheHash();

  @$internal
  @override
  $ProviderElement<Cache> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Cache create(Ref ref) {
    return svgCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Cache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Cache>(value),
    );
  }
}

String _$svgCacheHash() => r'3707baab7f561ed902d0820ae880bb2f37ce93e9';

@ProviderFor(assetsPrecacheFuture)
final assetsPrecacheFutureProvider = AssetsPrecacheFutureProvider._();

final class AssetsPrecacheFutureProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  AssetsPrecacheFutureProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetsPrecacheFutureProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetsPrecacheFutureHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return assetsPrecacheFuture(ref);
  }
}

String _$assetsPrecacheFutureHash() =>
    r'470d0518381baa8e294ee749a5c6358688a52534';
