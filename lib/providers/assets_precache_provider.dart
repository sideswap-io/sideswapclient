import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/licenses_provider.dart';

part 'assets_precache_provider.g.dart';

@riverpod
Future<AssetManifest> assetManifest(Ref ref) {
  final bundle = ref.read(assetBundleProvider);
  return AssetManifest.loadFromAssetBundle(bundle);
}

@riverpod
Cache svgCache(Ref ref) => svg.cache;

@riverpod
Future<bool> assetsPrecacheFuture(Ref ref) async {
  logger.d('Precaching assets...');

  final assetManifest = await ref.read(assetManifestProvider.future);
  if (!ref.mounted) return true;

  final cache = ref.read(svgCacheProvider);
  final assets = assetManifest.listAssets().where(
    (e) => e.contains('assets/') && e.contains('.svg'),
  );

  for (var svgImage in assets) {
    if (!ref.mounted) return true;
    logger.d('Precaching: $svgImage');
    try {
      final loader = SvgAssetLoader(svgImage);
      await cache.putIfAbsent(
        loader.cacheKey(null),
        () => loader.loadBytes(null),
      );
    } catch (e) {
      logger.e('Error precaching $svgImage: $e');
    }
  }

  return true;
}
