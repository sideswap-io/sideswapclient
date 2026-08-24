import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/assets_precache_provider.dart';
import 'package:sideswap/providers/licenses_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/test_utils.dart';

class FakeAssetManifest implements AssetManifest {
  FakeAssetManifest(this.assets);
  final List<String> assets;

  @override
  List<String> listAssets() => assets;

  @override
  List<AssetMetadata>? getAssetVariants(String key) => null;
}

class FakeAssetBundle extends Fake implements AssetBundle {
  @override
  Future<T> loadStructuredBinaryData<T>(
    String key,
    FutureOr<T> Function(ByteData data) parser,
  ) async {
    // Empty manifest encoded via StandardMessageCodec
    final encoded = const StandardMessageCodec().encodeMessage(
      <String, Object?>{},
    )!;
    return parser(encoded);
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  group('svgCache', () {
    test('returns svg.cache instance', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final cache = container.read(svgCacheProvider);
      expect(cache, same(svg.cache));
    });
  });

  group('assetsPrecacheFuture', () {
    test('returns true with matching SVG assets', () async {
      final container = ProviderContainer.test(
        overrides: [
          assetManifestProvider.overrideWith(
            (ref) => FakeAssetManifest(['assets/icon.svg', 'assets/logo.svg']),
          ),
          svgCacheProvider.overrideWithValue(Cache()),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(assetsPrecacheFutureProvider.future);
      expect(result, isTrue);
    });

    test('returns true when no assets pass the SVG + assets/ filter', () async {
      final container = ProviderContainer.test(
        overrides: [
          assetManifestProvider.overrideWith(
            (ref) => FakeAssetManifest([
              'assets/photo.png',
              'other/icon.svg',
              'lib/foo.svg',
            ]),
          ),
          svgCacheProvider.overrideWithValue(Cache()),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(assetsPrecacheFutureProvider.future);
      expect(result, isTrue);
    });

    test('returns true with empty asset list', () async {
      final container = ProviderContainer.test(
        overrides: [
          assetManifestProvider.overrideWith((ref) => FakeAssetManifest([])),
          svgCacheProvider.overrideWithValue(Cache()),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(assetsPrecacheFutureProvider.future);
      expect(result, isTrue);
    });

    test('catch branch does not propagate loader error', () async {
      final container = ProviderContainer.test(
        overrides: [
          assetManifestProvider.overrideWith(
            (ref) => FakeAssetManifest(['assets/fail.svg']),
          ),
          svgCacheProvider.overrideWithValue(Cache()),
        ],
      );
      addTearDown(container.dispose);

      // SvgAssetLoader.loadBytes(null) throws in test env (no real assets);
      // the catch block swallows the error and the provider still returns true.
      final result = await container.read(assetsPrecacheFutureProvider.future);
      expect(result, isTrue);
    });
  });

  group('assetManifest', () {
    test('loads manifest from assetBundleProvider', () async {
      final container = ProviderContainer.test(
        overrides: [assetBundleProvider.overrideWithValue(FakeAssetBundle())],
      );
      addTearDown(container.dispose);

      final manifest = await container.read(assetManifestProvider.future);
      expect(manifest.listAssets(), isEmpty);
    });
  });
}
