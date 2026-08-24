import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:file/file.dart' as file_lib;
import 'package:file/local.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

class MockCacheManager extends Mock implements CacheManager {}

class MockCacheInfoRepository extends Mock implements CacheInfoRepository {}

/// Inert [FileSystem] — [IOFileSystem] would create a real cache directory
/// through path_provider at construction time.
class _FakeCacheFileSystem implements FileSystem {
  @override
  Future<file_lib.File> createFile(String name) =>
      Future.value(const LocalFileSystem().file(name));
}

class MockCachedImageBase64Manager extends Mock
    implements CachedImageBase64Manager {}

class _FakePathProviderPlatform extends PathProviderPlatform {
  final String _tempPath = Directory.systemTemp.path;

  @override
  Future<String?> getTemporaryPath() async => _tempPath;

  @override
  Future<String?> getApplicationSupportPath() async => _tempPath;

  @override
  Future<String?> getApplicationDocumentsPath() async => _tempPath;

  @override
  Future<String?> getApplicationCachePath() async => _tempPath;
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    registerFallbackValue(Uint8List(0));
  });

  group('bitcoinAssetIdProvider', () {
    test('returns bitcoin asset id constant', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(bitcoinAssetIdProvider);

      expect(result, '0000000000000000000000000000000000000000000000000000000000000000');
    });
  });

  group('LiquidAssetIdState', () {
    test('initial state is empty string', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(liquidAssetIdStateProvider);

      expect(result, '');
    });

    test('setState updates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(liquidAssetIdStateProvider.notifier).setState('newAssetId');

      expect(container.read(liquidAssetIdStateProvider), 'newAssetId');
    });

    test('setState fires listener', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final listener = ProviderListener<String>();
      container.listen(liquidAssetIdStateProvider, listener.call, fireImmediately: true);

      verify(() => listener(any(), any())).called(1);
      clearInteractions(listener);

      container.read(liquidAssetIdStateProvider.notifier).setState('assetId1');

      verify(() => listener(any(), any())).called(1);
    });
  });

  group('TetherAssetIdState', () {
    test('initial state is empty string', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(tetherAssetIdStateProvider);

      expect(result, '');
    });

    test('setState updates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(tetherAssetIdStateProvider.notifier).setState('usdt');

      expect(container.read(tetherAssetIdStateProvider), 'usdt');
    });
  });

  group('EurxAssetIdState', () {
    test('initial state is empty string', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(eurxAssetIdStateProvider);

      expect(result, '');
    });

    test('setState updates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(eurxAssetIdStateProvider.notifier).setState('eurx');

      expect(container.read(eurxAssetIdStateProvider), 'eurx');
    });
  });

  group('AmpAssetIdsNotifier', () {
    test('initial state is empty list', () {
      final container = ProviderContainer.test(
        overrides: [
          ampVisibleAccountAssetsProvider.overrideWithValue([]),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampAssetIdsProvider);

      expect(result, []);
    });

    test('filters AMP assets from visible account assets', () {
      final assets = [
        AccountAsset(Account.AMP_, 'amp1'),
        AccountAsset(Account.AMP_, 'amp2'),
      ];

      final container = ProviderContainer.test(
        overrides: [
          ampVisibleAccountAssetsProvider.overrideWithValue(assets),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampAssetIdsProvider);

      expect(result, ['amp1', 'amp2']);
    });

    test('excludes AMP assets with null assetId', () {
      final assets = [
        AccountAsset(Account.AMP_, 'amp1'),
        AccountAsset(Account.AMP_, null),
      ];

      final container = ProviderContainer.test(
        overrides: [
          ampVisibleAccountAssetsProvider.overrideWithValue(assets),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(ampAssetIdsProvider);

      expect(result, ['amp1']);
    });

    test('insertAmpAssets adds new assets to state', () {
      final container = ProviderContainer.test(
        overrides: [
          ampVisibleAccountAssetsProvider.overrideWithValue([
            AccountAsset(Account.AMP_, 'amp1'),
          ]),
        ],
      );
      addTearDown(container.dispose);

      container.read(ampAssetIdsProvider.notifier).insertAmpAssets(
        ampAssetIds: ['amp2', 'amp3'],
      );

      final result = container.read(ampAssetIdsProvider);
      expect(result, ['amp1', 'amp2', 'amp3']);
    });

    test('insertAmpAssets does not add duplicates', () {
      final container = ProviderContainer.test(
        overrides: [
          ampVisibleAccountAssetsProvider.overrideWithValue([
            AccountAsset(Account.AMP_, 'amp1'),
          ]),
        ],
      );
      addTearDown(container.dispose);

      container.read(ampAssetIdsProvider.notifier).insertAmpAssets(
        ampAssetIds: ['amp1', 'amp2'],
      );

      final result = container.read(ampAssetIdsProvider);
      expect(result, ['amp1', 'amp2']);
    });

    test('insertAmpAssets with empty list does not change state', () {
      final container = ProviderContainer.test(
        overrides: [
          ampVisibleAccountAssetsProvider.overrideWithValue([
            AccountAsset(Account.AMP_, 'amp1'),
          ]),
        ],
      );
      addTearDown(container.dispose);

      container.read(ampAssetIdsProvider.notifier).insertAmpAssets(
        ampAssetIds: [],
      );

      final result = container.read(ampAssetIdsProvider);
      expect(result, ['amp1']);
    });
  });

  group('AssetsState', () {
    test('initial state is empty map', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(assetsStateProvider);

      expect(result, {});
    });

    test('addAsset adds new asset', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset);

      final result = container.read(assetsStateProvider);
      expect(result, {'asset1': asset});
    });

    test('addAsset updates existing asset if different', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset1 = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      final asset2 = Asset(
        assetId: 'asset1',
        name: 'Asset One Updated',
        ticker: 'ASS1',
        icon: '',
        precision: 4,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset1);
      container.read(assetsStateProvider.notifier).addAsset('asset1', asset2);

      final result = container.read(assetsStateProvider);
      expect(result['asset1']!.precision, 4);
      expect(result['asset1']!.name, 'Asset One Updated');
    });

    test('addAsset does not update if asset is same', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
      final state1 = container.read(assetsStateProvider);

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
      final state2 = container.read(assetsStateProvider);

      // Adding same asset twice should not create new map
      expect(identical(state1, state2), true);
    });

    test('addAsset maintains multiple assets in state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset1 = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      final asset2 = Asset(
        assetId: 'asset2',
        name: 'Asset Two',
        ticker: 'ASS2',
        icon: '',
        precision: 4,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset1);
      container.read(assetsStateProvider.notifier).addAsset('asset2', asset2);

      final result = container.read(assetsStateProvider);
      expect(result.length, 2);
      expect(result['asset1'], asset1);
      expect(result['asset2'], asset2);
    });
  });

  group('assetsProvider', () {
    test('returns empty iterable when no assets', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(assetsProvider);

      expect(result.toList(), []);
    });

    test('returns assets from assetsStateProvider', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset1 = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset1);

      final result = container.read(assetsProvider).toList();

      expect(result.length, 1);
      expect(result[0], asset1);
    });
  });

  group('assetFromAssetId', () {
    test('returns None when assetId is null', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(assetFromAssetIdProvider(null));

      expect(result, Option.none());
    });

    test('returns None when asset not found', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(assetFromAssetIdProvider('nonexistent'));

      expect(result, Option.none());
    });

    test('returns Some when asset found', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset);

      final result = container.read(assetFromAssetIdProvider('asset1'));

      expect(result.isSome(), true);
      final extracted = result.fold(() => null, (a) => a);
      expect(extracted, asset);
    });
  });

  group('assetUtilsProvider', () {
    test('returns AssetUtils instance', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(assetUtilsProvider);

      expect(result, isA<AssetUtils>());
    });
  });

  group('AssetUtils', () {
    group('getPrecisionForAssetId', () {
      test('returns 8 when assetId is null', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.getPrecisionForAssetId(assetId: null), 8);
      });

      test('returns 8 when asset not found', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.getPrecisionForAssetId(assetId: 'nonexistent'), 8);
      });

      test('returns precision from asset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 4,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
        final utils = container.read(assetUtilsProvider);

        expect(utils.getPrecisionForAssetId(assetId: 'asset1'), 4);
      });
    });

    group('isPricedInLiquid', () {
      test('returns false when asset is null', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.isPricedInLiquid(asset: null), false);
      });

      test('returns true when swapMarket is false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        final utils = container.read(assetUtilsProvider);

        expect(utils.isPricedInLiquid(asset: asset), true);
      });

      test('returns false when swapMarket is true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: true,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        final utils = container.read(assetUtilsProvider);

        expect(utils.isPricedInLiquid(asset: asset), false);
      });
    });

    group('isAmpMarket', () {
      test('returns false when assetId is null', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.isAmpMarket(assetId: null), false);
      });

      test('returns false when asset not found', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.isAmpMarket(assetId: 'nonexistent'), false);
      });

      test('returns ampMarket from asset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: true,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
        final utils = container.read(assetUtilsProvider);

        expect(utils.isAmpMarket(assetId: 'asset1'), true);
      });
    });

    group('isAssetToken', () {
      test('returns true when assetId is null', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.isAssetToken(assetId: null), true);
      });

      test('returns true when swapMarket is false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
        final utils = container.read(assetUtilsProvider);

        expect(utils.isAssetToken(assetId: 'asset1'), true);
      });

      test('returns false when swapMarket is true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: true,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
        final utils = container.read(assetUtilsProvider);

        expect(utils.isAssetToken(assetId: 'asset1'), false);
      });

      test('returns true when asset not found (treats as non-swapMarket)', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.isAssetToken(assetId: 'nonexistent'), true);
      });
    });

    group('regularLiquidAsset', () {
      test('returns null when liquidAssetId not set', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.regularLiquidAsset(), null);
      });

      test('returns asset for liquidAssetId', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'liquidasset',
          name: 'Liquid Asset',
          ticker: 'LIQ',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('liquidasset', asset);
        container.read(liquidAssetIdStateProvider.notifier).setState('liquidasset');

        final utils = container.read(assetUtilsProvider);

        expect(utils.regularLiquidAsset(), asset);
      });
    });

    group('liquidAssets', () {
      test('returns empty list when no assets', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.liquidAssets(), []);
      });

      test('excludes bitcoin asset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final btcAssetId = container.read(bitcoinAssetIdProvider);

        final asset1 = Asset(
          assetId: btcAssetId,
          name: 'Bitcoin',
          ticker: 'BTC',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        final asset2 = Asset(
          assetId: 'liquid',
          name: 'Liquid',
          ticker: 'LIQ',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset(btcAssetId, asset1);
        container.read(assetsStateProvider.notifier).addAsset('liquid', asset2);

        final utils = container.read(assetUtilsProvider);
        final result = utils.liquidAssets();

        expect(result, ['liquid']);
      });
    });

    group('isProduct', () {
      test('returns false when asset is null', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.isProduct(asset: null), false);
      });

      test('returns true when swapMarket is true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: true,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        final utils = container.read(assetUtilsProvider);

        expect(utils.isProduct(asset: asset), true);
      });

      test('returns true when ampMarket is true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: true,
          domainAgent: '',
          instantSwaps: false,
        );

        final utils = container.read(assetUtilsProvider);

        expect(utils.isProduct(asset: asset), true);
      });

      test('returns false when both swapMarket and ampMarket are false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        final utils = container.read(assetUtilsProvider);

        expect(utils.isProduct(asset: asset), false);
      });
    });

    group('getProductsAssetId', () {
      test('returns empty list when no products', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
        final utils = container.read(assetUtilsProvider);

        expect(utils.getProductsAssetId(), []);
      });

      test('returns asset ids of products', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final product = Asset(
          assetId: 'product1',
          name: 'Product',
          ticker: 'PROD',
          icon: '',
          precision: 8,
          swapMarket: true,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        final nonProduct = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('product1', product);
        container.read(assetsStateProvider.notifier).addAsset('asset1', nonProduct);

        final utils = container.read(assetUtilsProvider);

        expect(utils.getProductsAssetId(), ['product1']);
      });
    });

    group('tickerForAssetId', () {
      test('returns empty string when assetId is null', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.tickerForAssetId(null), '');
      });

      test('returns empty string when asset not found', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final utils = container.read(assetUtilsProvider);

        expect(utils.tickerForAssetId('nonexistent'), '');
      });

      test('returns ticker from asset', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final asset = Asset(
          assetId: 'asset1',
          name: 'Asset One',
          ticker: 'ASS1',
          icon: '',
          precision: 8,
          swapMarket: false,
          domain: '',
          unregistered: false,
          ampMarket: false,
          domainAgent: '',
          instantSwaps: false,
        );

        container.read(assetsStateProvider.notifier).addAsset('asset1', asset);
        final utils = container.read(assetUtilsProvider);

        expect(utils.tickerForAssetId('asset1'), 'ASS1');
      });
    });
  });

  group('imageCacheConfig', () {
    late PathProviderPlatform originalPathProvider;

    setUp(() {
      originalPathProvider = PathProviderPlatform.instance;
      PathProviderPlatform.instance = _FakePathProviderPlatform();
    });

    tearDown(() {
      PathProviderPlatform.instance = originalPathProvider;
    });

    test('returns image cache config', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(imageCacheConfigProvider);

      expect(result.cacheKey, 'imageCache');
      expect(result.stalePeriod, const Duration(days: 30));
      expect(result.maxNrOfCacheObjects, 100);
      expect(result.fileService, isA<HttpFileService>());
    });
  });

  group('cacheManager', () {
    test('returns CacheManager instance', () {
      // A real Config would open the platform cache-info repository: sqflite on
      // macOS/iOS/Android, a JSON file elsewhere. Inject an inert repository and
      // file system so the provider is exercised identically on every platform.
      final repo = MockCacheInfoRepository();
      when(repo.open).thenAnswer((_) async => true);
      final container = ProviderContainer.test(
        overrides: [
          imageCacheConfigProvider.overrideWithValue(
            Config(
              'imageCache',
              repo: repo,
              fileSystem: _FakeCacheFileSystem(),
              fileService: HttpFileService(),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(cacheManagerProvider);

      expect(result, isA<CacheManager>());
    });
  });

  group('cachedImageManager', () {
    test('returns CachedImageBase64Manager instance', () {
      final mockCacheManager = MockCacheManager();
      final container = ProviderContainer.test(
        overrides: [cacheManagerProvider.overrideWithValue(mockCacheManager)],
      );
      addTearDown(container.dispose);

      final result = container.read(cachedImageManagerProvider);

      expect(result, isA<CachedImageBase64Manager>());
    });

    test('constructs with cacheManager from provider', () {
      final mockCacheManager = MockCacheManager();
      final container = ProviderContainer.test(
        overrides: [cacheManagerProvider.overrideWithValue(mockCacheManager)],
      );
      addTearDown(container.dispose);

      // Reading twice returns same instance (keepAlive)
      final result1 = container.read(cachedImageManagerProvider);
      final result2 = container.read(cachedImageManagerProvider);

      expect(identical(result1, result2), isTrue);
    });
  });

  group('imageBytesResizedFuture', () {
    test('returns bytes from memory cache when available', () async {
      final tempFile = const LocalFileSystem()
          .file('${Directory.systemTemp.path}/test_img_mem.jpg');
      await tempFile.writeAsBytes([1, 2, 3]);
      addTearDown(() => tempFile.deleteSync(recursive: true));

      final fileInfo = FileInfo(
        tempFile,
        FileSource.Cache,
        DateTime.now().add(const Duration(days: 1)),
        'test_key',
      );

      final mockCacheManager = MockCacheManager();
      when(() => mockCacheManager.getFileFromMemory(any()))
          .thenAnswer((_) async => fileInfo);

      final container = ProviderContainer.test(
        overrides: [cacheManagerProvider.overrideWithValue(mockCacheManager)],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        imageBytesResizedFutureProvider(
          uniqueKey: 'k',
          width: 32,
          height: 32,
        ).future,
      );

      expect(result, [1, 2, 3]);
    });

    test('returns empty when no cache and no image data', () async {
      final mockCacheManager = MockCacheManager();
      final mockImageManager = MockCachedImageBase64Manager();

      when(() => mockCacheManager.getFileFromMemory(any()))
          .thenAnswer((_) async => null);
      when(() => mockImageManager.isExists(any()))
          .thenAnswer((_) async => false);

      final container = ProviderContainer.test(
        overrides: [
          cacheManagerProvider.overrideWithValue(mockCacheManager),
          cachedImageManagerProvider.overrideWithValue(mockImageManager),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        imageBytesResizedFutureProvider(
          uniqueKey: 'k',
          assetSvg: null,
          base64: null,
          width: 32,
          height: 32,
        ).future,
      );

      expect(result, isEmpty);
    });

    test('encodes image, caches and returns bytes when not cached', () async {
      final pngBytes = img.encodePng(img.Image(width: 4, height: 4));
      final base64String = base64Encode(pngBytes);

      final cachedFile =
          File('${Directory.systemTemp.path}/test_img_cached.jpg');
      await cachedFile.writeAsBytes([7, 8, 9]);
      addTearDown(() => cachedFile.deleteSync());

      final mockCacheManager = MockCacheManager();
      final mockImageManager = MockCachedImageBase64Manager();

      when(() => mockCacheManager.getFileFromMemory(any()))
          .thenAnswer((_) async => null);
      when(() => mockImageManager.isExists(any()))
          .thenAnswer((_) async => false);
      when(() => mockImageManager.cacheBytes(any(), any()))
          .thenAnswer((_) async => cachedFile);

      final container = ProviderContainer.test(
        overrides: [
          cacheManagerProvider.overrideWithValue(mockCacheManager),
          cachedImageManagerProvider.overrideWithValue(mockImageManager),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        imageBytesResizedFutureProvider(
          uniqueKey: 'k',
          base64: base64String,
          width: 32,
          height: 32,
        ).future,
      );

      expect(result, [7, 8, 9]);
      verify(() => mockImageManager.cacheBytes(any(), any())).called(1);
    });

    test('returns bytes from disk cache when not in memory', () async {
      final diskFile =
          File('${Directory.systemTemp.path}/test_img_disk.jpg');
      await diskFile.writeAsBytes([4, 5, 6]);
      addTearDown(() => diskFile.deleteSync());

      final mockCacheManager = MockCacheManager();
      final mockImageManager = MockCachedImageBase64Manager();

      when(() => mockCacheManager.getFileFromMemory(any()))
          .thenAnswer((_) async => null);
      when(() => mockImageManager.isExists(any()))
          .thenAnswer((_) async => true);
      when(() => mockImageManager.cacheBytes(any(), any()))
          .thenAnswer((_) async => diskFile);

      final container = ProviderContainer.test(
        overrides: [
          cacheManagerProvider.overrideWithValue(mockCacheManager),
          cachedImageManagerProvider.overrideWithValue(mockImageManager),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        imageBytesResizedFutureProvider(
          uniqueKey: 'k',
          width: 32,
          height: 32,
        ).future,
      );

      expect(result, [4, 5, 6]);
    });
  });

  group('clearImageCacheFuture', () {
    test('clears cache and returns true', () async {
      final mockManager = MockCachedImageBase64Manager();
      when(() => mockManager.clearCache()).thenAnswer((_) async {});

      final container = ProviderContainer.test(
        overrides: [
          cachedImageManagerProvider.overrideWithValue(mockManager),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(clearImageCacheFutureProvider.future);

      expect(result, isTrue);
      verify(() => mockManager.clearCache()).called(1);
    });
  });

  group('builtinAssetsProvider', () {
    test('returns map with builtin assets', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(builtinAssetsProvider);

      expect(result, isA<Map<String, Asset>>());
      expect(result.isNotEmpty, true);
    });

    test('builtin assets have correct properties', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(builtinAssetsProvider);

      for (final entry in result.entries) {
        expect(entry.value.assetId, isNotEmpty);
        expect(entry.value.name, isNotEmpty);
        expect(entry.value.ticker, isNotNull);
        expect(entry.value.icon, isNotNull);
        expect(entry.value.precision, isA<int>());
        expect(entry.value.swapMarket, isA<bool>());
      }
    });
  });

  group('SelectedWalletAccountAssetNotifier', () {
    test('throws Exception on build', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(
        () => container.read(selectedWalletAccountAssetProvider),
        throwsException,
      );
    });

    test('throws Exception on setAccountAsset', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final accountAsset = AccountAsset(Account.REG, 'asset1');

      expect(
        () => container
            .read(selectedWalletAccountAssetProvider.notifier)
            .setAccountAsset(accountAsset),
        throwsException,
      );
    });
  });

  group('SelectedWalletAssetNotifier', () {
    test('initial state is None when liquidAssetId is empty', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(selectedWalletAssetProvider);

      expect(result, Option.none());
    });

    test('returns Some when asset exists for liquidAssetId', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'liquid',
        name: 'Liquid',
        ticker: 'LIQ',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('liquid', asset);
      container.read(liquidAssetIdStateProvider.notifier).setState('liquid');

      final result = container.read(selectedWalletAssetProvider);

      expect(result.isSome(), true);
      final extracted = result.fold(() => null, (a) => a);
      expect(extracted, asset);
    });

    test('returns None when liquidAssetId has no corresponding asset', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(liquidAssetIdStateProvider.notifier).setState('nonexistent');

      final result = container.read(selectedWalletAssetProvider);

      expect(result, Option.none());
    });

    test('setState updates state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(selectedWalletAssetProvider.notifier).setState(asset);

      final result = container.read(selectedWalletAssetProvider);

      expect(result.isSome(), true);
      final extracted = result.fold(() => null, (a) => a);
      expect(extracted, asset);
    });

    test('reacts to liquidAssetIdState changes', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final asset = Asset(
        assetId: 'asset1',
        name: 'Asset One',
        ticker: 'ASS1',
        icon: '',
        precision: 8,
        swapMarket: false,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      container.read(assetsStateProvider.notifier).addAsset('asset1', asset);

      final initial = container.read(selectedWalletAssetProvider);
      expect(initial, Option.none());

      container.read(liquidAssetIdStateProvider.notifier).setState('asset1');

      final updated = container.read(selectedWalletAssetProvider);
      expect(updated.isSome(), true);
      final extracted = updated.fold(() => null, (a) => a);
      expect(extracted, asset);
    });
  });
}
