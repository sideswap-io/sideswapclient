import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/encryption.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/encryption_providers.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_descriptors_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/side_swap_client_ffi.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/fake_configuration.dart';
import '../helpers/fake_shared_preferences.dart';
import '../helpers/settings_container.dart';
import '../helpers/test_utils.dart';
import '../utils.dart';

class MockEncryptionRepository extends Mock
    implements AbstractEncryptionRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
  });

  group('SyncCompleteState', () {
    group('build', () {
      test('returns false initially', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        expect(container.read(syncCompleteStateProvider), false);
      });
    });

    group('setState', () {
      test('updates state to true', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();

        container.listen(
          syncCompleteStateProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, false)]);
        verifyNoMoreInteractions(listener);

        final notifier = container.read(syncCompleteStateProvider.notifier);
        notifier.setState(true);

        verifyInOrder([() => listener(false, true)]);
        verifyNoMoreInteractions(listener);
        expect(container.read(syncCompleteStateProvider), true);
      });

      test('updates state to false', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();

        container.listen(
          syncCompleteStateProvider,
          listener.call,
          fireImmediately: true,
        );

        verifyInOrder([() => listener(null, false)]);

        final notifier = container.read(syncCompleteStateProvider.notifier);
        notifier.setState(true);

        final listener2 = ProviderListener<bool>();
        container.listen(syncCompleteStateProvider, listener2.call);

        notifier.setState(false);

        verifyInOrder([() => listener2(true, false)]);
        verifyNoMoreInteractions(listener2);
        expect(container.read(syncCompleteStateProvider), false);
      });

      test('handles multiple state changes', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        final listener = ProviderListener<bool>();

        container.listen(
          syncCompleteStateProvider,
          listener.call,
          fireImmediately: true,
        );

        final notifier = container.read(syncCompleteStateProvider.notifier);

        notifier.setState(true);
        expect(container.read(syncCompleteStateProvider), true);

        notifier.setState(false);
        expect(container.read(syncCompleteStateProvider), false);

        notifier.setState(true);
        expect(container.read(syncCompleteStateProvider), true);
      });
    });
  });

  group('SideSwapException', () {
    test('stores message', () {
      const message = 'Test error message';
      final exception = SideSwapException(message);
      expect(exception.message, message);
    });

    test('toString returns message', () {
      const message = 'Test error message';
      final exception = SideSwapException(message);
      expect(exception.toString(), message);
    });

    test('implements Exception interface', () {
      final exception = SideSwapException('test');
      expect(exception, isA<Exception>());
    });
  });

  group('ClientNotInitializedException', () {
    test('extends SideSwapException', () {
      final exception = ClientNotInitializedException('client not ready');
      expect(exception, isA<SideSwapException>());
    });

    test('stores message from superclass', () {
      const message = 'client not ready';
      final exception = ClientNotInitializedException(message);
      expect(exception.message, message);
    });

    test('toString returns message', () {
      const message = 'client not ready';
      final exception = ClientNotInitializedException(message);
      expect(exception.toString(), message);
    });
  });

  group('envValues', () {
    test('returns all values in debug mode', () {
      // Note: This test assumes kDebugMode is true during testing
      final values = envValues();
      expect(values, contains(SIDESWAP_ENV_PROD));
      expect(values, contains(SIDESWAP_ENV_TESTNET));
    });
  });

  group('envName', () {
    test('returns "Liquid" for SIDESWAP_ENV_PROD', () {
      expect(envName(SIDESWAP_ENV_PROD), 'Liquid');
    });

    test('returns "Testnet" for SIDESWAP_ENV_TESTNET', () {
      expect(envName(SIDESWAP_ENV_TESTNET), 'Testnet');
    });

    test('returns "Local Liquid" for SIDESWAP_ENV_LOCAL_LIQUID', () {
      expect(envName(SIDESWAP_ENV_LOCAL_LIQUID), 'Local Liquid');
    });

    test('returns "Local Testnet" for SIDESWAP_ENV_LOCAL_TESTNET', () {
      expect(envName(SIDESWAP_ENV_LOCAL_TESTNET), 'Local Testnet');
    });

    test('throws Exception for invalid env value', () {
      expect(() => envName(999), throwsException);
    });
  });

  group('PinDecryptedData', () {
    test('constructs with success and empty defaults', () {
      final data = PinDecryptedData(true);
      expect(data.success, true);
      expect(data.mnemonic, '');
      expect(data.error, null);
    });

    test('constructs with success and mnemonic', () {
      final data = PinDecryptedData(true, mnemonic: 'test mnemonic');
      expect(data.success, true);
      expect(data.mnemonic, 'test mnemonic');
      expect(data.error, null);
    });

    test('constructs with failure state', () {
      final data = PinDecryptedData(false);
      expect(data.success, false);
      expect(data.mnemonic, '');
      expect(data.error, null);
    });

    test('constructs with all parameters', () {
      final data = PinDecryptedData(
        false,
        mnemonic: 'test mnemonic',
        error: null,
      );
      expect(data.success, false);
      expect(data.mnemonic, 'test mnemonic');
    });

    test('toString returns formatted string', () {
      final data = PinDecryptedData(true, mnemonic: 'test');
      final str = data.toString();
      expect(str, contains('success: true'));
      expect(str, contains('mnemonic: test'));
    });
  });

  group('MnemonicRepository', () {
    group('isEmpty', () {
      test('returns true when mnemonic is empty', () {
        final repo = MnemonicRepository();
        expect(repo.isEmpty, true);
      });

      test('returns false when mnemonic is set', () {
        final repo = MnemonicRepository();
        repo.setMnemonic('test mnemonic');
        expect(repo.isEmpty, false);
      });
    });

    group('split', () {
      test('returns single empty string when mnemonic is empty', () {
        final repo = MnemonicRepository();
        // Note: String.split('') returns [''] due to Dart semantics
        expect(repo.split, ['']);
      });

      test('splits mnemonic by spaces', () {
        final repo = MnemonicRepository();
        repo.setMnemonic('word1 word2 word3');
        expect(repo.split, ['word1', 'word2', 'word3']);
      });

      test('handles single word mnemonic', () {
        final repo = MnemonicRepository();
        repo.setMnemonic('singleword');
        expect(repo.split, ['singleword']);
      });
    });

    group('mnemonic', () {
      test('returns empty string initially', () {
        final repo = MnemonicRepository();
        expect(repo.mnemonic(), '');
      });

      test('returns stored mnemonic', () {
        final repo = MnemonicRepository();
        const testMnemonic = 'test mnemonic phrase';
        repo.setMnemonic(testMnemonic);
        expect(repo.mnemonic(), testMnemonic);
      });
    });

    group('setMnemonic', () {
      test('stores mnemonic value', () {
        final repo = MnemonicRepository();
        const testMnemonic = 'test mnemonic';
        repo.setMnemonic(testMnemonic);
        expect(repo.mnemonic(), testMnemonic);
      });

      test('overwrites previous mnemonic', () {
        final repo = MnemonicRepository();
        repo.setMnemonic('first mnemonic');
        expect(repo.mnemonic(), 'first mnemonic');

        repo.setMnemonic('second mnemonic');
        expect(repo.mnemonic(), 'second mnemonic');
      });

      test('updates isEmpty after setting', () {
        final repo = MnemonicRepository();
        expect(repo.isEmpty, true);

        repo.setMnemonic('test');
        expect(repo.isEmpty, false);
      });
    });

    group('clear', () {
      test('clears mnemonic', () {
        final repo = MnemonicRepository();
        repo.setMnemonic('test mnemonic');
        expect(repo.isEmpty, false);

        repo.clear();
        expect(repo.isEmpty, true);
        expect(repo.mnemonic(), '');
      });

      test('clears multiple times safely', () {
        final repo = MnemonicRepository();
        repo.setMnemonic('test');
        repo.clear();
        expect(repo.isEmpty, true);

        repo.clear();
        expect(repo.isEmpty, true);
      });

      test('split returns single empty string after clear', () {
        final repo = MnemonicRepository();
        repo.setMnemonic('word1 word2');
        repo.clear();
        // Note: String.split(' ') on empty string returns ['']
        expect(repo.split, ['']);
      });
    });

    group('MnemonicRepository - integration', () {
      test('full lifecycle: set, read, clear, read', () {
        final repo = MnemonicRepository();

        expect(repo.isEmpty, true);
        expect(repo.mnemonic(), '');

        repo.setMnemonic('one two three four five');
        expect(repo.isEmpty, false);
        expect(repo.split, ['one', 'two', 'three', 'four', 'five']);

        repo.clear();
        expect(repo.isEmpty, true);
        expect(repo.mnemonic(), '');
        expect(repo.split, ['']);
      });

      test('multiple set/clear cycles', () {
        final repo = MnemonicRepository();

        for (int i = 0; i < 3; i++) {
          repo.setMnemonic('mnemonic $i');
          expect(repo.mnemonic(), 'mnemonic $i');
          repo.clear();
          expect(repo.isEmpty, true);
        }
      });
    });
  });

  group('Constants', () {
    test('kBackupCheckLineCount equals 4', () {
      expect(kBackupCheckLineCount, 4);
    });

    test('kBackupCheckWordCount equals 3', () {
      expect(kBackupCheckWordCount, 3);
    });
  });

  group('wallet provider', () {
    test('creates SideswapWallet instance with ref and encryption', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final walletInstance = container.read(walletProvider);

      expect(walletInstance, isA<SideswapWallet>());
      expect(walletInstance.ref, isNotNull);
      expect(walletInstance.mnemonicRepository, isA<MnemonicRepository>());
    });

    test('returns same instance when read multiple times', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet1 = container.read(walletProvider);
      final wallet2 = container.read(walletProvider);

      expect(wallet1, same(wallet2));
    });
  });

  group('SideswapWallet initialization', () {
    test('initializes with empty mnemonic repository', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      expect(wallet.mnemonicRepository.isEmpty, true);
      expect(wallet.mnemonicRepository.mnemonic(), '');
    });

    test('initializes with empty backup check state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      expect(wallet.backupCheckAllWords, isEmpty);
      expect(wallet.backupCheckSelectedWords, isEmpty);
    });

    test('initializes with empty filtered toggle accounts', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      expect(wallet.filteredToggleAccounts, isEmpty);
    });

    test('initializes with empty pending push messages', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      expect(wallet.pendingPushMessages, isEmpty);
    });

    test('initializes with clientReady as false', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      expect(wallet.clientReady, false);
    });

    test('initializes with swapPromptWaitingTx as false', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      expect(wallet.swapPromptWaitingTx, false);
    });
  });

  group('SideswapWallet.commonAddrErrorStr', () {
    test('returns empty string for empty address', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      final result = wallet.commonAddrErrorStr('', AddrType.elements);

      expect(result, '');
    });

    test('returns empty string for empty address with bitcoin type', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      final result = wallet.commonAddrErrorStr('', AddrType.bitcoin);

      expect(result, '');
    });
  });

  group('SideswapWallet.elementsAddrErrorStr', () {
    test('returns empty string for empty address', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      final result = wallet.elementsAddrErrorStr('');

      expect(result, '');
    });
  });

  group('SideswapWallet.bitcoinAddrErrorStr', () {
    test('returns empty string for empty address', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final wallet = container.read(walletProvider);
      final result = wallet.bitcoinAddrErrorStr('');

      expect(result, '');
    });
  });

  group('SideswapWallet.cleanAppStates', () {
    test('invalidates the wallet descriptors provider', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container
          .read(walletDescriptorsProvider.notifier)
          .setDescriptors('native', 'nested');
      expect(container.read(walletDescriptorsProvider), isNotNull);

      container.read(walletProvider).cleanAppStates();

      expect(container.read(walletDescriptorsProvider), isNull);
    });
  });

  group('SideswapWallet.goBack', () {
    test(
      'settingsDescriptors returns to the settings page and stays in-app',
      () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        container
            .read(pageStatusProvider.notifier)
            .setStatus(Status.settingsDescriptors);

        final popped = container.read(walletProvider).goBack();

        expect(popped, isFalse);
        expect(container.read(pageStatusProvider), Status.settingsPage);
      },
    );
  });

  group('SideswapWallet.openTxUrl', () {
    ProviderContainer buildContainer() => ProviderContainer.test(
      overrides: [
        configurationProvider.overrideWith(
          () => FakeConfiguration(
            SideswapSettings.empty(mnemonicEncrypted: Uint8List(0)),
          ),
        ),
      ],
    );

    /// Collects everything the wallet pushes to the explorer stream during
    /// [action]. The stream is the only externally observable output of
    /// [SideswapWallet.openTxUrl] on the non-FFI branches.
    Future<List<String>> collectUrls(
      SideswapWallet wallet,
      void Function() action,
    ) async {
      final urls = <String>[];
      final subscription = wallet.explorerUrlSubject.listen(urls.add);
      addTearDown(subscription.cancel);

      action();
      await Future<void>.delayed(Duration.zero);

      return urls;
    }

    test('ignores an empty txid instead of reaching the rust client', () async {
      final container = buildContainer();
      addTearDown(container.dispose);
      final wallet = container.read(walletProvider);

      // isLiquid && unblinded is the branch that hands the txid to the rust
      // client; an empty txid there aborts the whole app.
      final urls = await collectUrls(
        wallet,
        () => wallet.openTxUrl('', true, true),
      );

      expect(urls, isEmpty);
    });

    test('ignores an empty txid on the url-building branches too', () async {
      final container = buildContainer();
      addTearDown(container.dispose);
      final wallet = container.read(walletProvider);

      final urls = await collectUrls(wallet, () {
        wallet.openTxUrl('', false, false);
        wallet.openTxUrl('', true, false);
      });

      expect(urls, isEmpty);
    });

    test('emits a bitcoin explorer url for a non-liquid txid', () async {
      final container = buildContainer();
      addTearDown(container.dispose);
      final wallet = container.read(walletProvider);

      final urls = await collectUrls(
        wallet,
        () => wallet.openTxUrl('abc123', false, false),
      );

      expect(urls, ['https://blockstream.info/tx/abc123']);
    });

    test('emits a liquid explorer url when blinded data is requested', () async {
      final container = buildContainer();
      addTearDown(container.dispose);
      final wallet = container.read(walletProvider);

      final urls = await collectUrls(
        wallet,
        () => wallet.openTxUrl('abc123', true, false),
      );

      expect(urls, ['https://blockstream.info/liquid/tx/abc123']);
    });

    test('asks the client to unblind a non-empty liquid txid', () {
      final container = buildContainer();
      addTearDown(container.dispose);
      final wallet = container.read(walletProvider);

      // No client is initialized under test, so reaching the FFI branch is
      // observable as ClientNotInitializedException -- which is exactly what an
      // empty txid must never do.
      expect(
        () => wallet.openTxUrl('abc123', true, true),
        throwsA(isA<ClientNotInitializedException>()),
      );
    });
  });

  group('PIN record — disablePinProtection', () {
    late FakeSharedPreferences prefs;
    late MockEncryptionRepository encryption;

    const blob = PinDataStateData(
      salt: 'salt-a',
      encryptedData: 'enc-a',
      pinIdentifier: 'id-a',
      hmac: 'hmac-a',
    );

    setUp(() {
      prefs = FakeSharedPreferences();
      encryption = MockEncryptionRepository();
    });

    ProviderContainer containerOverPrefs() {
      return settingsContainer(
        prefs,
        overrides: [encryptionRepositoryProvider.overrideWithValue(encryption)],
      );
    }

    /// A wallet with PIN protection standing and a PIN already entered, which
    /// is where `disablePinProtection` expects to be called from.
    Future<SideswapWallet> walletUnderPinProtection(
      ProviderContainer container,
    ) async {
      container
          .read(configurationProvider.notifier)
          .activatePinProtection(blob);
      await prefs.settle();

      container.read(pinProtectionHelperProvider).onPinBlockadeCallback =
          (_, _, _) async => true;
      container
          .read(pinDecryptedDataProvider.notifier)
          .setPinDecryptedData(PinDecryptedData(true, mnemonic: 'a mnemonic'));

      return container.read(walletProvider);
    }

    test(
      'clears the blob and keeps a fallback mnemonic that survives a rebuild',
      () async {
        when(
          () => encryption.encryptFallback(any()),
        ).thenAnswer((_) async => Uint8List.fromList([7, 8, 9]));

        final container = containerOverPrefs();
        final wallet = await walletUnderPinProtection(container);

        final result = await wallet.disablePinProtection();
        await prefs.settle();

        expect(result, true);

        final reloaded = reloadSettings(prefs);
        expect(reloaded.usePinProtection, false);
        expect(reloaded.pinDataState, isA<PinDataStateEmpty>());
        expect(reloaded.mnemonicEncrypted, Uint8List.fromList([7, 8, 9]));
      },
    );

    test(
      'keeps the PIN record standing when the fallback mnemonic comes back empty',
      () async {
        when(
          () => encryption.encryptFallback(any()),
        ).thenAnswer((_) async => Uint8List(0));

        final container = containerOverPrefs();
        final wallet = await walletUnderPinProtection(container);

        final result = await wallet.disablePinProtection();
        await prefs.settle();

        // The desktop caller draws a success screen on `true`, so a disable
        // that did not happen must not report one.
        expect(result, false);

        final reloaded = reloadSettings(prefs);
        expect(reloaded.usePinProtection, true);
        expect(reloaded.pinDataState, blob);
      },
    );

    test('changes nothing when PIN protection is already off', () async {
      final container = containerOverPrefs();
      await prefs.settle();
      final writesBefore = prefs.writeLog.length;

      final result = await container
          .read(walletProvider)
          .disablePinProtection();
      await prefs.settle();

      expect(result, true);
      expect(prefs.writeLog.length, writesBefore);
    });

    test(
      'enabling biometric protection drops the PIN flag and survives a rebuild',
      () async {
        when(
          () => encryption.encryptBiometric(any()),
        ).thenAnswer((_) async => Uint8List.fromList([4, 5, 6]));

        final container = containerOverPrefs();
        container
            .read(configurationProvider.notifier)
            .activatePinProtection(blob);
        await prefs.settle();

        final wallet = container.read(walletProvider);
        wallet.mnemonicRepository.setMnemonic('a mnemonic');

        final result = await wallet.walletBiometricEnable();
        await prefs.settle();

        expect(result, true);

        final reloaded = reloadSettings(prefs);
        expect(reloaded.useBiometricProtection, true);
        expect(reloaded.usePinProtection, false);
      },
    );
  });
}
