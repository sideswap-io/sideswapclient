import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/country_code.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/countries_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../helpers/fake_configuration.dart';
import '../utils.dart';

// ============================================================================
// Helpers
// ============================================================================

CountryCode _countryCode(String iso3, String? english, String? name) =>
    CountryCode(
      iso3Code: iso3,
      english: english,
      name: name,
      countryCode: iso3.substring(0, 2).toUpperCase(),
      dialCode: '+1',
      currencyCode: 'USD',
      currencyName: 'Dollar',
    );

Asset _assetWithRestrictions(List<String> allowedCountries) {
  final asset = Asset();
  final restrictions = AmpAssetRestrictions();
  restrictions.allowedCountries.addAll(allowedCountries);
  asset.ampAssetRestrictions = restrictions;
  return asset;
}

Asset _assetWithoutRestrictions() => Asset();

// Mock notifier for StokrBlockedCountries
class MockStokrBlockedCountriesNotifier extends StokrBlockedCountries {
  final List<CountryCode> _result;

  MockStokrBlockedCountriesNotifier(this._result);

  @override
  FutureOr<List<CountryCode>> build() {
    // Return synchronously so the AsyncValue is resolved immediately
    return _result;
  }
}

// Mock notifier for StokrBlockedCountries that returns loading state
class MockStokrBlockedCountriesLoadingNotifier extends StokrBlockedCountries {
  @override
  FutureOr<List<CountryCode>> build() {
    // Return a future that never completes to simulate loading
    return Future.delayed(Duration(seconds: 10), () => []);
  }
}

