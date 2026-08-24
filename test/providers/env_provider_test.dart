import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';
import 'package:sideswap_logger/custom_logger.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void _setupMockSharedPreferences(MockSharedPreferences mockPrefs) {
  when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setString(any(), any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setBool(any(), any())).thenAnswer((_) async => true);
  when(() => mockPrefs.setInt(any(), any())).thenAnswer((_) async => true);
  when(() => mockPrefs.getString(any())).thenReturn(null);
  when(() => mockPrefs.getBool(any())).thenReturn(null);
  when(() => mockPrefs.getInt(any())).thenReturn(null);
}

/// Creates a container and keeps envProvider alive via a listener.
/// Returns (container, subscription) — caller must close subscription before
/// disposing container (or just let GC handle it).
ProviderContainer _createContainer({
  MockSharedPreferences? mockPrefs,
  int initialEnv = 0,
}) {
  final prefs = mockPrefs ?? MockSharedPreferences();
  _setupMockSharedPreferences(prefs);
  when(() => prefs.getInt(SideswapSettings.envField)).thenReturn(initialEnv);

  return ProviderContainer(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      navigatorKeyProvider.overrideWithValue(GlobalKey<NavigatorState>()),
      localesProvider.overrideWithValue('en'),
    ],
  );
}

/// Drains microtask queue so configurationProvider's async _saveSettings
/// completes before the container is disposed.
Future<void> _flushAsync() async {
  for (var i = 0; i < 30; i++) {
    await Future.microtask(() {});
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(Uint8List.fromList([]));
    registerFallbackValue(SideswapSettings.empty(
      mnemonicEncrypted: Uint8List(0),
    ));
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
  });

  group('Env', () {
    group('build', () {
      test('returns env value from configurationProvider', () {
        final container = _createContainer(initialEnv: 5);
        final sub = container.listen(envProvider, (_, _) {});
        addTearDown(() async {
          sub.close();
          await _flushAsync();
          container.dispose();
        });

        expect(container.read(envProvider), 5);
      });
    });

    group('setEnv', () {
      test('delegates to configurationProvider notifier', () {
        final container = _createContainer(initialEnv: SIDESWAP_ENV_PROD);
        // Keep envProvider alive with a listener so auto-dispose doesn't fire
        final sub = container.listen(envProvider, (_, _) {});
        addTearDown(() async {
          sub.close();
          await _flushAsync();
          container.dispose();
        });

        container.read(envProvider.notifier).setEnv(SIDESWAP_ENV_TESTNET);

        expect(
          container.read(configurationProvider).env,
          SIDESWAP_ENV_TESTNET,
        );
      });
    });

    group('isTestnet', () {
      final cases = [
        (env: SIDESWAP_ENV_TESTNET, expected: true),
        (env: SIDESWAP_ENV_LOCAL_TESTNET, expected: true),
        (env: SIDESWAP_ENV_PROD, expected: false),
        (env: SIDESWAP_ENV_LOCAL_LIQUID, expected: false),
        (env: 999, expected: false),
      ];
      for (final c in cases) {
        test('returns ${c.expected} for env ${c.env}', () {
          final container = _createContainer(initialEnv: c.env);
          final sub = container.listen(envProvider, (_, _) {});
          addTearDown(() async {
            sub.close();
            await _flushAsync();
            container.dispose();
          });

          expect(container.read(envProvider.notifier).isTestnet(), c.expected);
        });
      }
    });
  });
}
