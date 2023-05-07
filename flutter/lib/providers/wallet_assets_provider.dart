import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/builtin_assets.dart';

import 'package:sideswap/protobuf/sideswap.pb.dart';

final bitcoinAssetIdProvider = AutoDisposeStateProvider<String>((ref) {
  ref.keepAlive();
  return '0000000000000000000000000000000000000000000000000000000000000000';
});

final liquidAssetIdProvider = AutoDisposeStateProvider<String>((ref) {
  ref.keepAlive();
  return '';
});

final tetherAssetIdProvider = AutoDisposeStateProvider<String>((ref) {
  ref.keepAlive();
  return '';
});

final eurxAssetIdProvider = AutoDisposeStateProvider<String>((ref) {
  ref.keepAlive();
  return '';
});

final ampAssetsStateProvider = AutoDisposeStateProvider<List<String>>((ref) {
  ref.keepAlive();
  return [];
});

final assetsStateProvider =
    AutoDisposeStateNotifierProvider<AssetsNotifier, Map<String, Asset>>((ref) {
  ref.keepAlive();
  return AssetsNotifier(ref);
});

class AssetsNotifier extends StateNotifier<Map<String, Asset>> {
  Ref ref;

  AssetsNotifier(this.ref) : super({});

  void addAsset(String assetId, Asset asset) {
    if (state.keys.contains(assetId)) {
      final value = state[assetId];
      if (value != asset) {
        _updateItem(assetId, asset);
      }
      return;
    }

    _updateItem(assetId, asset);
  }

  void _updateItem(String assetId, Asset asset) {
    final item = <String, Asset>{assetId: asset};

    state = {...state, ...item};
  }
}

final assetUtilsProvider = AutoDisposeProvider((ref) {
  final assets = ref.watch(assetsStateProvider);
  return AssetUtils(ref, assets: assets);
});

class AssetUtils {
  Ref ref;
  Map<String, Asset> assets;

  AssetUtils(this.ref, {required this.assets});

  int getPrecisionForAssetId({String? assetId}) {
    if (assetId == null) {
      return 8;
    }

    return assets[assetId]?.precision ?? 8;
  }

  bool isPricedInLiquid({Asset? asset}) {
    if (asset == null) {
      return false;
    }

    return !asset.swapMarket;
  }

  bool isAmpMarket({String? assetId}) {
    if (assetId == null) {
      return false;
    }

    return assets[assetId]?.ampMarket ?? false;
  }

  bool isAssetToken({String? assetId}) {
    if (assetId == null) {
      return true;
    }

    return !assets[assetId]!.swapMarket;
  }

  Asset? liquidAsset() {
    final liquidAssetId = ref.read(liquidAssetIdProvider);

    return assets[liquidAssetId];
  }

  List<String> liquidAssets() {
    return assets.keys
        .where((element) => element != ref.read(bitcoinAssetIdProvider))
        .toList();
  }

  bool isProduct({Asset? asset}) {
    if (asset == null) {
      return false;
    }

    return asset.swapMarket == true || asset.ampMarket == true;
  }

  List<String> getProductsAssetId() {
    return assets.values
        .where((e) => isProduct(asset: e))
        .map((e) => e.assetId)
        .toList();
  }

  String tickerForAssetId(String? assetId) {
    final asset = assets[assetId];
    return asset?.ticker ?? '';
  }

  String productName({Asset? asset}) {
    if (isPricedInLiquid(asset: asset)) {
      return '${asset?.ticker} / $kLiquidBitcoinTicker';
    }
    return '$kLiquidBitcoinTicker / ${asset?.ticker}';
  }
}

final assetImageProvider = AutoDisposeProvider((ref) {
  final assets = ref.watch(assetsStateProvider);
  final builtinAssets = ref.watch(builtinAssetsProvider);
  final allAssets = <String, Asset>{};
  allAssets.addAll(assets);
  allAssets.addAll(builtinAssets);
  return AssetImage(ref, assets: allAssets);
});

class AssetImage {
  Ref ref;
  Map<String, Asset> assets;
  AssetImage(this.ref, {required this.assets});

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

  Widget getMemoryImage(
    String? assetId, {
    required double width,
    required double height,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetId == null || assetId.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return Icon(
        Icons.help,
        size: width,
      );
    }

    final data = getIconData(assetId);

    if (data.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return Icon(
        Icons.help,
        size: width,
      );
    }

    return Image.memory(
      data,
      width: width,
      height: height,
      filterQuality: filterQuality,
      cacheWidth: width.ceil(),
      cacheHeight: height.ceil(),
    );
  }

  Widget getCustomImage(
    String? assetId, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetId == null || assetId.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return Icon(
        Icons.help,
        size: width,
      );
    }

    // This code cause flickering
    // return getMemoryImage(
    //   assetId,
    //   width: width,
    //   height: height,
    //   filterQuality: filterQuality,
    // );

    return CachedMemoryImage(
      uniqueKey: assetId,
      base64: assets[assetId]?.icon,
      errorWidget: Icon(
        Icons.help,
        size: width,
      ),
      width: width,
      height: height,
      filterQuality: filterQuality,
    );
  }

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

final builtinAssetsProvider =
    AutoDisposeStateProvider<Map<String, Asset>>((ref) {
  ref.keepAlive();

  final newAssets = <String, Asset>{};
  for (final key in builtinAssets.keys) {
    final assetMap = builtinAssets[key]!;
    final asset = Asset(
      assetId: assetMap["assetId"] as String,
      name: assetMap["name"] as String,
      ticker: assetMap["ticker"] as String,
      icon: assetMap["icon"] as String,
      precision: assetMap["precision"] as int,
      swapMarket: assetMap["swapMarket"] as bool,
      domain: assetMap["domain"] as String,
      unregistered: assetMap["unregistered"] as bool,
      ampMarket: assetMap["ampMarket"] as bool,
      domainAgent: assetMap["domainAgent"] as String,
      instantSwaps: assetMap["instantSwaps"] as bool,
    );
    newAssets.addAll({asset.assetId: asset});
  }

  return newAssets;
});
