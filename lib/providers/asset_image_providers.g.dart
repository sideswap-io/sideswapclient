// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_image_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(assetImageRepository)
final assetImageRepositoryProvider = AssetImageRepositoryProvider._();

final class AssetImageRepositoryProvider
    extends
        $FunctionalProvider<
          AbstractAssetImageRepository,
          AbstractAssetImageRepository,
          AbstractAssetImageRepository
        >
    with $Provider<AbstractAssetImageRepository> {
  AssetImageRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'assetImageRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$assetImageRepositoryHash();

  @$internal
  @override
  $ProviderElement<AbstractAssetImageRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AbstractAssetImageRepository create(Ref ref) {
    return assetImageRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AbstractAssetImageRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AbstractAssetImageRepository>(value),
    );
  }
}

String _$assetImageRepositoryHash() =>
    r'555cb2e83b0bb608162da58e31215b79f5cd9c45';
