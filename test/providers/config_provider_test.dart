import 'dart:convert';
import 'dart:typed_data';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/network_settings_providers.dart';
import 'package:sideswap/providers/stokr_providers.dart';
import 'package:sideswap/providers/proxy_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

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

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
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
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
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

      test(
        'returns sideswap as default when network type is null and locale is not zh',
        () {
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
        },
      );

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
        when(
          () => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField),
        ).thenReturn(encoded);

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

      test(
        'returns NetworkSettingsModelEmpty on network settings JSON decode error',
        () {
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);

          // Register any() FIRST, then specific overrides take precedence
          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(false);
          when(() => mockPrefs.getInt(any())).thenReturn(0);
          when(
            () =>
                mockPrefs.getString(SideswapSettings.networkSettingsModelField),
          ).thenReturn('invalid{{{');
          // Provide a valid settingsNetworkType to cover notNullString? branch (line 519)
          when(
            () =>
                mockPrefs.getString(SideswapSettings.settingsNetworkTypeField),
          ).thenReturn(
            EnumToString.convertToString(SettingsNetworkType.sideswap),
          );

          final container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(mockPrefs),
              navigatorKeyProvider.overrideWithValue(
                GlobalKey<NavigatorState>(),
              ),
              localesProvider.overrideWithValue('en'),
            ],
          );

          final settings = container.read(configurationProvider);

          expect(
            settings.networkSettingsModel,
            isA<NetworkSettingsModelEmpty>(),
          );
        },
      );

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
        when(
          () => mockPrefs.getString(SideswapSettings.proxyHostField),
        ).thenReturn('proxy.example.com');
        when(
          () => mockPrefs.getInt(SideswapSettings.proxyPortField),
        ).thenReturn(3128);
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

        when(
          () => mockPrefs.getString(SideswapSettings.proxyHostField),
        ).thenReturn(null);
        when(
          () => mockPrefs.getInt(SideswapSettings.proxyPortField),
        ).thenReturn(null);
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
        when(
          () => mockPrefs.getString(SideswapSettings.pinSaltField),
        ).thenReturn('salt123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinEncryptedDataField),
        ).thenReturn('encryptedData123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinIdentifierField),
        ).thenReturn('pinId123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinHmacField),
        ).thenReturn('hmac123');
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

        when(
          () => mockPrefs.getString(SideswapSettings.pinSaltField),
        ).thenReturn('');
        when(
          () => mockPrefs.getString(SideswapSettings.pinEncryptedDataField),
        ).thenReturn('encryptedData123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinIdentifierField),
        ).thenReturn('pinId123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinHmacField),
        ).thenReturn('hmac123');
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

        when(
          () => mockPrefs.getString(SideswapSettings.pinSaltField),
        ).thenReturn('salt123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinEncryptedDataField),
        ).thenReturn('encryptedData123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinIdentifierField),
        ).thenReturn('');
        when(
          () => mockPrefs.getString(SideswapSettings.pinHmacField),
        ).thenReturn('hmac123');
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

        when(
          () => mockPrefs.getString(SideswapSettings.pinSaltField),
        ).thenReturn('salt123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinEncryptedDataField),
        ).thenReturn('');
        when(
          () => mockPrefs.getString(SideswapSettings.pinIdentifierField),
        ).thenReturn('pinId123');
        when(
          () => mockPrefs.getString(SideswapSettings.pinHmacField),
        ).thenReturn('hmac123');
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
        when(
          () => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField),
        ).thenReturn(encoded);

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

        when(
          () => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField),
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

        final notifier = container.read(configurationProvider.notifier);
        final result = notifier.isRegistered();

        expect(result, false);
      });

      test('returns false when mnemonic is empty string', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);

        when(
          () => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField),
        ).thenReturn('');
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

    group('setUsePinProtection', () {
      test('updates usePinProtection in state', () async {
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
        notifier.setUsePinProtection(true);
        await _flushAsync();

        expect(container.read(configurationProvider).usePinProtection, true);
      });
    });

    group('setPinData', () {
      test(
        'updates pinDataState with valid PinDataStateData and writes to prefs when prefs empty',
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
          final pinData = PinDataStateData(
            salt: 'salt123',
            encryptedData: 'enc123',
            pinIdentifier: 'id123',
            hmac: 'hmac123',
          );
          notifier.setPinData(pinData);
          await _flushAsync();

          expect(
            container.read(configurationProvider).pinDataState,
            isA<PinDataStateData>(),
          );
          verify(
            () => mockPrefs.setString(SideswapSettings.pinSaltField, 'salt123'),
          ).called(greaterThanOrEqualTo(1));
          verify(
            () => mockPrefs.setString(
              SideswapSettings.pinEncryptedDataField,
              'enc123',
            ),
          ).called(greaterThanOrEqualTo(1));
          verify(
            () => mockPrefs.setString(
              SideswapSettings.pinIdentifierField,
              'id123',
            ),
          ).called(greaterThanOrEqualTo(1));
        },
      );

      test(
        'skips writing to prefs when valid pin data already exists in prefs',
        () async {
          final mockPrefs = MockSharedPreferences();
          _setupMockSharedPreferences(mockPrefs);
          // Set wildcard first, then specific stubs override (Mocktail: last wins)
          when(() => mockPrefs.getString(any())).thenReturn(null);
          when(() => mockPrefs.getBool(any())).thenReturn(null);
          when(() => mockPrefs.getInt(any())).thenReturn(null);
          // Prefs already has full pin data — set after wildcard so they take precedence
          when(
            () => mockPrefs.getString(SideswapSettings.pinSaltField),
          ).thenReturn('existing-salt');
          when(
            () => mockPrefs.getString(SideswapSettings.pinEncryptedDataField),
          ).thenReturn('existing-enc');
          when(
            () => mockPrefs.getString(SideswapSettings.pinIdentifierField),
          ).thenReturn('existing-id');
          when(
            () => mockPrefs.getString(SideswapSettings.pinHmacField),
          ).thenReturn('existing-hmac');

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
          final pinData = PinDataStateData(
            salt: 'new-salt',
            encryptedData: 'new-enc',
            pinIdentifier: 'new-id',
            hmac: 'new-hmac',
          );
          notifier.setPinData(pinData);
          await _flushAsync();

          expect(
            container.read(configurationProvider).pinDataState,
            isA<PinDataStateData>(),
          );
          // pin salt should NOT be written with 'new-salt' because prefs already has data
          verifyNever(
            () =>
                mockPrefs.setString(SideswapSettings.pinSaltField, 'new-salt'),
          );
        },
      );

      test('clears prefs when pinData is null', () async {
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
        notifier.setPinData(null);
        await _flushAsync();

        verify(
          () => mockPrefs.remove(SideswapSettings.pinEncryptedDataField),
        ).called(greaterThanOrEqualTo(1));
        verify(
          () => mockPrefs.remove(SideswapSettings.pinIdentifierField),
        ).called(greaterThanOrEqualTo(1));
        verify(
          () => mockPrefs.remove(SideswapSettings.pinSaltField),
        ).called(greaterThanOrEqualTo(1));
        verify(
          () => mockPrefs.remove(SideswapSettings.pinHmacField),
        ).called(greaterThanOrEqualTo(1));
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

        verify(
          () => mockPrefs.remove(SideswapSettings.stokrSettingsModelField),
        ).called(greaterThanOrEqualTo(1));
      });
    });

    group('autosignDomains', () {
      test('reads JSON map from preferences on build', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);
        when(
          () => mockPrefs.getString(SideswapSettings.autosignDomainsField),
        ).thenReturn('{"a.example":true,"b.example":false}');

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
        expect(
          jsonDecode(written!) as Map<String, dynamic>,
          {'site.com': true},
        );

        notifier.setAutosignForDomain('site.com', false);
        await _flushAsync();

        verify(
          () => mockPrefs.remove(SideswapSettings.autosignDomainsField),
        ).called(greaterThanOrEqualTo(1));
      });

      test('returns empty map when JSON is malformed', () {
        final mockPrefs = MockSharedPreferences();
        _setupMockSharedPreferences(mockPrefs);
        when(() => mockPrefs.getString(any())).thenReturn(null);
        when(() => mockPrefs.getBool(any())).thenReturn(null);
        when(() => mockPrefs.getInt(any())).thenReturn(null);
        when(
          () => mockPrefs.getString(SideswapSettings.autosignDomainsField),
        ).thenReturn('not-valid-json{{{');

        final container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(mockPrefs),
            navigatorKeyProvider.overrideWithValue(
              GlobalKey<NavigatorState>(),
            ),
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
        when(
          () => mockPrefs.getString(SideswapSettings.mnemonicEncryptedField),
        ).thenReturn(base64.encode(Uint8List.fromList([1, 2, 3])));
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
}
