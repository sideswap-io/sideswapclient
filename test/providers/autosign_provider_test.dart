import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/autosign_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

Future<void> _flushAsync() async {
  for (var i = 0; i < 30; i++) {
    await Future.microtask(() {});
  }
}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(Uint8List.fromList([]));
    registerFallbackValue(
      SideswapSettings.empty(mnemonicEncrypted: Uint8List(0)),
    );
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('Autosign', () {
    test('build mirrors configuration autosignDomains', () {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getBool(any())).thenReturn(null);
      when(() => mockPrefs.getInt(any())).thenReturn(null);
      when(
        () => mockPrefs.getString(SideswapSettings.autosignDomainsField),
      ).thenReturn('{"x.com":true}');

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
          localesProvider.overrideWithValue('en'),
        ],
      );

      expect(container.read(autosignProvider), {'x.com': true});
    });

    test('isAutosign is false when key absent', () {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getBool(any())).thenReturn(null);
      when(() => mockPrefs.getInt(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
          localesProvider.overrideWithValue('en'),
        ],
      );

      expect(
        container.read(autosignProvider.notifier).isAutosign('missing'),
        false,
      );
    });

    test('setAutosign true persists and updates state', () async {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getBool(any())).thenReturn(null);
      when(() => mockPrefs.getInt(any())).thenReturn(null);

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);

      container.read(autosignProvider.notifier).setAutosign('d.com', true);
      await _flushAsync();

      expect(
        container.read(autosignProvider.notifier).isAutosign('d.com'),
        true,
      );
      expect(
        container.read(configurationProvider).autosignDomains['d.com'],
        true,
      );
    });

    test('setAutosign false removes domain key', () async {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getBool(any())).thenReturn(null);
      when(() => mockPrefs.getInt(any())).thenReturn(null);
      when(
        () => mockPrefs.getString(SideswapSettings.autosignDomainsField),
      ).thenReturn('{"d.com":true}');

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(autosignProvider.notifier).isAutosign('d.com'),
        true,
      );

      container.read(autosignProvider.notifier).setAutosign('d.com', false);
      await _flushAsync();

      expect(
        container.read(configurationProvider).autosignDomains.containsKey(
              'd.com',
            ),
        false,
      );
      expect(
        container.read(autosignProvider.notifier).isAutosign('d.com'),
        false,
      );
    });

    test('removeAutosign clears key', () async {
      final mockPrefs = MockSharedPreferences();
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
      when(() => mockPrefs.getString(any())).thenReturn(null);
      when(() => mockPrefs.getBool(any())).thenReturn(null);
      when(() => mockPrefs.getInt(any())).thenReturn(null);
      when(
        () => mockPrefs.getString(SideswapSettings.autosignDomainsField),
      ).thenReturn('{"d.com":true}');

      final container = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockPrefs),
          navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
          localesProvider.overrideWithValue('en'),
        ],
      );
      addTearDown(container.dispose);

      container.read(autosignProvider.notifier).removeAutosign('d.com');
      await _flushAsync();

      expect(
        container.read(configurationProvider).autosignDomains.containsKey(
              'd.com',
            ),
        false,
      );
    });
  });

  // ── AutosignFallthrough.description ─────────────────────────────────────

  group('AutosignFallthrough.description', () {
    test('each value has a non-empty description', () {
      expect(AutosignFallthrough.emptyPayload.description, isNotEmpty);
      expect(AutosignFallthrough.unknownAsset.description, isNotEmpty);
      expect(AutosignFallthrough.zeroQuantity.description, isNotEmpty);
      expect(AutosignFallthrough.missingPrice.description, isNotEmpty);
      expect(AutosignFallthrough.overLimit.description, isNotEmpty);
    });
  });

  // ── isSignRequestWithinAutosignUsdLimit ──────────────────────────────────

  group('isSignRequestWithinAutosignUsdLimit', () {
    const liquidId = 'liq';
    final assets = <String, Asset>{
      'a1': Asset(assetId: 'a1', precision: 8, name: 'A', ticker: 'A'),
      'b1': Asset(assetId: 'b1', precision: 8, name: 'B', ticker: 'B'),
      liquidId: Asset(
        assetId: liquidId,
        precision: 8,
        name: 'L-BTC',
        ticker: 'LBTC',
      ),
    };
    AutosignFallthrough? check({
      Map<String, double> prices = const {},
      required From_SignerRequest_Sign sign,
    }) =>
        isSignRequestWithinAutosignUsdLimit(
          pricesUsd: prices,
          assets: assets,
          liquidAssetId: liquidId,
          sign: sign,
        );

    test('missingPrice when price missing for asset', () {
      expect(
        check(
          prices: {},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: 'a1', amount: Int64(100000000))],
          ),
        ),
        AutosignFallthrough.missingPrice,
      );
    });

    test('unknownAsset when asset not in assets map', () {
      expect(
        check(
          prices: {'unknown': 1.0},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: 'unknown', amount: Int64(100000000))],
          ),
        ),
        AutosignFallthrough.unknownAsset,
      );
    });

    test('unknownAsset for empty assetId', () {
      expect(
        check(
          prices: {'': 1.0},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: '', amount: Int64(100000000))],
          ),
        ),
        AutosignFallthrough.unknownAsset,
      );
    });

    test('null (eligible) for zero balance amount — zero contributes \$0', () {
      expect(
        check(
          prices: {'a1': 1.0},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: 'a1', amount: Int64.ZERO)],
          ),
        ),
        isNull,
      );
    });

    test('null (eligible) for recipients[] regardless of value — excluded from cap check', () {
      // recipients[] = all PSET outputs incl. change-to-self — not checked.
      expect(
        check(
          prices: {'a1': 1.0},
          sign: From_SignerRequest_Sign(
            recipients: [
              AddressAmount(assetId: 'a1', address: 'addr', amount: Int64(999999999999)),
            ],
          ),
        ),
        isNull,
      );
    });

    test('null (eligible) at exactly 100 USD balance (abs applied)', () {
      // 1 unit (1e8 satoshi) × $100/unit = $100; negative = outgoing, abs() used.
      expect(
        check(
          prices: {'a1': 100.0},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: 'a1', amount: Int64(-100000000))],
          ),
        ),
        isNull,
      );
    });

    test('overLimit when balance USD notional exceeds 100 (100.01)', () {
      expect(
        check(
          prices: {'a1': 100.01},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: 'a1', amount: Int64(-100000000))],
          ),
        ),
        AutosignFallthrough.overLimit,
      );
    });

    test('null when all balances within cap, large recipients ignored', () {
      // recipients[] excluded — large change-to-self output does not trigger cap.
      expect(
        check(
          prices: {'a1': 10.0, 'b1': 20.0},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: 'a1', amount: Int64(-100000000))],
            recipients: [
              AddressAmount(
                assetId: 'b1',
                address: 'addr',
                amount: Int64(999999999999), // large change-to-self — ignored
              ),
            ],
          ),
        ),
        isNull,
      );
    });

    test('overLimit when balance exceeds cap regardless of recipients', () {
      expect(
        check(
          prices: {'a1': 200.0},
          sign: From_SignerRequest_Sign(
            balances: [Balance(assetId: 'a1', amount: Int64(-100000000))],
          ),
        ),
        AutosignFallthrough.overLimit,
      );
    });

    test('true for network fee within cap using liquidAssetId', () {
      expect(
        check(
          prices: {liquidId: 50.0},
          sign: From_SignerRequest_Sign(networkFee: Int64(100000000)),
        ),
        isNull,
      );
    });

    test('overLimit for network fee exceeding cap', () {
      expect(
        check(
          prices: {liquidId: 200.0},
          sign: From_SignerRequest_Sign(networkFee: Int64(100000000)),
        ),
        AutosignFallthrough.overLimit,
      );
    });

    test('emptyPayload for empty sign payload (degenerate/ineligible)', () {
      expect(
        check(
          prices: {},
          sign: From_SignerRequest_Sign(),
        ),
        AutosignFallthrough.emptyPayload,
      );
    });
  });
}
