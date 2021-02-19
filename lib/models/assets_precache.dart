import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/utils/custom_logger.dart';

final assetsPrecacheChangeNotifier =
    ChangeNotifierProvider<AssetsPrecacheChangeNotifier>((ref) {
  return AssetsPrecacheChangeNotifier(ref.read);
});

class AssetsPrecacheChangeNotifier extends ChangeNotifier {
  final Reader read;

  AssetsPrecacheChangeNotifier(this.read);

  Future<void> precache() async {
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

    notifyListeners();
  }
}
