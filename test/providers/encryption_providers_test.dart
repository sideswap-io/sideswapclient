import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/providers/encryption_providers.dart';

void main() {
  group('encryptionRepository', () {
    test('returns EncryptionRepository instance', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final result = container.read(encryptionRepositoryProvider);

      expect(result, isA<EncryptionRepository>());
      expect(result, isA<AbstractEncryptionRepository>());
    });

    test('returns same instance on multiple reads (keepAlive)', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final first = container.read(encryptionRepositoryProvider);
      final second = container.read(encryptionRepositoryProvider);

      expect(identical(first, second), true);
    });

    test('respects overrideWithValue in container', () {
      final mockRepo = MockEncryptionRepository();
      final container = ProviderContainer.test(
        overrides: [
          encryptionRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(encryptionRepositoryProvider);

      expect(identical(result, mockRepo), true);
    });
  });
}

class MockEncryptionRepository extends AbstractEncryptionRepository {
  @override
  bool isPluginAvailable() => false;

  @override
  Future<bool> appResetRequired({
    required bool hasEncryptedMnemonic,
    required bool usePinProtection,
  }) async =>
      false;

  @override
  Future<bool> canAuthenticate() async => false;

  @override
  Future<Uint8List> encryptBiometric(String data) async => Uint8List(0);

  @override
  Future<String> decryptBiometric(Uint8List data) async => '';

  @override
  Future<Uint8List> encryptFallback(String data) async => Uint8List(0);

  @override
  Future<String> decryptFallback(Uint8List data) async => '';
}
