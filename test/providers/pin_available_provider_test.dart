import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/pin_available_provider.dart';

import '../helpers/fake_configuration.dart';

SideswapSettings _settings({bool usePinProtection = false}) =>
    SideswapSettings.empty(
      mnemonicEncrypted: Uint8List.fromList([]),
      usePinProtection: usePinProtection,
    );

void main() {
  group('pinAvailable', () {
    test('returns true when usePinProtection is true', () {
      final container = ProviderContainer.test(overrides: [
        configurationProvider.overrideWith(() => FakeConfiguration(_settings(usePinProtection: true))),
      ]);

      expect(container.read(pinAvailableProvider), isTrue);
    });

    test('returns false when usePinProtection is false', () {
      final container = ProviderContainer.test(overrides: [
        configurationProvider.overrideWith(() => FakeConfiguration(_settings(usePinProtection: false))),
      ]);

      expect(container.read(pinAvailableProvider), isFalse);
    });
  });

  group('isPinAvailable', () {
    test('returns false when jade wallet is active', () {
      final container = ProviderContainer.test(overrides: [
        isJadeWalletProvider.overrideWithValue(true),
      ]);

      expect(container.read(isPinAvailableProvider), isFalse);
    });

    test('returns true when jade wallet is not active', () {
      final container = ProviderContainer.test(overrides: [
        isJadeWalletProvider.overrideWithValue(false),
      ]);

      expect(container.read(isPinAvailableProvider), isTrue);
    });
  });
}
