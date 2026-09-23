import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/desktop_window_geometry.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/fake_shared_preferences.dart';
import '../helpers/settings_container.dart';
import '../helpers/test_utils.dart';
import '../utils.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

/// Drains enough microtask rounds to complete [_saveSettings] (which has ~24 sequential awaits).
Future<void> _flushAsync() async {
  for (var i = 0; i < 30; i++) {
    await Future.microtask(() {});
  }
}

class MockNavigatorKey extends Mock {
  BuildContext? currentContext;
}

void _setupMockSharedPreferences(MockSharedPreferences mockPrefs) {
  when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(Uint8List.fromList([]));
    registerFallbackValue(
      SideswapSettings.empty(mnemonicEncrypted: Uint8List(0)),
    );
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  group('Configuration', () {
    group('build - reading initial settings from preferences', () {
      test('reads all settings from shared preferences on initialization', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        // Setup generic matchers - return null so defaults are used
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

        final settings = container.read(configurationProvider);

        expect(settings.jadeId, '');
        expect(settings.licenseAccepted, false);
        expect(settings.enableEndpoint, true);
        expect(settings.useBiometricProtection, false);
        expect(settings.env, 0);
        // Mnemonic field is read and decoding empty string returns empty Uint8List
        expect(settings.mnemonicEncrypted.isEmpty, true);
      });

      test('initializes with correct default values when prefs are empty', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        // Return null for getBool/getInt so that defaults are used
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.mnemonicEncrypted.isEmpty, true);
        expect(settings.settingsNetworkType, SettingsNetworkType.sideswap);
        expect(settings.showAmpOnboarding, false);
      });

      test(
        'defaults to sideswap when network type is null and no valid context',
        () {
          // Note: The code checks (context != null && lang == 'zh') for sideswapChina.
          // Getting a non-null currentContext requires full widget tree setup.
          // This test documents the fallback behavior.
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);

          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(null);
          when(() => mockPrefs.getInt(any())).thenReturn(null);

          final container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(mockPrefs),
              navigatorKeyProvider.overrideWithValue(
                GlobalKey<NavigatorState>(),
              ),
              localesProvider.overrideWithValue('zh'),
            ],
          );

          final settings = container.read(configurationProvider);

          // Without a valid context, defaults to sideswap even with zh locale
          expect(settings.settingsNetworkType, SettingsNetworkType.sideswap);
        },
      );

      test('returns sideswap as default when network type is null and locale is not zh', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        final mockNavigatorKey = GlobalKey<NavigatorState>();

        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(mockNavigatorKey),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.settingsNetworkType, SettingsNetworkType.sideswap);
      });

      test('decodes base64 mnemonic from preferences', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        final mnemonicBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final encoded = base64.encode(mnemonicBytes);

        // Setup generic matchers FIRST
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        // Then specific overrides
        when(() => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField))
            .thenReturn(encoded);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.mnemonicEncrypted, mnemonicBytes);
      });

      test('reads network settings as JSON from preferences', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        final networkModel = NetworkSettingsModelEmpty(
          settingsNetworkType: SettingsNetworkType.blockstream,
          host: 'example.com',
          port: 8080,
          useTls: true,
        );
        final encoded = jsonEncode(networkModel.toJson());

        // Setup generic matchers FIRST
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        // Then specific overrides
        when(
          () => mockPrefs.getString(SideswapSettings.networkSettingsModelField),
        ).thenReturn(encoded);
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.networkSettingsModel, isA<NetworkSettingsModelEmpty>());
      });

      test('returns NetworkSettingsModelEmpty on network settings JSON decode error', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        // Register any() FIRST, then specific overrides take precedence
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);
        when(
          () => mockPrefs.getString(SideswapSettings.networkSettingsModelField),
        ).thenReturn('invalid{{{');
        // Provide a valid settingsNetworkType to cover notNullString? branch (line 519)
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(
          EnumToString.convertToString(SettingsNetworkType.sideswap),
        );

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.networkSettingsModel, isA<NetworkSettingsModelEmpty>());
      });

      test('reads stokr settings as JSON from preferences', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        final stokrModel = const StokrSettingsModel(firstRun: false);
        final encoded = jsonEncode(stokrModel.toJson());

        // Setup generic matchers FIRST
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        // Then specific overrides
        when(
          () => mockPrefs.getString(SideswapSettings.stokrSettingsModelField),
        ).thenReturn(encoded);
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.stokrSettingsModel, isA<StokrSettingsModel>());
        expect(settings.stokrSettingsModel?.firstRun, false);
      });

      test('returns default StokrSettingsModel on JSON decode error', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        // Register any() FIRST, then specific overrides take precedence
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);
        when(
          () => mockPrefs.getString(SideswapSettings.stokrSettingsModelField),
        ).thenReturn('invalid{{{');
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.stokrSettingsModel, isA<StokrSettingsModel>());
        expect(settings.stokrSettingsModel?.firstRun, true);
      });

      test('reads proxy settings from preferences', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        // Setup generic matchers FIRST
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);

        // Then specific overrides
        when(() => mockPrefs.getString(SideswapSettings.proxyHostField))
            .thenReturn('proxy.example.com');
        when(() => mockPrefs.getInt(SideswapSettings.proxyPortField))
            .thenReturn(3128);
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.proxySettings?.host, 'proxy.example.com');
        expect(settings.proxySettings?.port, 3128);
      });

      test('returns null for proxy settings when host or port is null', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        when(() => mockPrefs.getString(SideswapSettings.proxyHostField))
            .thenReturn(null);
        when(() => mockPrefs.getInt(SideswapSettings.proxyPortField))
            .thenReturn(null);
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.proxySettings, null);
      });

      test('reads pin data from preferences when all fields are present', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        // Setup generic matchers FIRST
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);

        // Then specific overrides
        when(() => mockPrefs.getString(SideswapSettings.pinSaltField))
            .thenReturn('salt123');
        when(() => mockPrefs.getString(SideswapSettings.pinEncryptedDataField))
            .thenReturn('encryptedData123');
        when(() => mockPrefs.getString(SideswapSettings.pinIdentifierField))
            .thenReturn('pinId123');
        when(() => mockPrefs.getString(SideswapSettings.pinHmacField))
            .thenReturn('hmac123');
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.pinDataState, isA<PinDataStateData>());
        expect((settings.pinDataState as PinDataStateData).salt, 'salt123');
      });

      test('returns PinDataStateEmpty when pin salt is empty', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        when(() => mockPrefs.getString(SideswapSettings.pinSaltField))
            .thenReturn('');
        when(() => mockPrefs.getString(SideswapSettings.pinEncryptedDataField))
            .thenReturn('encryptedData123');
        when(() => mockPrefs.getString(SideswapSettings.pinIdentifierField))
            .thenReturn('pinId123');
        when(() => mockPrefs.getString(SideswapSettings.pinHmacField))
            .thenReturn('hmac123');
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.pinDataState, isA<PinDataStateEmpty>());
      });

      test('returns PinDataStateEmpty when pin identifier is empty', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        when(() => mockPrefs.getString(SideswapSettings.pinSaltField))
            .thenReturn('salt123');
        when(() => mockPrefs.getString(SideswapSettings.pinEncryptedDataField))
            .thenReturn('encryptedData123');
        when(() => mockPrefs.getString(SideswapSettings.pinIdentifierField))
            .thenReturn('');
        when(() => mockPrefs.getString(SideswapSettings.pinHmacField))
            .thenReturn('hmac123');
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.pinDataState, isA<PinDataStateEmpty>());
      });

      test('returns PinDataStateEmpty when pin encrypted data is empty', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        when(() => mockPrefs.getString(SideswapSettings.pinSaltField))
            .thenReturn('salt123');
        when(() => mockPrefs.getString(SideswapSettings.pinEncryptedDataField))
            .thenReturn('');
        when(() => mockPrefs.getString(SideswapSettings.pinIdentifierField))
            .thenReturn('pinId123');
        when(() => mockPrefs.getString(SideswapSettings.pinHmacField))
            .thenReturn('hmac123');
        when(
          () => mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
        ).thenReturn(null);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);

        expect(settings.pinDataState, isA<PinDataStateEmpty>());
      });
    });

    group('isRegistered', () {
      test('returns true when mnemonic is not empty', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        final mnemonicBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final encoded = base64.encode(mnemonicBytes);

        // Setup generic matchers FIRST
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);

        // Then specific overrides
        when(() => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField))
            .thenReturn(encoded);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final notifier = container.read(configurationProvider.notifier);
        final result = notifier.isRegistered();

        expect(result, true);
      });

      test('returns false when mnemonic is empty', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        when(() => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField))
            .thenReturn(null);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final notifier = container.read(configurationProvider.notifier);
        final result = notifier.isRegistered();

        expect(result, false);
      });

      test('returns false when mnemonic is empty string', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        when(() => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField))
            .thenReturn('');
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(false);
        when(() => mockPrefs.getInt(any())).thenReturn(0);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final notifier = container.read(configurationProvider.notifier);
        final result = notifier.isRegistered();

        expect(result, false);
      });
    });

    group('network type enum conversion', () {
      test('converts sideswap enum value correctly', () {
        final typeString = EnumToString.convertToString(
          SettingsNetworkType.sideswap,
        );
        final result = EnumToString.fromString(
          SettingsNetworkType.values,
          typeString,
        );
        expect(result, SettingsNetworkType.sideswap);
      });

      test('converts blockstream enum value correctly', () {
        final typeString = EnumToString.convertToString(
          SettingsNetworkType.blockstream,
        );
        final result = EnumToString.fromString(
          SettingsNetworkType.values,
          typeString,
        );
        expect(result, SettingsNetworkType.blockstream);
      });

      test('converts sideswapChina enum value correctly', () {
        final typeString = EnumToString.convertToString(
          SettingsNetworkType.sideswapChina,
        );
        final result = EnumToString.fromString(
          SettingsNetworkType.values,
          typeString,
        );
        expect(result, SettingsNetworkType.sideswapChina);
      });

      test('returns null for invalid enum value', () {
        final typeString = 'invalid_value';
        final result = EnumToString.fromString(
          SettingsNetworkType.values,
          typeString,
        );
        expect(result, null);
      });
    });

    group('base64 encoding and decoding', () {
      test('decodes empty base64 string to empty list', () {
        final encoded = base64.encode(Uint8List(0));
        final decoded = base64.decode(encoded);
        expect(decoded, Uint8List(0));
      });

      test('encodes and decodes mnemonic bytes correctly', () {
        final original = Uint8List.fromList([1, 2, 3, 4, 5, 255]);
        final encoded = base64.encode(original);
        final decoded = base64.decode(encoded);
        expect(decoded, original);
      });
    });

    group('JSON serialization', () {
      test('serializes and deserializes NetworkSettingsModelEmpty', () {
        final model = NetworkSettingsModelEmpty(
          settingsNetworkType: SettingsNetworkType.blockstream,
          host: 'example.com',
          port: 8080,
          useTls: true,
        );
        final json = model.toJson();
        final encoded = jsonEncode(json);
        final decoded = jsonDecode(encoded) as Map<String, dynamic>;
        final restored = NetworkSettingsModel.fromJson(decoded);
        expect(restored, isA<NetworkSettingsModelEmpty>());
      });

      test('serializes and deserializes StokrSettingsModel', () {
        final model = const StokrSettingsModel(firstRun: false);
        final json = model.toJson();
        final encoded = jsonEncode(json);
        final decoded = jsonDecode(encoded) as Map<String, dynamic>;
        final restored = StokrSettingsModel.fromJson(decoded);
        expect(restored.firstRun, false);
      });
    });

    group('sharedPreferencesProvider', () {
      test('throws when not overridden', () {
        final container = ProviderContainer();
        addTearDown(container.dispose);
        expect(
          () => container.read(sharedPreferencesProvider),
          throwsA(anything),
        );
      });
    });

    group('SideswapSettings factory', () {
      test('SideswapSettings() factory returns empty mnemonicEncrypted', () {
        final settings = SideswapSettings(
          jadeId: 'jade1',
          licenseAccepted: true,
          enableEndpoint: true,
          useBiometricProtection: false,
          env: 0,
          phoneKey: 'pk',
          phoneNumber: 'pn',
          usePinProtection: false,
          settingsNetworkType: SettingsNetworkType.sideswap,
          networkHost: '',
          networkPort: 0,
          networkUseTLS: false,
          knownNewReleaseBuild: 0,
          showAmpOnboarding: false,
          hideTxChainingPromptValue: false,
          useProxy: false,
        );
        expect(settings.mnemonicEncrypted.isEmpty, true);
      });
    });

    group('setSettings', () {
      test('replaces entire state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        final newSettings = SideswapSettings.empty(
          mnemonicEncrypted: Uint8List.fromList([1, 2, 3]),
          jadeId: 'new-jade',
        );
        notifier.setSettings(newSettings);
        await _flushAsync();

        expect(container.read(configurationProvider).jadeId, 'new-jade');
      });
    });

    group('setDefaultCurrency', () {
      test('updates defaultCurrency in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setDefaultCurrency('USD');
        await _flushAsync();

        expect(container.read(configurationProvider).defaultCurrency, 'USD');
        verify(
          () =>
              mockPrefs.setString(SideswapSettings.defaultCurrencyField, 'USD'),
        ).called(greaterThanOrEqualTo(1));
      });
    });

    group('setMnemonicEncrypted', () {
      test('updates mnemonicEncrypted in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        final bytes = Uint8List.fromList([10, 20, 30]);
        notifier.setMnemonicEncrypted(bytes);
        await _flushAsync();

        expect(container.read(configurationProvider).mnemonicEncrypted, bytes);
      });
    });

    group('setJadeId', () {
      test('updates jadeId in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setJadeId('jade-abc');
        await _flushAsync();

        expect(container.read(configurationProvider).jadeId, 'jade-abc');
      });
    });

    group('setLicenseAccepted', () {
      test('updates licenseAccepted in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setLicenseAccepted(true);
        await _flushAsync();

        expect(container.read(configurationProvider).licenseAccepted, true);
      });
    });

    group('setEnableEndpoint', () {
      test('updates enableEndpoint in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setEnableEndpoint(false);
        await _flushAsync();

        expect(container.read(configurationProvider).enableEndpoint, false);
      });
    });

    group('setUseBiometricProtection', () {
      test('updates useBiometricProtection in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setUseBiometricProtection(true);
        await _flushAsync();

        expect(
          container.read(configurationProvider).useBiometricProtection,
          true,
        );
      });
    });

    group('setEnv', () {
      test('updates env in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setEnv(2);
        await _flushAsync();

        expect(container.read(configurationProvider).env, 2);
      });
    });

    group('setPhoneKey', () {
      test('updates phoneKey in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setPhoneKey('key123');
        await _flushAsync();

        expect(container.read(configurationProvider).phoneKey, 'key123');
      });
    });

    group('setPhoneNumber', () {
      test('updates phoneNumber in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setPhoneNumber('+48123');
        await _flushAsync();

        expect(container.read(configurationProvider).phoneNumber, '+48123');
      });
    });

    group('setSettingsNetworkType', () {
      test('updates settingsNetworkType in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setSettingsNetworkType(SettingsNetworkType.blockstream);
        await _flushAsync();

        expect(
          container.read(configurationProvider).settingsNetworkType,
          SettingsNetworkType.blockstream,
        );
      });
    });

    group('setNetworkHost', () {
      test('updates networkHost in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setNetworkHost('myhost.com');
        await _flushAsync();

        expect(container.read(configurationProvider).networkHost, 'myhost.com');
      });
    });

    group('setNetworkPort', () {
      test('updates networkPort in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setNetworkPort(9090);
        await _flushAsync();

        expect(container.read(configurationProvider).networkPort, 9090);
      });
    });

    group('setNetworkUseTLS', () {
      test('updates networkUseTLS in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setNetworkUseTLS(true);
        await _flushAsync();

        expect(container.read(configurationProvider).networkUseTLS, true);
      });
    });

    group('setKnownNewReleaseBuild', () {
      test('updates knownNewReleaseBuild in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setKnownNewReleaseBuild(42);
        await _flushAsync();

        expect(container.read(configurationProvider).knownNewReleaseBuild, 42);
      });
    });

    group('setShowAmpOnboarding', () {
      test('updates showAmpOnboarding in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setShowAmpOnboarding(true);
        await _flushAsync();

        expect(container.read(configurationProvider).showAmpOnboarding, true);
      });
    });

    group('setNetworkSettingsModel', () {
      test(
        'updates networkSettingsModel with non-null value and writes JSON',
        () async {
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);
          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(null);
          when(() => mockPrefs.getInt(any())).thenReturn(null);

          final container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(mockPrefs),
              navigatorKeyProvider.overrideWithValue(
                GlobalKey<NavigatorState>(),
              ),
              localesProvider.overrideWithValue('en'),
            ],
          );
          addTearDown(container.dispose);

          final model = NetworkSettingsModelEmpty(
            settingsNetworkType: SettingsNetworkType.blockstream,
          );
          final notifier = container.read(configurationProvider.notifier);
          await _flushAsync();
          notifier.setNetworkSettingsModel(model);
          await _flushAsync();

          expect(
            container.read(configurationProvider).networkSettingsModel,
            isA<NetworkSettingsModelEmpty>(),
          );
          verify(
            () => mockPrefs.setString(
              SideswapSettings.networkSettingsModelField,
              any(),
            ),
          ).called(greaterThanOrEqualTo(1));
        },
      );

      test(
        'removes networkSettingsModel from prefs when set to null',
        () async {
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);
          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(null);
          when(() => mockPrefs.getInt(any())).thenReturn(null);

          final container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(mockPrefs),
              navigatorKeyProvider.overrideWithValue(
                GlobalKey<NavigatorState>(),
              ),
              localesProvider.overrideWithValue('en'),
            ],
          );
          addTearDown(container.dispose);

          final notifier = container.read(configurationProvider.notifier);
          await _flushAsync();
          notifier.setNetworkSettingsModel(null);
          await _flushAsync();

          verify(
            () => mockPrefs.remove(SideswapSettings.networkSettingsModelField),
          ).called(greaterThanOrEqualTo(1));
        },
      );
    });

    group('setStokrSettingsModel', () {
      test(
        'updates stokrSettingsModel with non-null value and writes JSON',
        () async {
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);
          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(null);
          when(() => mockPrefs.getInt(any())).thenReturn(null);

          final container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(mockPrefs),
              navigatorKeyProvider.overrideWithValue(
                GlobalKey<NavigatorState>(),
              ),
              localesProvider.overrideWithValue('en'),
            ],
          );
          addTearDown(container.dispose);

          const model = StokrSettingsModel(firstRun: false);
          final notifier = container.read(configurationProvider.notifier);
          await _flushAsync();
          notifier.setStokrSettingsModel(model);
          await _flushAsync();

          expect(
            container.read(configurationProvider).stokrSettingsModel?.firstRun,
            false,
          );
          verify(
            () => mockPrefs.setString(
              SideswapSettings.stokrSettingsModelField,
              any(),
            ),
          ).called(greaterThanOrEqualTo(1));
        },
      );

      test('removes stokrSettingsModel from prefs when set to null', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setStokrSettingsModel(null);
        await _flushAsync();

        verify(() => mockPrefs.remove(SideswapSettings.stokrSettingsModelField))
            .called(greaterThanOrEqualTo(1));
      });
    });

    group('_saveSettings after dispose', () {
      test(
        'finishes the pending save without reading the disposed state',
        () async {
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);
          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(null);
          when(() => mockPrefs.getInt(any())).thenReturn(null);

          final container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(mockPrefs),
              navigatorKeyProvider.overrideWithValue(
                GlobalKey<NavigatorState>(),
              ),
              localesProvider.overrideWithValue('en'),
            ],
          );
          final notifier = container.read(configurationProvider.notifier);
          await _flushAsync();
          // Drop anything the build wrote, so the assertions below can only be
          // satisfied by the save this test triggers.
          clearInteractions(mockPrefs);

          notifier.setHideTxChainingPromptValue(true);
          container.dispose();
          await _flushAsync();

          // The save started before dispose and ran to completion: both the
          // mutated key and the final write of the sequence
          // (`_setAutosignDomains`, which clears the key for the empty default)
          // reached SharedPreferences.
          verify(
            () => mockPrefs.setBool(
              SideswapSettings.hideTxChainingPromptField,
              true,
            ),
          ).called(greaterThanOrEqualTo(1));
          verify(() => mockPrefs.remove(SideswapSettings.autosignDomainsField))
              .called(greaterThanOrEqualTo(1));
        },
      );
    });

    group('_saveSettings serialization', () {
      test('persists the newest state last when two saves overlap', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);

        final phoneKeys = <String>[];
        when(() => mockPrefs.setString(SideswapSettings.phoneKeyField, any()))
            .thenAnswer((inv) async {
              phoneKeys.add(inv.positionalArguments[1] as String);
              return true;
            });

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );
        addTearDown(container.dispose);
        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        phoneKeys.clear();

        // Both mutations land in one synchronous turn, so the second save is
        // issued before the first has written anything.
        notifier.setPhoneKey('older');
        notifier.setPhoneKey('newer');
        for (var i = 0; i < 500 && phoneKeys.length < 2; i++) {
          await Future<void>.microtask(() {});
        }

        // Both saves ran, and the newer snapshot wrote last.
        expect(phoneKeys, ['older', 'newer']);
      });
    });

    group('autosignDomains', () {
      test('reads JSON map from preferences on build', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);
        when(() => mockPrefs.getString(SideswapSettings.autosignDomainsField))
            .thenReturn('{"a.example":true,"b.example":false}');

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);
        expect(settings.autosignDomains, {
          'a.example': true,
          'b.example': false,
        });
      });

      test('writes JSON and round-trips after notifier mutations', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);

        String? written;
        when(() => mockPrefs.setString(any(), any())).thenAnswer((inv) async {
          final field = inv.positionalArguments[0] as String;
          if (field == SideswapSettings.autosignDomainsField) {
            written = inv.positionalArguments[1] as String;
          }
          return true;
        });

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setAutosignForDomain('site.com', true);
        await _flushAsync();

        expect(written, isNotNull);
        expect(jsonDecode(written!) as Map<String, dynamic>, {
          'site.com': true,
        });

        notifier.setAutosignForDomain('site.com', false);
        await _flushAsync();

        verify(() => mockPrefs.remove(SideswapSettings.autosignDomainsField))
            .called(greaterThanOrEqualTo(1));
      });

      test('returns empty map when the stored JSON is not an object', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);
        when(() => mockPrefs.getString(SideswapSettings.autosignDomainsField))
            .thenReturn('["a.example"]');

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );
        addTearDown(container.dispose);

        final settings = container.read(configurationProvider);
        expect(settings.autosignDomains, <String, bool>{});
      });

      test('returns empty map when JSON is malformed', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);
        when(() => mockPrefs.getString(SideswapSettings.autosignDomainsField))
            .thenReturn('not-valid-json{{{');

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );

        final settings = container.read(configurationProvider);
        expect(settings.autosignDomains, <String, bool>{});
      });
    });

    group('setHideTxChainingPromptValue', () {
      test('updates hideTxChainingPromptValue in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setHideTxChainingPromptValue(true);
        await _flushAsync();

        expect(
          container.read(configurationProvider).hideTxChainingPromptValue,
          true,
        );
      });
    });

    group('setProxySettings', () {
      test('updates proxySettings in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final proxy = ProxySettings(host: 'proxy.test', port: 1080);
        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setProxySettings(proxy);
        await _flushAsync();

        expect(
          container.read(configurationProvider).proxySettings?.host,
          'proxy.test',
        );
        expect(container.read(configurationProvider).proxySettings?.port, 1080);
      });

      test('clears proxySettings in prefs when set to null', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setProxySettings(null);
        await _flushAsync();

        expect(container.read(configurationProvider).proxySettings, isNull);
      });
    });

    group('setUseProxy', () {
      test('updates useProxy in state', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
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

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        notifier.setUseProxy(true);
        await _flushAsync();

        expect(container.read(configurationProvider).useProxy, true);
      });
    });

    group('deleteConfig', () {
      test('resets state preserving env and clears prefs', () async {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField))
            .thenReturn(base64.encode(Uint8List.fromList([1, 2, 3])));
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);
        when(() => mockPrefs.getInt(SideswapSettings.envField)).thenReturn(1);

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
            localesProvider.overrideWithValue('en'),
          ],
        );
        addTearDown(container.dispose);

        final notifier = container.read(configurationProvider.notifier);
        await _flushAsync();
        await notifier.deleteConfig();
        await _flushAsync();

        final settings = container.read(configurationProvider);
        expect(settings.mnemonicEncrypted.isEmpty, true);
        expect(settings.env, 1);
        expect(settings.showAmpOnboarding, false);
      });
    });

    group('_settingsNetworkType zh locale with context', () {
      testWidgets(
        'returns sideswapChina when typeString is null, lang is zh, and context is non-null',
        (tester) async {
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);
          when(
            () =>
                mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
          ).thenReturn(null);
          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(false);
          when(() => mockPrefs.getInt(any())).thenReturn(0);

          final navigatorKey = GlobalKey<NavigatorState>();
          late ProviderContainer container;

          await tester.pumpWidget(
            MaterialApp(
              navigatorKey: navigatorKey,
              home: Builder(
                builder: (context) {
                  container = ProviderContainer(
                    overrides: [
                      sharedPreferencesProvider.overrideWithValue(mockPrefs),
                      navigatorKeyProvider.overrideWithValue(navigatorKey),
                      localesProvider.overrideWithValue('zh'),
                    ],
                  );
                  return const SizedBox();
                },
              ),
            ),
          );

          addTearDown(container.dispose);

          // Use listen to keep provider alive and prevent pending auto-dispose timers
          final sub = container.listen(configurationProvider, (prev, next) {});
          addTearDown(sub.close);
          await tester.pump();

          expect(
            sub.read().settingsNetworkType,
            SettingsNetworkType.sideswapChina,
          );
        },
      );
    });
  });

  group('PIN record', () {
    late FakeSharedPreferences prefs;

    setUp(() {
      prefs = FakeSharedPreferences();
    });

    const blobA = PinDataStateData(
      salt: 'salt-a',
      encryptedData: 'enc-a',
      pinIdentifier: 'id-a',
      hmac: 'hmac-a',
    );

    const blobB = PinDataStateData(
      salt: 'salt-b',
      encryptedData: 'enc-b',
      pinIdentifier: 'id-b',
      hmac: 'hmac-b',
    );

    /// A store holding [blob], as an earlier run of the app would have left it.
    FakeSharedPreferences storeHolding(
      PinDataStateData blob, {
      bool usePinProtection = true,
    }) {
      return FakeSharedPreferences({
        SideswapSettings.pinSaltField: blob.salt,
        SideswapSettings.pinEncryptedDataField: blob.encryptedData,
        SideswapSettings.pinIdentifierField: blob.pinIdentifier,
        SideswapSettings.pinHmacField: blob.hmac,
        SideswapSettings.usePinProtectionField: usePinProtection,
      });
    }

    ProviderListener<SideswapSettings> listenerOn(ProviderContainer container) {
      final listener = ProviderListener<SideswapSettings>();
      container.listen(configurationProvider, listener.call);
      return listener;
    }

    /// The state the listener saw, failing if it saw more than one. A
    /// `ProviderListener` captures a `(previous, next)` pair per call, so two
    /// captured values are one call.
    SideswapSettings onlyStateChange(
      ProviderListener<SideswapSettings> listener,
    ) {
      final captured = verify(
        () => listener(captureAny(), captureAny()),
      ).captured;
      expect(captured.length, 2, reason: 'exactly one state change');
      return captured[1] as SideswapSettings;
    }

    test(
      'activating emits one state change carrying the blob, the flag and biometric off',
      () async {
        final container = settingsContainer(prefs);
        final listener = listenerOn(container);

        container
            .read(configurationProvider.notifier)
            .activatePinProtection(blobA);
        await prefs.settle();

        final next = onlyStateChange(listener);
        expect(next.pinDataState, blobA);
        expect(next.usePinProtection, true);
        expect(next.useBiometricProtection, false);
      },
    );

    test('activating stores a blob that survives a rebuild', () async {
      final container = settingsContainer(prefs);
      container
          .read(configurationProvider.notifier)
          .activatePinProtection(blobA);
      await prefs.settle();

      final reloaded = reloadSettings(prefs);

      expect(reloaded.usePinProtection, true);
      expect(reloaded.pinDataState, blobA);
    });

    test('a new blob replaces a stored one', () async {
      final seeded = storeHolding(blobA);

      settingsContainer(seeded)
          .read(configurationProvider.notifier)
          .activatePinProtection(blobB);
      await seeded.settle();

      final reloaded = reloadSettings(seeded);

      expect(reloaded.pinDataState, blobB);
      expect(reloaded.usePinProtection, true);
    });

    test('an unchanged blob is not re-written', () async {
      final container = settingsContainer(prefs);
      container
          .read(configurationProvider.notifier)
          .activatePinProtection(blobA);
      await prefs.settle();

      const pinKeys = [
        SideswapSettings.pinSaltField,
        SideswapSettings.pinEncryptedDataField,
        SideswapSettings.pinIdentifierField,
        SideswapSettings.pinHmacField,
      ];
      final writesAfterActivating = {
        for (final key in pinKeys) key: prefs.writeCount(key),
      };

      container.read(configurationProvider.notifier).setJadeId('jade-1');
      await prefs.settle();

      expect(
        {for (final key in pinKeys) key: prefs.writeCount(key)},
        writesAfterActivating,
      );
      expect(reloadSettings(prefs).pinDataState, blobA);
    });

    test('a blob differing only in its hmac is written', () async {
      final seeded = storeHolding(blobA);
      final rekeyed = blobA.copyWith(hmac: 'hmac-other');

      settingsContainer(seeded)
          .read(configurationProvider.notifier)
          .activatePinProtection(rekeyed);
      await seeded.settle();

      expect(reloadSettings(seeded).pinDataState, rekeyed);
    });

    test(
      'a write interrupted at the flag leaves the fresh blob, not the stale one',
      () async {
        // The flag already stands, which is the only starting state where a
        // raised flag is a hazard: whatever the interruption leaves, the blob
        // under that flag must be the fresh one.
        final seeded = storeHolding(blobA);
        // Let the round that the initial build fires finish first, so the
        // stall lands inside the enable round and nowhere else.
        final notifier = settingsContainer(
          seeded,
        ).read(configurationProvider.notifier);
        await seeded.settle();

        seeded.hangOn(SideswapSettings.usePinProtectionField);
        notifier.activatePinProtection(blobB);
        await seeded.reachedHangKey;

        final reloaded = reloadSettings(seeded);

        expect(
          reloaded.pinDataState,
          blobB,
          reason: 'the flag stands over the stale blob',
        );
      },
    );

    test(
      'deactivating drops the flag with the mnemonic first, then the blob',
      () async {
        final container = settingsContainer(prefs);
        final notifier = container.read(configurationProvider.notifier);
        notifier.activatePinProtection(blobA);
        await prefs.settle();

        final listener = listenerOn(container);
        final mnemonicEncrypted = Uint8List.fromList([1, 2, 3]);

        notifier.deactivatePinProtection(mnemonicEncrypted: mnemonicEncrypted);
        await prefs.settle();

        // Two state changes, in this order. `ProviderListener` captures a
        // `(previous, next)` pair per call, so four captured values are two.
        final captured = verify(
          () => listener(captureAny(), captureAny()),
        ).captured;
        expect(captured.length, 4, reason: 'exactly two state changes');

        final roundOne = captured[1] as SideswapSettings;
        expect(roundOne.usePinProtection, false);
        expect(roundOne.mnemonicEncrypted, mnemonicEncrypted);
        expect(
          roundOne.pinDataState,
          blobA,
          reason: 'the blob goes in the second round, not this one',
        );

        final roundTwo = captured[3] as SideswapSettings;
        expect(roundTwo.pinDataState, isNull);
      },
    );

    test('deactivating removes every PIN key', () async {
      final container = settingsContainer(prefs);
      final notifier = container.read(configurationProvider.notifier);
      notifier.activatePinProtection(blobA);
      await prefs.settle();

      notifier.deactivatePinProtection(
        mnemonicEncrypted: Uint8List.fromList([1, 2, 3]),
      );
      await prefs.settle();

      expect(
        prefs.snapshot.keys,
        isNot(contains(SideswapSettings.pinSaltField)),
      );
      expect(
        prefs.snapshot.keys,
        isNot(contains(SideswapSettings.pinEncryptedDataField)),
      );
      expect(
        prefs.snapshot.keys,
        isNot(contains(SideswapSettings.pinIdentifierField)),
      );
      expect(
        prefs.snapshot.keys,
        isNot(contains(SideswapSettings.pinHmacField)),
      );

      expect(reloadSettings(prefs).pinDataState, isA<PinDataStateEmpty>());
    });

    test(
      'activating biometric protection emits one state change that drops the PIN flag',
      () async {
        final container = settingsContainer(prefs);
        final notifier = container.read(configurationProvider.notifier);
        notifier.activatePinProtection(blobA);
        await prefs.settle();

        final listener = listenerOn(container);

        notifier.activateBiometricProtection();
        await prefs.settle();

        onlyStateChange(listener);

        final reloaded = reloadSettings(prefs);
        expect(reloaded.useBiometricProtection, true);
        expect(reloaded.usePinProtection, false);
      },
    );

    // The state to fear is one state: `usePinProtection == true` beside a blob
    // that is missing or stale, because `sendDecryptPin` then returns without
    // sending and the unlock screen waits for a reply nobody will send.
    //
    // Three members of `Configuration` write `usePinProtection`
    // (`activatePinProtection`, `deactivatePinProtection`,
    // `activateBiometricProtection`), and two more replace the whole state
    // (`setSettings`, `deleteConfig`). This drives all five and asserts the
    // invariant against what a restart would load, after every step.
    test('no sequence ends with the flag raised over a missing blob', () async {
      /// Persists, then holds the invariant against what a restart would load.
      /// [whileFlagStands] is the blob that must be the one loaded if PIN
      /// protection is on, or null if it must be off — identity, not mere
      /// presence, because a stale blob is as fatal as a missing one.
      Future<SideswapSettings> checkpoint(
        String step,
        PinDataStateData? whileFlagStands,
      ) async {
        await prefs.settle();
        final reloaded = reloadSettings(prefs);
        if (reloaded.usePinProtection) {
          expect(
            reloaded.pinDataState,
            whileFlagStands,
            reason: 'after $step: the flag stands over the wrong blob',
          );
        }
        return reloaded;
      }

      final container = settingsContainer(prefs);
      final notifier = container.read(configurationProvider.notifier);

      notifier.activatePinProtection(blobA);
      await checkpoint('activatePinProtection(A)', blobA);

      notifier.deactivatePinProtection(
        mnemonicEncrypted: Uint8List.fromList([1]),
      );
      await checkpoint('deactivatePinProtection', null);

      notifier.activatePinProtection(blobB);
      final afterSecondEnable = await checkpoint('activatePinProtection(B)', blobB);
      expect(
        afterSecondEnable.pinDataState,
        blobB,
        reason: 'the second PIN is the one that unlocks the wallet',
      );

      notifier.setSettings(
        container.read(configurationProvider).copyWith(jadeId: 'jade-2'),
      );
      await checkpoint('setSettings', blobB);

      notifier.activateBiometricProtection();
      await checkpoint('activateBiometricProtection', null);

      notifier.activatePinProtection(blobA);
      await checkpoint('activatePinProtection(A) again', blobA);

      await notifier.deleteConfig();
      final afterDelete = await checkpoint('deleteConfig', null);
      expect(afterDelete.usePinProtection, false);
      expect(afterDelete.pinDataState, isA<PinDataStateEmpty>());
    });

    test('deactivating clears the blob as well, in a second round', () async {
      final container = settingsContainer(prefs);
      final notifier = container.read(configurationProvider.notifier);
      notifier.activatePinProtection(blobA);
      await prefs.settle();

      notifier.deactivatePinProtection(
        mnemonicEncrypted: Uint8List.fromList([1, 2, 3]),
      );
      await prefs.settle();

      final reloaded = reloadSettings(prefs);
      expect(reloaded.usePinProtection, false);
      expect(reloaded.pinDataState, isA<PinDataStateEmpty>());
      expect(reloaded.mnemonicEncrypted, Uint8List.fromList([1, 2, 3]));
    });

    test(
      'a write interrupted between the two disable rounds keeps the flag down',
      () async {
        final container = settingsContainer(prefs);
        final notifier = container.read(configurationProvider.notifier);
        notifier.activatePinProtection(blobA);
        await prefs.settle();

        // The second round's first act is removing a blob key. Stalling there
        // leaves round one landed and round two not started.
        prefs.hangOn(SideswapSettings.pinEncryptedDataField);
        notifier.deactivatePinProtection(
          mnemonicEncrypted: Uint8List.fromList([1, 2, 3]),
        );
        await prefs.reachedHangKey;

        final reloaded = reloadSettings(prefs);
        expect(
          reloaded.usePinProtection,
          false,
          reason: 'the blob went before the flag did',
        );
        expect(reloaded.mnemonicEncrypted, Uint8List.fromList([1, 2, 3]));
      },
    );

    // The three fields the configuration requires. A blob missing any of them
    // is stored as no blob at all, so activating on one would raise the flag
    // over nothing. `PinHelper.onPinData` rejects these too, and reports the
    // failure to the user; this is the guarantee the notifier owes on its own.
    for (final (field, blob) in [
      ('salt', blobA.copyWith(salt: '')),
      ('encryptedData', blobA.copyWith(encryptedData: '')),
      ('pinIdentifier', blobA.copyWith(pinIdentifier: '')),
    ]) {
      test('activating on a blob with no $field raises no flag', () async {
        final container = settingsContainer(prefs);
        container
            .read(configurationProvider.notifier)
            .activatePinProtection(blob);
        await prefs.settle();

        expect(container.read(configurationProvider).usePinProtection, false);
        expect(reloadSettings(prefs).usePinProtection, false);
      });
    }

    test('setSettings cannot raise the flag or move the blob', () async {
      final container = settingsContainer(prefs);
      final notifier = container.read(configurationProvider.notifier);
      await prefs.settle();

      notifier.setSettings(
        container.read(configurationProvider).copyWith(
          usePinProtection: true,
          pinDataState: null,
        ),
      );
      await prefs.settle();

      expect(container.read(configurationProvider).usePinProtection, false);
      expect(reloadSettings(prefs).usePinProtection, false);
    });

    test('setSettings cannot replace the blob under a raised flag', () async {
      final container = settingsContainer(prefs);
      final notifier = container.read(configurationProvider.notifier);
      notifier.activatePinProtection(blobA);
      await prefs.settle();

      notifier.setSettings(
        container.read(configurationProvider).copyWith(pinDataState: blobB),
      );
      await prefs.settle();

      expect(reloadSettings(prefs).pinDataState, blobA);
    });
  });

  group('desktop window geometry', () {
    late FakeSharedPreferences prefs;

    setUp(() {
      prefs = FakeSharedPreferences();
    });

    const geometry = DesktopWindowGeometry(
      left: 100,
      top: 200,
      width: 1088,
      height: 880,
      maximized: true,
      displayId: 'display-1',
    );

    test('no stored value gives null', () {
      final settings = settingsContainer(prefs).read(configurationProvider);

      expect(settings.desktopWindowGeometry, isNull);
    });

    test('round trip preserves the geometry', () async {
      final container = settingsContainer(prefs);

      container
          .read(configurationProvider.notifier)
          .setDesktopWindowGeometry(geometry);
      await prefs.settle();

      expect(
        container.read(configurationProvider).desktopWindowGeometry,
        geometry,
      );
      expect(reloadSettings(prefs).desktopWindowGeometry, geometry);
    });

    test('clearing removes the stored key', () async {
      final notifier = settingsContainer(
        prefs,
      ).read(configurationProvider.notifier);

      notifier.setDesktopWindowGeometry(geometry);
      await prefs.settle();

      notifier.setDesktopWindowGeometry(null);
      await prefs.settle();

      expect(
        prefs.snapshot.containsKey(
          SideswapSettings.desktopWindowGeometryField,
        ),
        false,
      );
    });

    test('corrupt stored text gives null', () {
      final seeded = FakeSharedPreferences({
        SideswapSettings.desktopWindowGeometryField: 'not json',
      });

      final settings = settingsContainer(seeded).read(configurationProvider);

      expect(settings.desktopWindowGeometry, isNull);
    });

    test('deleteConfig keeps the geometry', () async {
      final container = settingsContainer(prefs);
      final notifier = container.read(configurationProvider.notifier);

      notifier.setDesktopWindowGeometry(geometry);
      await prefs.settle();

      await notifier.deleteConfig();
      await prefs.settle();

      final settings = container.read(configurationProvider);
      expect(settings.desktopWindowGeometry, geometry);
      expect(settings.mnemonicEncrypted.isEmpty, true);
    });
  });
}
