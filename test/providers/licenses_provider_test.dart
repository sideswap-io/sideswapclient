import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:sideswap_logger/custom_logger.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/licenses_provider.dart';

Future<List<LicensesData>> _readLicensesEntries(ProviderContainer container) {
  return container.read(licensesEntriesProvider.future);
}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

class FakeAssetBundle extends Fake implements AssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return 'Fake license content for $key';
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('LicensesData', () {
    late LicensesData data;
    late LicenseEntryWithLineBreaks entry;
    late List<LicenseParagraph> paragraphs;

    setUp(() {
      entry = LicenseEntryWithLineBreaks(['pkg_a'], 'License text.');
      paragraphs = entry.paragraphs.toList();
      data = LicensesData(licenseEntry: entry, paragraphs: paragraphs);
    });

    test('constructor stores licenseEntry and paragraphs', () {
      expect(data.licenseEntry, same(entry));
      expect(data.paragraphs, paragraphs);
    });

    test('copyWith returns same values when no arguments given', () {
      final copy = data.copyWith();
      expect(copy.licenseEntry, same(entry));
      expect(copy.paragraphs, paragraphs);
    });

    test('copyWith replaces licenseEntry', () {
      final newEntry = LicenseEntryWithLineBreaks(['pkg_b'], 'Other text.');
      final copy = data.copyWith(licenseEntry: newEntry);
      expect(copy.licenseEntry, same(newEntry));
      expect(copy.paragraphs, paragraphs);
    });

    test('copyWith replaces paragraphs', () {
      final newParagraphs = <LicenseParagraph>[];
      final copy = data.copyWith(paragraphs: newParagraphs);
      expect(copy.licenseEntry, same(entry));
      expect(copy.paragraphs, newParagraphs);
    });

    test('== returns true for identical instances', () {
      expect(data == data, isTrue);
    });

    test('== returns true for equal instances', () {
      final other = LicensesData(licenseEntry: entry, paragraphs: paragraphs);
      expect(data == other, isTrue);
    });

    test('== returns false when licenseEntry differs', () {
      final other = LicensesData(
        licenseEntry: LicenseEntryWithLineBreaks(['pkg_b'], 'Other.'),
        paragraphs: paragraphs,
      );
      expect(data == other, isFalse);
    });

    test('== returns false when paragraphs differ', () {
      final other = LicensesData(licenseEntry: entry, paragraphs: []);
      expect(data == other, isFalse);
    });

    test('hashCode is consistent', () {
      final other = LicensesData(licenseEntry: entry, paragraphs: paragraphs);
      expect(data.hashCode, equals(other.hashCode));
    });

    test('toString includes licenseEntry and paragraphs values', () {
      final str = data.toString();
      expect(str, contains(entry.toString()));
      expect(str, contains(paragraphs.toString()));
    });
  });

  // LicenseRegistry has no reset API; registered licenses accumulate for the
  // entire process lifetime, so entries added in one test remain visible in
  // subsequent tests within the same run.
  group('licensesEntries', () {
    test('returns list containing licenses added to LicenseRegistry', () async {
      LicenseRegistry.addLicense(() async* {
        yield LicenseEntryWithLineBreaks(['test_pkg'], 'Test license text.');
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = await _readLicensesEntries(container);

      expect(result, isA<List<LicensesData>>());
      expect(result, isNotEmpty);
      final entry = result.firstWhere(
        (e) => e.licenseEntry.packages.contains('test_pkg'),
        orElse: () => throw StateError('test_pkg license not found'),
      );
      expect(entry.paragraphs, isNotEmpty);
    });
  });

  group('assetBundle', () {
    test('returns rootBundle by default', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final bundle = container.read(assetBundleProvider);
      expect(bundle, same(rootBundle));
    });
  });

  group('licensesLoaderFuture', () {
    test('returns true and license closure loads from fake bundle', () async {
      final fakeBundle = FakeAssetBundle();
      final container = ProviderContainer.test(
        overrides: [assetBundleProvider.overrideWithValue(fakeBundle)],
      );
      addTearDown(container.dispose);

      final result = await container.read(licensesLoaderFutureProvider.future);
      expect(result, isTrue);

      final entries = await _readLicensesEntries(container);
      expect(entries, isA<List<LicensesData>>());
      final lwkEntry = entries.firstWhere(
        (e) => e.licenseEntry.packages.contains(kPackageLwk),
        orElse: () => throw StateError('LWK license not found'),
      );
      expect(lwkEntry.paragraphs, isNotEmpty);
    });
  });
}
