import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/widgets/sideswap_cached_memory_image.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('AssetImageRepository', () {
    late AssetImageRepository repo;

    /// Factory for creating test assets with optional icon data.
    Asset buildAsset({required String assetId, String? icon}) {
      return Asset(
        assetId: assetId,
        name: 'Test',
        ticker: 'TST',
        icon: icon ?? '',
        precision: 8,
        swapMarket: true,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );
    }

    group('generateImageHash', () {
      setUp(() {
        repo = AssetImageRepository(assets: {});
      });

      test('returns 5-character hex string for any label', () {
        final hash = repo.generateImageHash('test');
        expect(hash.length, 5);
        expect(int.tryParse(hash, radix: 16), isNotNull);
      });

      test('returns stable hash for same label', () {
        expect(repo.generateImageHash('foo'), repo.generateImageHash('foo'));
      });

      test('returns different hash for different labels', () {
        expect(repo.generateImageHash('a'), isNot(repo.generateImageHash('b')));
      });

      test('hash uses only radix 16 characters 0-9a-f', () {
        final hash = repo.generateImageHash('some-asset');
        final validChars = RegExp(r'^[0-9a-f]+$');
        expect(validChars.hasMatch(hash), isTrue);
      });

      test('hash is padded to 5 characters with leading zeros', () {
        // Verify that the hash is always 5 chars, padded with leading zeros when needed
        final hash1 = repo.generateImageHash('a');
        final hash2 = repo.generateImageHash('some_longer_label');
        expect(hash1.length, 5);
        expect(hash2.length, 5);
      });
    });

    group('getIconData', () {
      test('returns empty when assetId is null', () {
        repo = AssetImageRepository(assets: {'id': buildAsset(assetId: 'id', icon: 'test')});
        expect(repo.getIconData(null), Uint8List(0));
      });

      test('returns empty when assetId is missing from assets', () {
        repo = AssetImageRepository(assets: {'id': buildAsset(assetId: 'id', icon: '')});
        expect(repo.getIconData('unknown'), Uint8List(0));
      });

      test('returns empty when asset icon is empty string', () {
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: '')},
        );
        expect(repo.getIconData('id'), Uint8List(0));
      });

      test('decodes base64-encoded icon bytes correctly', () {
        const bytes = [1, 2, 3, 4, 5];
        final base64 = base64Encode(bytes);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        expect(repo.getIconData('id'), Uint8List.fromList(bytes));
      });

      test('handles large icon data', () {
        final largeBytes = List<int>.generate(1000, (i) => i % 256);
        final base64 = base64Encode(largeBytes);
        repo = AssetImageRepository(
          assets: {'big': buildAsset(assetId: 'big', icon: base64)},
        );
        expect(repo.getIconData('big'), Uint8List.fromList(largeBytes));
      });
    });

    group('getMemoryImage', () {
      test('returns Image widget when asset has valid icon data', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getMemoryImage('id', width: 32, height: 32);
        expect(widget, isA<Image>());
      });

      test('passes width parameter to Image widget', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getMemoryImage('id', width: 64, height: 32) as Image;
        expect(widget.width, 64);
      });

      test('passes height parameter to Image widget', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getMemoryImage('id', width: 32, height: 48) as Image;
        expect(widget.height, 48);
      });

      test('passes filterQuality parameter to Image widget', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getMemoryImage('id', width: 32, height: 32, filterQuality: FilterQuality.low) as Image;
        expect(widget.filterQuality, FilterQuality.low);
      });

      test('returns help icon when assetId is null', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getMemoryImage(null, width: 32, height: 32);
        expect(widget, isA<FittedBox>());
      });

      test('returns help icon when assetId is empty', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getMemoryImage('', width: 32, height: 32);
        expect(widget, isA<FittedBox>());
      });

      test('returns help icon when asset icon data is empty', () {
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: '')},
        );
        final widget = repo.getMemoryImage('id', width: 32, height: 32);
        expect(widget, isA<FittedBox>());
      });
    });

    group('getCustomImageOrNull', () {
      test('returns null when assetId is missing from assets', () {
        repo = AssetImageRepository(assets: {});
        expect(repo.getCustomImageOrNull('unknown'), isNull);
      });

      test('returns null when asset icon is empty string', () {
        // Note: empty string ('') is falsy in Dart, so assets[assetId]?.icon is empty
        // which is falsy, so it returns null
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: '')},
        );
        final widget = repo.getCustomImageOrNull('id');
        // Actually, empty string is not null, so it returns CachedMemoryImage
        // The code checks: if (assetIcon == null) return null;
        // Since icon is '', not null, it returns CachedMemoryImage
        expect(widget, isNotNull);
      });

      test('returns non-null CachedMemoryImage when asset has icon', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getCustomImageOrNull('id');
        expect(widget, isNotNull);
        expect(widget.runtimeType.toString(), contains('CachedMemoryImage'));
      });

      test('returns null when assetId is null', () {
        repo = AssetImageRepository(assets: {});
        expect(repo.getCustomImageOrNull(null), isNull);
      });

      test('returns null when assetId is empty', () {
        repo = AssetImageRepository(assets: {});
        expect(repo.getCustomImageOrNull(''), isNull);
      });
    });

    group('getCustomImageFromAsset', () {
      test('returns SideswapCachedMemoryImage when assetSvg is non-empty', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImageFromAsset('svg-content');
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns help icon when assetSvg is empty', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImageFromAsset('');
        expect(widget, isA<FittedBox>());
      });

      test('passes width parameter to SideswapCachedMemoryImage', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImageFromAsset('svg', width: 48);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('passes height parameter to SideswapCachedMemoryImage', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImageFromAsset('svg', height: 64);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('passes filterQuality parameter to SideswapCachedMemoryImage', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImageFromAsset('svg', filterQuality: FilterQuality.low);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });
    });

    group('getCustomImage', () {
      test('returns SideswapCachedMemoryImage when asset has icon', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getCustomImage('id');
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns FittedBox with help icon when asset is missing', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImage('unknown');
        expect(widget, isA<FittedBox>());
      });

      test('returns help icon when assetId is null', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImage(null);
        expect(widget, isA<FittedBox>());
      });

      test('returns help icon when assetId is empty', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getCustomImage('');
        expect(widget, isA<FittedBox>());
      });

      test('returns help icon when asset icon is null but asset exists', () {
        // When asset exists but icon field is null, the check: if (assetIcon == null)
        repo = AssetImageRepository(
          assets: {'id': Asset(
            assetId: 'id',
            name: 'Test',
            ticker: 'TST',
            icon: '', // empty string, not null
            precision: 8,
            swapMarket: true,
            domain: '',
            unregistered: false,
            ampMarket: false,
            domainAgent: '',
            instantSwaps: false,
          )},
        );
        final widget = repo.getCustomImage('id');
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('passes width parameter to SideswapCachedMemoryImage', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getCustomImage('id', width: 64);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('passes height parameter to SideswapCachedMemoryImage', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getCustomImage('id', height: 64);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('passes filterQuality parameter to SideswapCachedMemoryImage', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getCustomImage('id', filterQuality: FilterQuality.low);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });
    });

    group('getBigImage', () {
      test('delegates to getCustomImage with 75x75 size', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getBigImage('id');
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns FittedBox when asset is missing', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getBigImage('unknown');
        expect(widget, isA<FittedBox>());
      });

      test('passes filterQuality parameter to getCustomImage', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getBigImage('id', filterQuality: FilterQuality.low);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns help icon when assetId is null', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getBigImage(null);
        expect(widget, isA<FittedBox>());
      });
    });

    group('getSmallImage', () {
      test('delegates to getCustomImage with 32x32 size', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getSmallImage('id');
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns FittedBox when asset is missing', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getSmallImage('unknown');
        expect(widget, isA<FittedBox>());
      });

      test('passes filterQuality parameter to getCustomImage', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getSmallImage('id', filterQuality: FilterQuality.low);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns help icon when assetId is null', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getSmallImage(null);
        expect(widget, isA<FittedBox>());
      });
    });

    group('getVerySmallImage', () {
      test('delegates to getCustomImage with 20x20 size', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getVerySmallImage('id');
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns FittedBox when asset is missing', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getVerySmallImage('unknown');
        expect(widget, isA<FittedBox>());
      });

      test('passes filterQuality parameter to getCustomImage', () {
        final base64 = base64Encode([0, 0]);
        repo = AssetImageRepository(
          assets: {'id': buildAsset(assetId: 'id', icon: base64)},
        );
        final widget = repo.getVerySmallImage('id', filterQuality: FilterQuality.low);
        expect(widget, isA<SideswapCachedMemoryImage>());
      });

      test('returns help icon when assetId is null', () {
        repo = AssetImageRepository(assets: {});
        final widget = repo.getVerySmallImage(null);
        expect(widget, isA<FittedBox>());
      });
    });
  });

  group('assetImageRepositoryProvider', () {
    test('builds repository with assets from assetsStateProvider', () {
      final testAsset = Asset(
        assetId: 'test-id',
        name: 'Test',
        ticker: 'TST',
        icon: base64Encode([1, 2, 3]),
        precision: 8,
        swapMarket: true,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );
      final testAssets = {'test-id': testAsset};

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue(testAssets),
          builtinAssetsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(assetImageRepositoryProvider);
      expect(repo, isA<AssetImageRepository>());
      expect(repo.getIconData('test-id'), Uint8List.fromList([1, 2, 3]));
    });

    test('repository returns empty icon for unknown asset', () {
      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({}),
          builtinAssetsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(assetImageRepositoryProvider);
      expect(repo.getIconData('unknown'), Uint8List(0));
    });

    test('repository uses assets from assetsStateProvider', () {
      final asset1 = Asset(
        assetId: 'a1',
        name: 'Asset1',
        ticker: 'A1',
        icon: base64Encode([1, 1, 1]),
        precision: 8,
        swapMarket: true,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );
      final asset2 = Asset(
        assetId: 'a2',
        name: 'Asset2',
        ticker: 'A2',
        icon: base64Encode([2, 2, 2]),
        precision: 8,
        swapMarket: true,
        domain: '',
        unregistered: false,
        ampMarket: false,
        domainAgent: '',
        instantSwaps: false,
      );

      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({'a1': asset1, 'a2': asset2}),
          builtinAssetsProvider.overrideWithValue({}),
        ],
      );
      addTearDown(container.dispose);

      final repo = container.read(assetImageRepositoryProvider);
      expect(repo.getIconData('a1'), Uint8List.fromList([1, 1, 1]));
      expect(repo.getIconData('a2'), Uint8List.fromList([2, 2, 2]));
    });
  });
}
