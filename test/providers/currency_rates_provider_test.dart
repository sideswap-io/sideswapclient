import 'dart:typed_data';

import 'package:decimal/decimal.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/currency_rates_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';
import '../helpers/fake_configuration.dart';

class MockWallet extends Mock implements SideswapWallet {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    registerFallbackValue(ConversionRates(usdConversionRates: []));
    registerFallbackValue(To());
  });

  group('ConversionRate', () {
    test('creates instance with name and rate', () {
      final rate = ConversionRate(name: 'USD', rate: Decimal.one);
      expect(rate.name, 'USD');
      expect(rate.rate, Decimal.one);
    });

    test('supports equality comparison', () {
      final rate1 = ConversionRate(name: 'USD', rate: Decimal.one);
      final rate2 = ConversionRate(name: 'USD', rate: Decimal.one);
      final rate3 = ConversionRate(name: 'EUR', rate: Decimal.one);

      expect(rate1, equals(rate2));
      expect(rate1, isNot(equals(rate3)));
    });
  });

  group('ConversionRates', () {
    test('creates instance with empty list', () {
      final rates = ConversionRates(usdConversionRates: []);
      expect(rates.usdConversionRates, isEmpty);
    });

    test('creates instance with rates', () {
      final rateList = [
        ConversionRate(name: 'USD', rate: Decimal.one),
        ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
      ];
      final rates = ConversionRates(usdConversionRates: rateList);
      expect(rates.usdConversionRates, rateList);
    });
  });

  group('ConversionRatesNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('returns empty conversion rates initially', () {
        final rates = container.read(conversionRatesProvider);
        expect(rates.usdConversionRates, isEmpty);
      });
    });

    group('setConversionRates', () {
      test('adds new conversion rates to empty list', () {
        final listener = ProviderListener<ConversionRates>();
        container.listen(conversionRatesProvider, listener.call,
            fireImmediately: true);

        final from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        from.usdConversionRates['EUR'] = 0.92;

        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        final newRates = container.read(conversionRatesProvider);
        expect(newRates.usdConversionRates, hasLength(2));
        expect(newRates.usdConversionRates[0].name, 'EUR');
        expect(newRates.usdConversionRates[0].rate, Decimal.parse('0.92'));
        expect(newRates.usdConversionRates[1].name, 'USD');
        expect(newRates.usdConversionRates[1].rate, Decimal.one);
      });

      test('updates existing rate when rate changes', () {
        // Set initial rates
        var from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        from.usdConversionRates['EUR'] = 0.92;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        expect(
          container.read(conversionRatesProvider).usdConversionRates[1].rate,
          Decimal.one,
        );

        // Update the USD rate
        from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.05;
        from.usdConversionRates['EUR'] = 0.92;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        final newRates = container.read(conversionRatesProvider);
        expect(
          newRates.usdConversionRates
              .firstWhere((r) => r.name == 'USD')
              .rate,
          Decimal.parse('1.05'),
        );
      });

      test('does not update state when rate is the same', () {
        final listener = ProviderListener<ConversionRates>();
        // Set initial rates
        var from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        container.listen(conversionRatesProvider, listener.call,
            fireImmediately: false);

        // Set the same rates again
        from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        // Listener should not be called since state didn't change
        verifyNever(() => listener(any(), any()));
      });


      test('converts string rates to Decimal using tryParse', () {
        final from = From_ConversionRates();
        from.usdConversionRates['DECIMAL'] = 123.456;
        from.usdConversionRates['SMALL'] = 0.0001;
        from.usdConversionRates['LARGE'] = 9999999.99;

        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        final newRates = container.read(conversionRatesProvider);
        expect(newRates.usdConversionRates, hasLength(3));
        expect(
          newRates.usdConversionRates
              .firstWhere((r) => r.name == 'DECIMAL')
              .rate,
          Decimal.parse('123.456'),
        );
        expect(
          newRates.usdConversionRates
              .firstWhere((r) => r.name == 'SMALL')
              .rate,
          Decimal.parse('0.0001'),
        );
      });

      test('maintains sorted order by name after update', () {
        var from = From_ConversionRates();
        from.usdConversionRates['CHARLIE'] = 3.0;
        from.usdConversionRates['ALICE'] = 1.0;
        from.usdConversionRates['BOB'] = 2.0;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        var newRates = container.read(conversionRatesProvider);
        expect(
          newRates.usdConversionRates.map((r) => r.name).toList(),
          ['ALICE', 'BOB', 'CHARLIE'],
        );

        // Add a new rate that should be sorted
        from = From_ConversionRates();
        from.usdConversionRates['CHARLIE'] = 3.0;
        from.usdConversionRates['ALICE'] = 1.0;
        from.usdConversionRates['BOB'] = 2.0;
        from.usdConversionRates['DELTA'] = 4.0;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        newRates = container.read(conversionRatesProvider);
        expect(
          newRates.usdConversionRates.map((r) => r.name).toList(),
          ['ALICE', 'BOB', 'CHARLIE', 'DELTA'],
        );
      });

      test('preserves existing rates when adding new ones', () {
        var from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        from.usdConversionRates['EUR'] = 0.92;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        final newRates = container.read(conversionRatesProvider);
        expect(newRates.usdConversionRates, hasLength(2));
        expect(
          newRates.usdConversionRates
              .firstWhere((r) => r.name == 'USD')
              .rate,
          Decimal.one,
        );
      });

      test('updates single rate among multiple rates', () {
        var from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        from.usdConversionRates['EUR'] = 0.92;
        from.usdConversionRates['GBP'] = 0.88;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        expect(container.read(conversionRatesProvider).usdConversionRates,
            hasLength(3));

        from = From_ConversionRates();
        from.usdConversionRates['EUR'] = 0.95;
        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        final newRates = container.read(conversionRatesProvider);
        expect(newRates.usdConversionRates, hasLength(3));
        expect(
          newRates.usdConversionRates
              .firstWhere((r) => r.name == 'EUR')
              .rate,
          Decimal.parse('0.95'),
        );
      });

      test('skips zero rate and logs warning', () {
        final from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        from.usdConversionRates['ZERO'] = 0.0;

        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        final rates = container.read(conversionRatesProvider);
        expect(rates.usdConversionRates, hasLength(1));
        expect(rates.usdConversionRates[0].name, 'USD');
      });

      test('skips rate when tryParse returns null (NaN fallback to Decimal.zero)', () {
        final from = From_ConversionRates();
        from.usdConversionRates['USD'] = 1.0;
        from.usdConversionRates['BAD'] = double.nan;

        container.read(conversionRatesProvider.notifier).setConversionRates(from);

        final rates = container.read(conversionRatesProvider);
        expect(rates.usdConversionRates, hasLength(1));
        expect(rates.usdConversionRates[0].name, 'USD');
      });

    });
  });

  group('RequestConversionRates', () {
    late MockWallet mockWallet;

    setUp(() {
      mockWallet = MockWallet();
      when(() => mockWallet.sendMsg(any())).thenReturn(null);
    });

    test('build() returns early when libClientState is empty', () {
      final container = ProviderContainer.test(
        overrides: [
          libClientStateProvider.overrideWithValue(const LibClientState.empty()),
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      container.read(requestConversionRatesProvider);

      verifyNever(() => mockWallet.sendMsg(any()));
    });

    test('build() calls sendMsg when libClientState is initialized', () {
      final container = ProviderContainer.test(
        overrides: [
          libClientStateProvider.overrideWithValue(const LibClientState.initialized()),
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      container.read(requestConversionRatesProvider);

      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('catch branch: sendMsg throws, no exception propagates', () {
      when(() => mockWallet.sendMsg(any())).thenThrow(Exception('test'));

      final container = ProviderContainer.test(
        overrides: [
          libClientStateProvider.overrideWithValue(const LibClientState.initialized()),
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);

      expect(() => container.read(requestConversionRatesProvider), returnsNormally);
      verify(() => mockWallet.sendMsg(any())).called(1);
    });

    test('timer fires after 10 seconds triggering another sendMsg call', () {
      fakeAsync((async) {
        final container = ProviderContainer.test(
          overrides: [
            libClientStateProvider.overrideWithValue(const LibClientState.initialized()),
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);

        container.read(requestConversionRatesProvider);
        verify(() => mockWallet.sendMsg(any())).called(1);

        async.elapse(const Duration(seconds: 10));

        // After timer fires, invalidateSelf rebuilds which calls sendMsg again
        container.read(requestConversionRatesProvider);
        verify(() => mockWallet.sendMsg(any())).called(1);
      });
    });

    test('onDispose cancels timer', () {
      fakeAsync((async) {
        final container = ProviderContainer.test(
          overrides: [
            libClientStateProvider.overrideWithValue(const LibClientState.initialized()),
            walletProvider.overrideWithValue(mockWallet),
          ],
        );
        addTearDown(container.dispose);

        container.read(requestConversionRatesProvider);
        verify(() => mockWallet.sendMsg(any())).called(1);

        container.dispose();

        // Elapse past the timer period — no further sendMsg calls since timer was cancelled
        async.elapse(const Duration(seconds: 30));
        verifyNever(() => mockWallet.sendMsg(any()));
      });
    });
  });

  group('DefaultConversionRateNotifier', () {
    late ProviderContainer container;

    group('build', () {
      test('returns null when no conversion rates are available', () {
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          defaultCurrency: null,
        );

        final testContainer = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(testContainer.dispose);

        final rate = testContainer.read(defaultConversionRateProvider);
        expect(rate, isNull);
      });

      test('returns saved default currency when it exists in rates', () {
        final rates = [
          ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
          ConversionRate(name: 'USD', rate: Decimal.one),
        ];
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          defaultCurrency: 'EUR',
        );

        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: rates),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(container.dispose);

        final rate = container.read(defaultConversionRateProvider);
        expect(rate?.name, 'EUR');
        expect(rate?.rate, Decimal.parse('0.92'));
      });

      test('falls back to USD when saved currency not found in rates', () {
        final rates = [
          ConversionRate(name: 'USD', rate: Decimal.one),
          ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
        ];
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          defaultCurrency: 'MISSING',
        );

        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: rates),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(container.dispose);

        final rate = container.read(defaultConversionRateProvider);
        expect(rate?.name, 'USD');
        expect(rate?.rate, Decimal.one);
      });

      test('falls back to USD when no default currency is saved', () {
        final rates = [
          ConversionRate(name: 'USD', rate: Decimal.one),
          ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
        ];
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          defaultCurrency: null,
        );

        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: rates),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(container.dispose);

        final rate = container.read(defaultConversionRateProvider);
        expect(rate?.name, 'USD');
      });

      test('returns null when USD is not in rates and no default is saved', () {
        final rates = [
          ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
          ConversionRate(name: 'GBP', rate: Decimal.parse('0.88')),
        ];
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          defaultCurrency: null,
        );

        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: rates),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(container.dispose);

        final rate = container.read(defaultConversionRateProvider);
        expect(rate, isNull);
      });

      test('returns USD when it exists even if another default is preferred', () {
        final rates = [
          ConversionRate(name: 'USD', rate: Decimal.one),
          ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
        ];
        final mockConfig = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([]),
          defaultCurrency: null,
        );

        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: rates),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(mockConfig)),
          ],
        );
        addTearDown(container.dispose);

        final rate = container.read(defaultConversionRateProvider);
        expect(rate?.name, 'USD');
      });
    });

    group('setDefaultConversionRate', () {
      test('sets state and saves to configuration when name is not empty', () {
        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: [
                ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
              ]),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(
              SideswapSettings.empty(
                mnemonicEncrypted: Uint8List.fromList([]),
                defaultCurrency: null,
              ),
            )),
          ],
        );
        addTearDown(container.dispose);

        final newRate = ConversionRate(name: 'EUR', rate: Decimal.parse('0.92'));
        container
            .read(defaultConversionRateProvider.notifier)
            .setDefaultConversionRate(newRate);

        final state =
            container.read(defaultConversionRateProvider.notifier).state;
        expect(state, newRate);
      });

      test('does not update state when conversion rate name is empty', () {
        container = ProviderContainer.test(
          overrides: [
            configurationProvider.overrideWith(() => FakeConfiguration(
              SideswapSettings.empty(
                mnemonicEncrypted: Uint8List.fromList([]),
                defaultCurrency: null,
              ),
            )),
          ],
        );
        addTearDown(container.dispose);

        final initialState =
            container.read(defaultConversionRateProvider.notifier).state;
        final emptyRate = ConversionRate(name: '', rate: Decimal.one);
        container
            .read(defaultConversionRateProvider.notifier)
            .setDefaultConversionRate(emptyRate);

        final newState =
            container.read(defaultConversionRateProvider.notifier).state;
        expect(newState, initialState);
      });

      test('updates state with new rate when previously null', () {
        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: [
                ConversionRate(name: 'EUR', rate: Decimal.parse('0.92')),
              ]),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(
              SideswapSettings.empty(
                mnemonicEncrypted: Uint8List.fromList([]),
                defaultCurrency: null,
              ),
            )),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(defaultConversionRateProvider), isNull);

        final newRate = ConversionRate(name: 'EUR', rate: Decimal.parse('0.92'));
        container
            .read(defaultConversionRateProvider.notifier)
            .setDefaultConversionRate(newRate);

        expect(
          container.read(defaultConversionRateProvider.notifier).state,
          newRate,
        );
      });

      test('replaces existing rate with new rate', () {
        final oldRate = ConversionRate(name: 'USD', rate: Decimal.one);
        final newRate = ConversionRate(name: 'EUR', rate: Decimal.parse('0.92'));
        container = ProviderContainer.test(
          overrides: [
            conversionRatesProvider.overrideWithValue(
              ConversionRates(usdConversionRates: [oldRate, newRate]),
            ),
            configurationProvider.overrideWith(() => FakeConfiguration(
              SideswapSettings.empty(
                mnemonicEncrypted: Uint8List.fromList([]),
                defaultCurrency: 'USD',
              ),
            )),
          ],
        );
        addTearDown(container.dispose);

        expect(container.read(defaultConversionRateProvider), oldRate);

        container
            .read(defaultConversionRateProvider.notifier)
            .setDefaultConversionRate(newRate);

        expect(
          container.read(defaultConversionRateProvider.notifier).state,
          newRate,
        );
      });
    });
  });

  group('defaultConversionRateMultiplier', () {
    test('returns rate value when default conversion rate exists', () {
      final rate = ConversionRate(name: 'EUR', rate: Decimal.parse('0.92'));
      final container = ProviderContainer.test(
        overrides: [
          defaultConversionRateProvider.overrideWithValue(rate),
        ],
      );
      addTearDown(container.dispose);

      final multiplier = container.read(defaultConversionRateMultiplierProvider);
      expect(multiplier, Decimal.parse('0.92'));
    });

    test('returns Decimal.one when default conversion rate is null', () {
      final container = ProviderContainer.test(
        overrides: [
          defaultConversionRateProvider.overrideWithValue(null),
        ],
      );
      addTearDown(container.dispose);

      final multiplier = container.read(defaultConversionRateMultiplierProvider);
      expect(multiplier, Decimal.one);
    });

    test('returns rate when it is exactly Decimal.one', () {
      final rate = ConversionRate(name: 'USD', rate: Decimal.one);
      final container = ProviderContainer.test(
        overrides: [
          defaultConversionRateProvider.overrideWithValue(rate),
        ],
      );
      addTearDown(container.dispose);

      final multiplier = container.read(defaultConversionRateMultiplierProvider);
      expect(multiplier, Decimal.one);
    });

    test('returns rate with high precision decimal', () {
      final rate = ConversionRate(
        name: 'PRECISE',
        rate: Decimal.parse('123.456789012345'),
      );
      final container = ProviderContainer.test(
        overrides: [
          defaultConversionRateProvider.overrideWithValue(rate),
        ],
      );
      addTearDown(container.dispose);

      final multiplier = container.read(defaultConversionRateMultiplierProvider);
      expect(multiplier, Decimal.parse('123.456789012345'));
    });
  });
}
