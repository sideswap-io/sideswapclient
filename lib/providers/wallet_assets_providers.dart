import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/builtin_assets.dart';
import 'package:sideswap/models/tx_item.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';
import 'package:sideswap/common/bitmap_helper.dart';

part 'wallet_assets_providers.g.dart';

@Riverpod(keepAlive: true)
String bitcoinAssetId(BitcoinAssetIdRef ref) {
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

// ampAccountsProvider
final ampAssetsNotifierProvider =
    AutoDisposeNotifierProvider<AmpAssetsNotifier, List<String>>(
        AmpAssetsNotifier.new);

class AmpAssetsNotifier extends AutoDisposeNotifier<List<String>> {
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

  String productName({Asset? asset}) {
    if (isPricedInLiquid(asset: asset)) {
      return '${asset?.ticker} / $kLiquidBitcoinTicker';
    }
    return '$kLiquidBitcoinTicker / ${asset?.ticker}';
  }
}

@Riverpod(keepAlive: true)
CachedImageBase64Manager cachedImageManager(CachedImageManagerRef ref) {
  return CachedImageBase64Manager.instance();
}

// clear image cache at startup - use cache only when app is running
@Riverpod(keepAlive: true)
FutureOr<bool> clearImageCacheFuture(ClearImageCacheFutureRef ref) async {
  final cacheManager = CachedImageBase64Manager.instance();
  logger.d('Clearing image cache...');

  await cacheManager.clearCache();

  return true;
}

final assetImageProvider = AutoDisposeProvider((ref) {
  ref.keepAlive();

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

  String generateImageHash(String label) {
    final hash =
        label.hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');

    return hash;
  }

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
  Widget getMemoryImage(
    String? assetId, {
    required double width,
    required double height,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetId == null || assetId.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return FittedBox(
        child: Icon(
          Icons.help,
          size: width,
        ),
      );
    }

    final data = getIconData(assetId);

    if (data.isEmpty) {
      logger.w('Asset icon data is empty! Using default icon');
      return FittedBox(
        child: Icon(
          Icons.help,
          size: width,
        ),
      );
    }

    return Image.memory(
      data,
      width: width,
      height: height,
      filterQuality: filterQuality,
      isAntiAlias: true,
    );
  }

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
      errorWidget: FittedBox(
        child: Icon(
          Icons.help,
          size: width,
        ),
      ),
      width: width,
      height: height,
      filterQuality: filterQuality,
      isAntiAlias: true,
    );
  }

  Widget getCustomImageFromAsset(
    String assetSvg, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    if (assetSvg.isEmpty) {
      logger.w('Asset is empty! Using default icon');
      return FittedBox(
        child: Icon(
          Icons.help,
          size: width,
        ),
      );
    }

    return SideswapCachedMemoryImage(
      uniqueKey: generateImageHash(assetSvg),
      assetSvg: assetSvg,
      width: width,
      height: height,
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
      return FittedBox(
        child: Icon(
          Icons.help_outline,
          size: width,
        ),
      );
    }

    final assetIcon = assets[assetId]?.icon;

    if (assetIcon == null) {
      return FittedBox(
        child: Icon(
          Icons.help,
          size: width,
        ),
      );
    }

    return SideswapCachedMemoryImage(
      uniqueKey: generateImageHash(assetId),
      base64: assetIcon,
      width: width,
      height: height,
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

// TODO (malcolmpl): fix this - Map<AccountAsset, Asset>
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

@riverpod
FutureOr<Uint8List?> imageBytesResizedFuture(
  ImageBytesResizedFutureRef ref, {
  required String uniqueKey,
  String? assetSvg,
  String? base64,
  required double width,
  required double height,
}) async {
  // replace disk cache to own memory cache if you want to load images faster
  final cacheManager = ref.watch(cachedImageManagerProvider);
  const ext = 'png';

  final cacheKey = '${uniqueKey}_${width.ceil()}x${height.ceil()}';

  if (await cacheManager.isExists(cacheKey)) {
    final cachedFile = await cacheManager.cacheBytes(cacheKey, Uint8List(0),
        fileExtension: ext);
    return cachedFile.readAsBytes();
  }

  final imageBytes = await BitmapHelper.getResizedImageFromBase64OrAssetName(
      assetSvg, base64, width, height);

  if (imageBytes.isEmpty) {
    // do not save in cache if empty
    return imageBytes;
  }

  final cachedFile =
      await cacheManager.cacheBytes(cacheKey, imageBytes, fileExtension: ext);
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
    final imageBytes = ref.watch(imageBytesResizedFutureProvider(
      uniqueKey: uniqueKey,
      assetSvg: assetSvg,
      base64: base64,
      width: width,
      height: height,
    ));

    return switch (imageBytes) {
      AsyncData(hasValue: true, value: Uint8List bytes) when bytes.isNotEmpty =>
        Image.memory(
          bytes,
          width: width,
          height: height,
          filterQuality: filterQuality,
          isAntiAlias: true,
        ),
      AsyncLoading() => SizedBox(
          width: width,
          height: height,
        ),
      _ => FittedBox(child: Icon(Icons.help, size: width)),
    };
  }
}

final accountAssetTransactionsProvider =
    AutoDisposeProvider<Map<AccountAsset, List<TxItem>>>((ref) {
  final allTxs = ref.watch(allTxsNotifierProvider);
  final allPegs = ref.watch(allPegsNotifierProvider);
  final liquidAssetId = ref.watch(liquidAssetIdStateProvider);

  final allAssets = <AccountAsset, List<TxItem>>{};

  void addTxItem(Map<AccountAsset, List<TxItem>> accountAssetsTransactions,
      AccountAsset accountAsset, TransItem transaction) {
    if (accountAssetsTransactions[accountAsset] == null) {
      accountAssetsTransactions[accountAsset] = [];
    }
    accountAssetsTransactions[accountAsset]!.add(TxItem(item: transaction));
  }

  final accountAssetTransactions = <AccountAsset, List<TxItem>>{};

  for (final item in allTxs.values) {
    final tx = item.tx;
    for (final balance in tx.balances) {
      final accountAsset =
          AccountAsset(AccountType(item.account.id), balance.assetId);
      addTxItem(accountAssetTransactions, accountAsset, item);
    }
  }

  for (final order in allPegs.entries) {
    for (final item in order.value) {
      final accountAsset = AccountAsset(AccountType.reg, liquidAssetId);
      addTxItem(accountAssetTransactions, accountAsset, item);
    }
  }

  final dateFormat = DateFormat('yyyy-MM-dd');
  for (var item in accountAssetTransactions.entries) {
    item.value.sort((a, b) => b.compareTo(a));

    final tempAssets = <TxItem>[];
    for (var item in item.value) {
      if (tempAssets.isEmpty) {
        tempAssets.add(item.copyWith(showDate: true));
      } else {
        final last = DateTime.parse(dateFormat.format(
            DateTime.fromMillisecondsSinceEpoch(tempAssets.last.createdAt)));
        final current = DateTime.parse(dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(item.createdAt)));
        final diff = last.difference(current).inDays;
        tempAssets.add(item.copyWith(showDate: diff != 0));
      }
    }

    allAssets[item.key] = tempAssets;
  }

  return allAssets;
});

final selectedWalletAssetProvider =
    AutoDisposeStateProvider<AccountAsset?>((ref) {
  ref.keepAlive();

  return null;
});

final walletAssetPricesNotifierProvider = AutoDisposeNotifierProvider<
    WalletAssetPricesNotifier,
    Map<String, From_PriceUpdate>>(WalletAssetPricesNotifier.new);

class WalletAssetPricesNotifier
    extends AutoDisposeNotifier<Map<String, From_PriceUpdate>> {
  @override
  Map<String, From_PriceUpdate> build() {
    ref.keepAlive();
    return {};
  }

  void updatePrices(From_PriceUpdate priceUpdate) {
    state[priceUpdate.asset] = priceUpdate;
    ref.notifyListeners();
  }
}
