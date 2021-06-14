import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';

final assetsPrecacheChangeNotifier = Provider<AssetsPrecacheProvider>((ref) {
  return AssetsPrecacheProvider(ref.read);
});

class AssetsPrecacheProvider {
  final Reader read;

  AssetsPrecacheProvider(this.read);

  Future<bool> precache() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final manifestMap = json.decode(manifestContent) as Map<String, dynamic>;

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('assets/'))
        .where((String key) => key.contains('.svg'))
        .toList();

    for (var image in imagePaths) {
      logger.d('Precaching: $image');
      try {
        await precachePicture(
            ExactAssetPicture(SvgPicture.svgStringDecoder, image), null);
      } catch (e) {
        logger.e('Error precaching $image: $e');
      }
    }

    return true;
  }
}
