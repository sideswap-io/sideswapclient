import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';

final assetsPrecacheChangeNotifier = Provider<AssetsPrecacheProvider>((ref) {
  return AssetsPrecacheProvider(ref);
});

class AssetsPrecacheProvider {
  final Ref ref;

  AssetsPrecacheProvider(this.ref);

  Future<bool> precache() async {
    if (kDebugMode) {
      // flutter.svg >= 2.0.0 svg parsing has moved to isolates and it causing
      // extreme lag in debug mode during precaching multiple images
      // https://github.com/dnfield/flutter_svg/issues/837
      return true;
    }

    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('.svg'))
        .toList();

    for (var image in imagePaths) {
      logger.d('Precaching: $image');
      try {
        final loader = SvgAssetLoader(image);
        await svg.cache
            .putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
      } catch (e) {
        logger.e('Error precaching $image: $e');
      }
    }

    return true;
  }
}
