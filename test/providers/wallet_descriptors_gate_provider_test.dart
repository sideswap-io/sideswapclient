import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/encryption_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_descriptors_gate_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';
import '../helpers/fake_configuration.dart';
import '../helpers/test_utils.dart';

class MockPinProtectionHelper extends Mock implements PinProtectionHelper {}

class MockJadeLockRepository extends Mock
    implements AbstractJadeLockRepository {}

class MockEncryptionRepository extends Mock
    implements AbstractEncryptionRepository {}

class MockSideswapWallet extends Mock implements SideswapWallet {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  late MockPinProtectionHelper pin;
  late MockJadeLockRepository jade;
  late MockEncryptionRepository encryption;
  late MockSideswapWallet wallet;

  setUp(() {
    pin = MockPinProtectionHelper();
    jade = MockJadeLockRepository();
    encryption = MockEncryptionRepository();
    wallet = MockSideswapWallet();
  });

  final encryptedMnemonic = Uint8List.fromList([1, 2, 3]);
  const storedMnemonic = 'abandon ability able about above absent';

  ProviderContainer makeContainer({
    bool usePinProtection = false,
    bool useBiometricProtection = false,
    bool isJadeWallet = false,
  }) {
    final container = ProviderContainer.test(
      overrides: [
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(
              mnemonicEncrypted: encryptedMnemonic,
              usePinProtection: usePinProtection,
              useBiometricProtection: useBiometricProtection,
            ),
          ),
        ),
        pinProtectionHelperProvider.overrideWithValue(pin),
        isJadeWalletProvider.overrideWithValue(isJadeWallet),
        jadeLockRepositoryProvider.overrideWithValue(jade),
        encryptionRepositoryProvider.overrideWithValue(encryption),
        walletProvider.overrideWithValue(wallet),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  /// The software-wallet branch reads the wallet's current in-memory mnemonic
  /// through the public `mnemonicRepository` field.
  void stubWalletMnemonic(String value) {
    final repository = MnemonicRepository()..setMnemonic(value);
    when(() => wallet.mnemonicRepository).thenReturn(repository);
  }

  group('WalletDescriptorsGate', () {
    group('app PIN branch', () {
      test('navigates when the PIN blockade is unlocked', () async {
        when(() => pin.pinBlockadeUnlocked()).thenAnswer((_) async => true);
        final container = makeContainer(usePinProtection: true);

        await container.read(walletDescriptorsGateProvider).open();

        expect(
          container.read(pageStatusProvider),
          Status.settingsDescriptors,
        );
      });

      test(
        'still navigates when the unlock resolves after an async gap',
        () async {
          // On a real device the PIN prompt spans multiple frames; an
          // auto-dispose gate with no listener would be reaped during the gap,
          // invalidating the captured ref before _navigate runs.
          when(() => pin.pinBlockadeUnlocked()).thenAnswer((_) async {
            await Future<void>.delayed(const Duration(milliseconds: 20));
            return true;
          });
          final container = makeContainer(usePinProtection: true);

          await container.read(walletDescriptorsGateProvider).open();

          expect(
            container.read(pageStatusProvider),
            Status.settingsDescriptors,
          );
        },
      );

      test('does not navigate when the PIN blockade is refused', () async {
        when(() => pin.pinBlockadeUnlocked()).thenAnswer((_) async => false);
        final container = makeContainer(usePinProtection: true);

        await container.read(walletDescriptorsGateProvider).open();

        expect(container.read(pageStatusProvider), Status.walletLoading);
      });
    });

    group('Jade lease branch (PIN off)', () {
      test('navigates when the unlock lease is held', () async {
        when(() => jade.isUnlocked()).thenReturn(true);
        final container = makeContainer(isJadeWallet: true);

        await container.read(walletDescriptorsGateProvider).open();

        expect(
          container.read(pageStatusProvider),
          Status.settingsDescriptors,
        );
        verifyNever(() => jade.refreshJadeLockState());
      });

      test(
        'triggers the unlock refresh without navigating when the lease is not '
        'held',
        () async {
          when(() => jade.isUnlocked()).thenReturn(false);
          final container = makeContainer(isJadeWallet: true);

          await container.read(walletDescriptorsGateProvider).open();

          verify(() => jade.refreshJadeLockState()).called(1);
          expect(container.read(pageStatusProvider), Status.walletLoading);
        },
      );
    });

    group('software wallet branch (PIN off, not Jade)', () {
      test('biometric decrypt that matches a valid mnemonic navigates', () async {
        when(
          () => encryption.decryptBiometric(any()),
        ).thenAnswer((_) async => storedMnemonic);
        stubWalletMnemonic(storedMnemonic);
        when(() => wallet.validateMnemonic(storedMnemonic)).thenReturn(true);
        final container = makeContainer(useBiometricProtection: true);

        await container.read(walletDescriptorsGateProvider).open();

        verify(() => encryption.decryptBiometric(encryptedMnemonic)).called(1);
        expect(
          container.read(pageStatusProvider),
          Status.settingsDescriptors,
        );
      });

      test('fallback decrypt that matches a valid mnemonic navigates', () async {
        when(
          () => encryption.decryptFallback(any()),
        ).thenAnswer((_) async => storedMnemonic);
        stubWalletMnemonic(storedMnemonic);
        when(() => wallet.validateMnemonic(storedMnemonic)).thenReturn(true);
        final container = makeContainer();

        await container.read(walletDescriptorsGateProvider).open();

        verify(() => encryption.decryptFallback(encryptedMnemonic)).called(1);
        expect(
          container.read(pageStatusProvider),
          Status.settingsDescriptors,
        );
      });

      test('a decrypt that does not match the current mnemonic is refused', () async {
        when(
          () => encryption.decryptFallback(any()),
        ).thenAnswer((_) async => 'a different mnemonic');
        stubWalletMnemonic(storedMnemonic);
        final container = makeContainer();

        await container.read(walletDescriptorsGateProvider).open();

        expect(container.read(pageStatusProvider), Status.walletLoading);
        verifyNever(() => wallet.validateMnemonic(any()));
      });

      test('a matching but invalid mnemonic is refused', () async {
        when(
          () => encryption.decryptFallback(any()),
        ).thenAnswer((_) async => storedMnemonic);
        stubWalletMnemonic(storedMnemonic);
        when(() => wallet.validateMnemonic(storedMnemonic)).thenReturn(false);
        final container = makeContainer();

        await container.read(walletDescriptorsGateProvider).open();

        expect(container.read(pageStatusProvider), Status.walletLoading);
      });
    });
  });
}
