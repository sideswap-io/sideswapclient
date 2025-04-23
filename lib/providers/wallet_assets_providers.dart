import 'dart:typed_data';

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/builtin_assets.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sideswap/common/bitmap_helper.dart';

part 'wallet_assets_providers.g.dart';

@Riverpod(keepAlive: true)
String bitcoinAssetId(Ref ref) {
  return '0000000000000000000000000000000000000000000000000000000000000000';
}

@Riverpod(keepAlive: true)
class LiquidAssetIdState extends _$LiquidAssetIdState {
  @override
  String build() {
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class TetherAssetIdState extends _$TetherAssetIdState {
  @override
  String build() {
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@Riverpod(keepAlive: true)
class EurxAssetIdState extends _$EurxAssetIdState {
  @override
  String build() {
    return '';
  }

  void setState(String value) {
    state = value;
  }
}

@riverpod
class AmpAssetsNotifier extends _$AmpAssetsNotifier {
  @override
  List<String> build() {
    ref.keepAlive();
    final ampAccounts = ref.watch(ampVisibleAccountAssetsProvider);
    return ampAccounts
        .where((e) => e.account.isAmp && e.assetId != null)
        .map((e) => e.assetId!)
        .toList();
  }

  void insertAmpAssets({required List<String> ampAssetIds}) {
    final currentAssets = <String>[];
    currentAssets.addAll(state);

    for (var ampAssetId in ampAssetIds) {
      if (!currentAssets.contains(ampAssetId)) {
        currentAssets.add(ampAssetId);
      }
    }

    state = currentAssets;
  }
}

@Riverpod(keepAlive: true)
class AssetsState extends _$AssetsState {
  @override
  Map<String, Asset> build() {
    return <String, Asset>{};
  }

  void addAsset(String assetId, Asset asset) {
    if (state.keys.contains(assetId)) {
      final value = state[assetId];
      if (value != asset) {
        _updateItem(assetId, asset);
      }
      return;
    }

    _addItem(assetId, asset);
  }

  void _updateItem(String assetId, Asset asset) {
    final oldAssets = {...state};
    oldAssets[assetId] = asset;

    state = oldAssets;
  }

  void _addItem(String assetId, Asset asset) {
    final item = <String, Asset>{assetId: asset};

    state = {...state, ...item};
  }
}

@riverpod
Iterable<Asset> assets(Ref ref) {
  final assetsMap = ref.watch(assetsStateProvider);
  return assetsMap.values;
}

@riverpod
Option<Asset> assetFromAssetId(Ref ref, String? assetId) {
  if (assetId == null) {
    return Option.none();
  }

  final assets = ref.watch(assetsProvider);
  final asset = assets.firstWhereOrNull((e) => e.assetId == assetId);
  if (asset == null) {
    return Option.none();
  }

  return Option.of(asset);
}

@riverpod
AssetUtils assetUtils(Ref ref) {
  final assets = ref.watch(assetsStateProvider);
  return AssetUtils(ref, assets: assets);
}

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

    return !(assets[assetId]?.swapMarket ?? false);
  }

  Asset? regularLiquidAsset() {
    final liquidAssetId = ref.read(liquidAssetIdStateProvider);

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
}

@Riverpod(keepAlive: true)
CacheManager cacheManager(Ref ref) {
  final key = 'imageCache';
  return CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 100,
      fileService: HttpFileService(),
    ),
  );
}

@Riverpod(keepAlive: true)
CachedImageBase64Manager cachedImageManager(Ref ref) {
  final cacheManager = ref.watch(cacheManagerProvider);
  return CachedImageBase64Manager(cacheManager);
}

// clear image cache at startup - use cache only when app is running
@Riverpod(keepAlive: true)
FutureOr<bool> clearImageCacheFuture(Ref ref) async {
  final cacheImageManager = ref.watch(cachedImageManagerProvider);
  logger.d('Clearing image cache...');

  await cacheImageManager.clearCache();

  return true;
}

@riverpod
Map<String, Asset> builtinAssets(Ref ref) {
  final newAssets = <String, Asset>{};
  for (final key in builtinAssetsMap.keys) {
    final assetMap = builtinAssetsMap[key]!;
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
}

@riverpod
FutureOr<Uint8List?> imageBytesResizedFuture(
  Ref ref, {
  required String uniqueKey,
  String? assetSvg,
  String? base64,
  required double width,
  required double height,
}) async {
  final cacheKey = '${uniqueKey}_${width.ceil()}x${height.ceil()}';

  // first try to read cached image from memory
  final cacheManager = ref.watch(cacheManagerProvider);

  final cachedFileInfo = await cacheManager.getFileFromMemory(cacheKey);
  if (cachedFileInfo != null) {
    return cachedFileInfo.file.readAsBytes();
  }

  // if not found in memory then cache file on disk and load to memory
  final cacheImageManager = ref.watch(cachedImageManagerProvider);

  if (await cacheImageManager.isExists(cacheKey)) {
    final cachedFile = await cacheImageManager.cacheBytes(
      cacheKey,
      Uint8List(0),
    );
    return cachedFile.readAsBytes();
  }

  final imageBytes = await BitmapHelper.getResizedImageFromBase64OrAssetName(
    assetSvg,
    base64,
    width,
    height,
    resize: true,
  );

  if (imageBytes.isEmpty) {
    // do not save in cache if empty
    return imageBytes;
  }

  final cachedFile = await cacheImageManager.cacheBytes(cacheKey, imageBytes);
  return cachedFile.readAsBytes();
}

class SideswapCachedMemoryImage extends ConsumerWidget {
  const SideswapCachedMemoryImage({
    super.key,
    required this.uniqueKey,
    this.assetSvg,
    this.base64,
    required this.width,
    required this.height,
    // FilterQuality.medium - a bit lower resolution so scaled down png images looks slightly better than FilterQuality.high
    // this value has no matter for svg images
    this.filterQuality = FilterQuality.medium,
  });

  final String uniqueKey;
  final String? assetSvg;
  final String? base64;
  final double width;
  final double height;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageBytes = ref.watch(
      imageBytesResizedFutureProvider(
        uniqueKey: uniqueKey,
        assetSvg: assetSvg,
        base64: base64,
        width: width,
        height: height,
      ),
    );

    return switch (imageBytes) {
      AsyncData(hasValue: true, value: Uint8List bytes) when bytes.isNotEmpty =>
        Image.memory(
          bytes,
          width: width,
          height: height,
          filterQuality: filterQuality,
          isAntiAlias: true,
        ),
      AsyncLoading() => SizedBox(width: width, height: height),
      _ => FittedBox(child: Icon(Icons.help, size: width)),
    };
  }
}

@Deprecated('Only for mobile app version, should not be used now')
@Riverpod(keepAlive: true)
class SelectedWalletAccountAssetNotifier
    extends _$SelectedWalletAccountAssetNotifier {
  @override
  AccountAsset? build() {
    return null;
  }

  void setAccountAsset(AccountAsset accountAsset) {
    state = accountAsset;
  }
}