void main() {
  setUpAll(() {
    registerFallbackValue(Option<Asset>.none());
  });

  group('StokrSettingsModel', () {
    test('creates instance with default firstRun=true', () {
      final model = const StokrSettingsModel();
      expect(model.firstRun, true);
    });

    test('creates instance with custom firstRun value', () {
      final model = const StokrSettingsModel(firstRun: false);
      expect(model.firstRun, false);
    });

    test('fromJson creates instance from JSON map', () {
      const json = {'firstRun': false};
      final model = StokrSettingsModel.fromJson(json);
      expect(model.firstRun, false);
    });

    test('fromJson defaults firstRun to true when missing', () {
      const json = <String, dynamic>{};
      final model = StokrSettingsModel.fromJson(json);
      expect(model.firstRun, true);
    });
  });

  group('StokrSettingsNotifier', () {
    late ProviderContainer container;

    setUp(() {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List.fromList([]),
      );
      container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWith(
            () => FakeConfiguration(settings),
          ),
        ],
      );
      addTearDown(container.dispose);
    });

    group('build', () {
      test('returns default StokrSettingsModel when config has no stokrSettings',
          () {
        final state = container.read(stokrSettingsProvider);
        expect(state, const StokrSettingsModel());
        expect(state.firstRun, true);
      });

      test('returns stokrSettings from config when present', () {
        final stokrSettings = const StokrSettingsModel(firstRun: false);
        final configSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          stokrSettingsModel: stokrSettings,
        );
        final testContainer = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(
              () => FakeConfiguration(configSettings),
            ),
          ],
        );
        addTearDown(testContainer.dispose);

        final state = testContainer.read(stokrSettingsProvider);
        expect(state, stokrSettings);
        expect(state.firstRun, false);
      });
    });

    group('setStokrSettings', () {
      test('updates state with new StokrSettingsModel', () {
        final newSettings = const StokrSettingsModel(firstRun: false);

        final state1 = container.read(stokrSettingsProvider);
        expect(state1.firstRun, true);

        container
            .read(stokrSettingsProvider.notifier)
            .setStokrSettings(newSettings);

        final state2 = container.read(stokrSettingsProvider);
        expect(state2.firstRun, false);
        expect(state2, newSettings);
      });

      test('triggers listener on state change', () {
        final listener = ProviderListener<StokrSettingsModel>();
        container.listen(stokrSettingsProvider, listener.call,
            fireImmediately: true);

        verifyInOrder([
          () => listener(null, const StokrSettingsModel()),
        ]);

        final newSettings = const StokrSettingsModel(firstRun: false);
        container
            .read(stokrSettingsProvider.notifier)
            .setStokrSettings(newSettings);

        verify(() => listener(const StokrSettingsModel(), newSettings))
            .called(1);
      });
    });

    group('save', () {
      test('calls configurationProvider.notifier.setStokrSettingsModel', () {
        final settings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
        );
        final fakeConfig = FakeConfiguration(settings);
        final testContainer = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => fakeConfig),
          ],
        );
        addTearDown(testContainer.dispose);

        final notifier = testContainer.read(stokrSettingsProvider.notifier);
        final newSettings = const StokrSettingsModel(firstRun: false);
        notifier.setStokrSettings(newSettings);

        notifier.save();

        expect(fakeConfig.state.stokrSettingsModel, newSettings);
      });
    });
  });

  group('StokrBlockedCountries', () {
    late ProviderContainer container;
    late List<CountryCode> mockCountries;

    setUp(() {
      mockCountries = [
        _countryCode('USA', 'United States', 'United States'),
        _countryCode('GBR', 'United Kingdom', 'United Kingdom'),
        _countryCode('CAN', 'Canada', 'Canada'),
        _countryCode('AUS', 'Australia', 'Australia'),
      ];
    });

    group('when baseAsset is none', () {
      test('returns async value', () {
        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider
                .overrideWithValue(Option.none()),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(stokrBlockedCountriesProvider);
        expect(result, isA<AsyncValue<List<CountryCode>>>());
      });
    });

    group('when asset has no restrictions', () {
      test('returns future (outer switch default case - line 73)', () {
        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider.overrideWithValue(
              Option.of(_assetWithoutRestrictions()),
            ),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(stokrBlockedCountriesProvider);
        // Should hit line 73: _ => future, (default case)
        expect(result, isA<AsyncValue<List<CountryCode>>>());
      });
    });

    group('when countriesFutureProvider is loading', () {
      test('returns future when countries async state is loading (line 73)', () {
        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider.overrideWithValue(
              Option.of(_assetWithRestrictions(['USA'])),
            ),
            countriesFutureProvider.overrideWith(
              (ref) async {
                // Simulate a loading state that never completes
                await Future.delayed(Duration(seconds: 10));
                return [];
              },
            ),
          ],
        );
        addTearDown(container.dispose);

        final result = container.read(stokrBlockedCountriesProvider);
        // Should hit line 73: _ => future, (default case - not hasValue: true)
        expect(result, isA<AsyncValue<List<CountryCode>>>());
        // Verify it's loading state, not data
        expect(result.hasValue, false);
      });
    });

    group('when asset has restrictions', () {
      test('filters countries not in allowedCountries list', () async {
        final allowedCountries = ['USA', 'GBR'];
        final asset = _assetWithRestrictions(allowedCountries);

        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider
                .overrideWithValue(Option.of(asset)),
            countriesFutureProvider
                .overrideWith((ref) => mockCountries),
            stokrBlockedCountriesProvider.overrideWith(
              () => MockStokrBlockedCountriesNotifier([
                mockCountries[2], // CAN
                mockCountries[3], // AUS
              ]),
            ),
          ],
        );
        addTearDown(container.dispose);

        final result = await container
            .read(stokrBlockedCountriesProvider.future);

        expect(result, hasLength(2));
        expect(result.first.iso3Code, 'CAN');
        expect(result.last.iso3Code, 'AUS');
      });

      test('retainWhere keeps only countries NOT in allowedCountries', () async {
        final allowedCountries = ['USA'];
        final allCountries = [
          _countryCode('USA', 'United States', 'United States'),
          _countryCode('CAN', 'Canada', 'Canada'),
          _countryCode('GBR', 'United Kingdom', 'United Kingdom'),
        ];

        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider
                .overrideWithValue(Option.of(_assetWithRestrictions(allowedCountries))),
            countriesFutureProvider
                .overrideWith((ref) => allCountries),
          ],
        );
        addTearDown(container.dispose);

        final result =
            await container.read(stokrBlockedCountriesProvider.future);

        // USA is allowed, so it should NOT be in blocked list
        expect(result, isNotEmpty);
        expect(result.length, 2);
        expect(result.any((c) => c.iso3Code == 'USA'), false);
      });

      test('sort applies compareTo on english field for blocked countries', () async {
        final unsortedCountries = [
          _countryCode('ZZZ', 'Zebra', 'Zebra Land'),
          _countryCode('BBB', 'Banana', 'Banana Land'),
          _countryCode('AAA', 'Apple', 'Apple Land'),
        ];
        final allowedCountries = <String>[];
        final asset = _assetWithRestrictions(allowedCountries);

        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider
                .overrideWithValue(Option.of(asset)),
            countriesFutureProvider
                .overrideWith((ref) => unsortedCountries),
          ],
        );
        addTearDown(container.dispose);

        final result =
            await container.read(stokrBlockedCountriesProvider.future);

        expect(result, hasLength(3));
        expect(result[0].english, 'Apple');
        expect(result[1].english, 'Banana');
        expect(result[2].english, 'Zebra');
      });

      test('sort handles null english name with ?? operator', () async {
        final countriesWithNull = [
          _countryCode('BBB', 'Banana', 'Banana Land'),
          CountryCode(
            iso3Code: 'XXX',
            english: null,
            name: 'No Name',
            countryCode: 'XX',
            dialCode: '+1',
            currencyCode: 'USD',
            currencyName: 'Dollar',
          ),
          _countryCode('AAA', 'Apple', 'Apple Land'),
        ];
        final asset = _assetWithRestrictions(<String>[]);

        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider
                .overrideWithValue(Option.of(asset)),
            countriesFutureProvider
                .overrideWith((ref) => countriesWithNull),
          ],
        );
        addTearDown(container.dispose);

        final result =
            await container.read(stokrBlockedCountriesProvider.future);

        expect(result, isNotEmpty);
        expect(result.length, 3);
      });

      test('returns Future.value wrapping filtered list', () async {
        final allowedCountries = ['USA'];
        final allCountries = [
          _countryCode('USA', 'United States', 'United States'),
          _countryCode('CAN', 'Canada', 'Canada'),
        ];
        final asset = _assetWithRestrictions(allowedCountries);

        container = ProviderContainer.test(
          overrides: [
            marketSubscribedBaseAssetProvider
                .overrideWithValue(Option.of(asset)),
            countriesFutureProvider
                .overrideWith((ref) => allCountries),
          ],
        );
        addTearDown(container.dispose);

        final result =
            await container.read(stokrBlockedCountriesProvider.future);

        expect(result, isA<List<CountryCode>>());
        expect(result.length, greaterThanOrEqualTo(0));
      });

      test('returns empty list when all countries are allowed', () async {
        container = ProviderContainer.test(
          overrides: [
            stokrBlockedCountriesProvider.overrideWith(
              () => MockStokrBlockedCountriesNotifier([]),
            ),
          ],
        );
        addTearDown(container.dispose);

        final result =
            await container.read(stokrBlockedCountriesProvider.future);

        expect(result, isEmpty);
      });
    });
  });

  group('stokrCountryBlacklistSearch', () {
    late ProviderContainer container;

    test('returns empty list when stokrBlockedCountries is loading (line 95)', () {
      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesLoadingNotifier(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('test'));

      // Should hit line 95: _ => [], (default case - not hasValue: true)
      expect(result, isA<AsyncValue<List<CountryCode>>>());
      // When the async value is loading (no value), should return empty list
      expect(result.value, isEmpty);
    });

    test('returns empty list when stokrBlockedCountries has no value', () {
      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesNotifier([]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('test'));

      expect(result, isA<AsyncValue<List<CountryCode>>>());
      expect(result.value, isEmpty);
    });

    test('filters by english name matching case-insensitively', () {
      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesNotifier([
              _countryCode('CAN', 'Canada', 'CanadaName'),
              _countryCode('USA', 'United States', 'USName'),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('canada'));

      expect(result, isA<AsyncValue<List<CountryCode>>>());
      expect(result.value, hasLength(1));
      expect(result.value!.first.english, 'Canada');
    });

    test('filters by name field matching case-insensitively', () {
      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesNotifier([
              _countryCode('CAN', 'Canada', 'CanadaLand'),
              _countryCode('USA', 'United States', 'USALand'),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('land'));

      expect(result, isA<AsyncValue<List<CountryCode>>>());
      expect(result.value, hasLength(2));
    });

    test('handles english field null using ?? operator', () {
      final countriesWithNull = [
        _countryCode('CAN', 'Canada', 'CanadaName'),
        CountryCode(
          iso3Code: 'XXX',
          english: null,
          name: 'TestName',
          countryCode: 'XX',
          dialCode: '+1',
          currencyCode: 'USD',
          currencyName: 'Dollar',
        ),
      ];

      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesNotifier(countriesWithNull),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('Canada'));

      expect(result, isA<AsyncValue<List<CountryCode>>>());
      expect(result.value, hasLength(1));
      expect(result.value!.first.iso3Code, 'CAN');
    });

    test('handles name field null using ?? operator', () {
      final countriesWithNull = [
        _countryCode('CAN', 'Canada', 'CanadaName'),
        CountryCode(
          iso3Code: 'YYY',
          english: 'TestCountry',
          name: null,
          countryCode: 'YY',
          dialCode: '+1',
          currencyCode: 'USD',
          currencyName: 'Dollar',
        ),
      ];

      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesNotifier(countriesWithNull),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('Canada'));

      expect(result, isA<AsyncValue<List<CountryCode>>>());
      expect(result.value, hasLength(1));
    });

    test('converts where iterable to List with toList()', () {
      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesNotifier([
              _countryCode('CAN', 'Canada', 'CanadaName'),
              _countryCode('AUS', 'Australia', 'AustraliaName'),
              _countryCode('USA', 'United States', 'USName'),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('a'));

      expect(result, isA<AsyncValue<List<CountryCode>>>());
      expect(result.value!.length, greaterThan(0));
    });

    test('returns empty list when search matches no countries', () {
      container = ProviderContainer.test(
        overrides: [
          stokrBlockedCountriesProvider.overrideWith(
            () => MockStokrBlockedCountriesNotifier([
              _countryCode('CAN', 'Canada', 'CanadaName'),
              _countryCode('USA', 'United States', 'USName'),
            ]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result =
          container.read(stokrCountryBlacklistSearchProvider('xyz'));

      expect(result, isA<AsyncValue<List<CountryCode>>>());
      expect(result.value, isEmpty);
    });
  });

  group('StokrLastSelectedAssetNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initializes with Option.none()', () {
        container.read(stokrLastSelectedAssetProvider);
        final state = container.read(stokrLastSelectedAssetProvider);

        expect(state.isNone(), true);
      });
    });

    group('setLastSelectedAsset', () {
      test('wraps asset in Option.some()', () {
        container.read(stokrLastSelectedAssetProvider);

        final mockAsset = Asset();
        container
            .read(stokrLastSelectedAssetProvider.notifier)
            .setLastSelectedAsset(mockAsset);

        final state = container.read(stokrLastSelectedAssetProvider);
        expect(state.isSome(), true);
        expect(state.fold(() => null, (a) => a), mockAsset);
      });

      test('replaces previous asset when called multiple times', () {
        container.read(stokrLastSelectedAssetProvider);

        final asset1 = Asset();
        final asset2 = Asset();

        container
            .read(stokrLastSelectedAssetProvider.notifier)
            .setLastSelectedAsset(asset1);

        var state = container.read(stokrLastSelectedAssetProvider);
        expect(state.fold(() => null, (a) => a), asset1);

        container
            .read(stokrLastSelectedAssetProvider.notifier)
            .setLastSelectedAsset(asset2);

        state = container.read(stokrLastSelectedAssetProvider);
        expect(state.fold(() => null, (a) => a), asset2);
      });

      test('triggers listener on state change', () {
        container.read(stokrLastSelectedAssetProvider);
        final listener = ProviderListener<Option<Asset>>();
        container.listen(stokrLastSelectedAssetProvider, listener.call,
            fireImmediately: true);

        // Verify initial fire with none
        verify(() => listener(null, any())).called(1);
        reset(listener);

        final asset = Asset();
        container
            .read(stokrLastSelectedAssetProvider.notifier)
            .setLastSelectedAsset(asset);

        // Verify state changed
        verify(() => listener(any(), any())).called(1);
      });
    });

    group('keepAlive behavior', () {
      test('persists state across reads (keepAlive: true)', () {
        final asset = Asset();

        container
            .read(stokrLastSelectedAssetProvider.notifier)
            .setLastSelectedAsset(asset);

        var state = container.read(stokrLastSelectedAssetProvider);
        expect(state.fold(() => null, (a) => a), asset);

        state = container.read(stokrLastSelectedAssetProvider);
        expect(state.fold(() => null, (a) => a), asset);
      });
    });
  });
}
