import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'asset_image_providers.g.dart';

@Riverpod(keepAlive: true)
AbstractAssetImageRepository assetImageRepository(Ref ref) {
  final assets = ref.watch(assetsStateProvider);
  final builtinAssets = ref.watch(builtinAssetsProvider);
  final allAssets = <String, Asset>{};
  allAssets.addAll(assets);
  allAssets.addAll(builtinAssets);

  return AssetImageRepository(assets: assets);
}

abstract class AbstractAssetImageRepository {
  String generateImageHash(String label);
  Uint8List getIconData(String? assetId);
  Widget getMemoryImage(
    String? assetId, {
    required double width,
    required double height,
    FilterQuality filterQuality = FilterQuality.high,
  });
  Widget? getCustomImageOrNull(
    String? assetId, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  });
  Widget getCustomImageFromAsset(
    String assetSvg, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  });
  Widget getCustomImage(
    String? assetId, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  });
  Widget getBigImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  });
  Widget getSmallImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  });
  Widget getVerySmallImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  });
}

class AssetImageRepository implements AbstractAssetImageRepository {
  Map<String, Asset> assets;
  AssetImageRepository({required this.assets});

  @override
  String generateImageHash(String label) {
    final hash = label.hashCode
        .toUnsigned(20)
        .toRadixString(16)
        .padLeft(5, '0');

    return hash;
  }

  @override
  Uint8List getIconData(String? assetId) {
    if (assetId == null) {
      return Uint8List(0);
    }

    if (!assets.keys.contains(assetId)) {
      return Uint8List(0);
    }

    final iconData = assets[assetId]?.icon;
    if (iconData == null) {
      return Uint8List(0);
    }

    return base64Decode(iconData);
  }

  // This function cause flickering!
  @override
  Widget getMemoryImage(
    String? assetId, {
    required double width,
    required double height,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetId == null || assetId.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return FittedBox(child: Icon(Icons.help, size: width));
    }

    final data = getIconData(assetId);

    if (data.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return FittedBox(child: Icon(Icons.help, size: width));
    }

    return Image.memory(
      data,
      width: width,
      height: height,
      filterQuality: filterQuality,
      isAntiAlias: true,
    );
  }

  @override
  Widget? getCustomImageOrNull(
    String? assetId, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetId == null || assetId.isEmpty) {
      logger.w('Asset icon data is empty!');
      return null;
    }

    final assetIcon = assets[assetId]?.icon;
    if (assetIcon == null) {
      return null;
    }

    return CachedMemoryImage(
      uniqueKey: generateImageHash(assetId),
      base64: assetIcon,
      errorWidget: FittedBox(child: Icon(Icons.help, size: width)),
      width: width,
      height: height,
      filterQuality: filterQuality,
      isAntiAlias: true,
    );
  }

  @override
  Widget getCustomImageFromAsset(
    String assetSvg, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetSvg.isEmpty) {
      logger.w('Asset is empty! Using default icon');
      return FittedBox(child: Icon(Icons.help, size: width));
    }

    return SideswapCachedMemoryImage(
      uniqueKey: generateImageHash(assetSvg),
      assetSvg: assetSvg,
      width: width,
      height: height,
    );
  }

  @override
  Widget getCustomImage(
    String? assetId, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetId == null || assetId.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return FittedBox(child: Icon(Icons.help_outline, size: width));
    }

    final assetIcon = assets[assetId]?.icon;

    if (assetIcon == null) {
      return FittedBox(child: Icon(Icons.help, size: width));
    }

    return SideswapCachedMemoryImage(
      uniqueKey: generateImageHash(assetId),
      base64: assetIcon,
      width: width,
      height: height,
    );
  }

  @override
  Widget getBigImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return getCustomImage(
      assetId,
      width: 75,
      height: 75,
      filterQuality: filterQuality,
    );
  }

  @override
  Widget getSmallImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return getCustomImage(
      assetId,
      width: 32,
      height: 32,
      filterQuality: filterQuality,
    );
  }

  @override
  Widget getVerySmallImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return getCustomImage(
      assetId,
      width: 20,
      height: 20,
      filterQuality: filterQuality,
    );
  }
}
