import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

part 'assets_precache_provider.g.dart';

@riverpod
FutureOr<bool> assetsPrecacheFuture(AssetsPrecacheFutureRef ref) async {
  logger.d('Precaching assets...');

  final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final assets = assetManifest
      .listAssets()
      .where((element) => element.contains('assets/'))
      .where((element) => element.contains('.svg'));

  for (var svgImage in assets) {
    logger.d('Precaching: $svgImage');
    try {
      final loader = SvgAssetLoader(svgImage);
      await svg.cache
          .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
    } catch (e) {
      logger.e('Error precaching $svgImage: $e');
    }
  }

  return true;
}
