import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/providers/biometric_available_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/encryption_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';

class MockEncryptionRepository extends Mock implements AbstractEncryptionRepository {}

void main() {
  group('isBiometricEnabledProvider', () {
    test('returns true when configuration has useBiometricProtection true', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        useBiometricProtection: true,
      );
      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWithValue(settings),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isBiometricEnabledProvider), true);
    });

    test('returns false when configuration has useBiometricProtection false', () {
      final settings = SideswapSettings.empty(
        mnemonicEncrypted: Uint8List(0),
        useBiometricProtection: false,
      );
      final container = ProviderContainer.test(
        overrides: [
          configurationProvider.overrideWithValue(settings),
        ],
      );
      addTearDown(container.dispose);

      expect(container.read(isBiometricEnabledProvider), false);
    });
  });

  group('isBiometricAvailableProvider', () {
    test('returns false when isJadeWallet is true', () async {
      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(true),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(isBiometricAvailableProvider.future);
      expect(result, false);
    });

    test('returns true when encryption repository reports canAuthenticate true',
        () async {
      final mockRepo = MockEncryptionRepository();
      when(() => mockRepo.canAuthenticate()).thenAnswer((_) async => true);

      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(false),
          encryptionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(isBiometricAvailableProvider.future);
      expect(result, true);
      verify(() => mockRepo.canAuthenticate()).called(1);
    });

    test('returns false when encryption repository reports canAuthenticate false',
        () async {
      final mockRepo = MockEncryptionRepository();
      when(() => mockRepo.canAuthenticate()).thenAnswer((_) async => false);

      final container = ProviderContainer.test(
        overrides: [
          isJadeWalletProvider.overrideWithValue(false),
          encryptionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(isBiometricAvailableProvider.future);
      expect(result, false);
      verify(() => mockRepo.canAuthenticate()).called(1);
    });
  });
}
