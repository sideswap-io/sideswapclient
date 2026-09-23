import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/pin_models.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/fake_shared_preferences.dart';
import '../helpers/settings_container.dart';
import '../helpers/test_utils.dart';

/// One of the two starting states the invariant below is proven from: the
/// store as an earlier run left it, the change the user makes, and the blob
/// that must be on the disk if the flag is still up afterwards.
typedef StartingState = ({
  FakeSharedPreferences Function() store,
  void Function(Configuration) change,
  PinDataStateData whileFlagStands,
  Uint8List mnemonicAfter,
});

/// What a *persist round* must never leave on the disk: a raised PIN flag over
/// a blob that is not the one the user's PIN opens, or a mnemonic that is
/// neither the old one nor the new one. See ADR-0017 and the *wallet-losing
/// state* entry in `CONTEXT.md`.
///
/// [whileFlagStands] is the blob that must be on the disk if the flag is up.
/// Identity, not mere presence: a stale blob locks the wallet as surely as a
/// missing one.
///
/// The blob is only checked while the flag stands. A round that ends part-way
/// through the four blob keys does leave a partial blob on the disk — `hmac`
/// is optional to `isWhole`, so three of the four keys already read as a blob
/// — but the flag is written after all four, so such a round always leaves the
/// flag as it found it. Nothing reads the blob while the flag is down, and the
/// next round rewrites all four keys.
void expectNotWalletLosing(
  FakeSharedPreferences prefs, {
  required PinDataStateData whileFlagStands,
  required Uint8List mnemonicBefore,
  required Uint8List mnemonicAfter,
  required String reason,
}) {
  final reloaded = reloadSettings(prefs);
  expect(
    reloaded.mnemonicEncrypted,
    anyOf(equals(mnemonicBefore), equals(mnemonicAfter)),
    reason: 'the disk holds a mnemonic that is neither set: $reason',
  );
  if (!reloaded.usePinProtection) {
    return;
  }
  expect(
    reloaded.pinDataState,
    whileFlagStands,
    reason: 'the flag stands over the wrong blob: $reason',
  );
}

void main() {
  final capturedLog = CapturingLogOutput();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: capturedLog);
  });

  setUp(capturedLog.lines.clear);

  const blobA = PinDataStateData(
    salt: 'salt-a',
    encryptedData: 'enc-a',
    pinIdentifier: 'id-a',
    hmac: 'hmac-a',
  );

  /// Every key `_writeSettings` writes for the two starting states below, in
  /// write order. The guard test below fails when a key is added to the round
  /// without being added here, so no key can escape the invariant.
  const writtenKeys = [
    SideswapSettings.mnemonicEncryptedField,
    SideswapSettings.jadeIdField,
    SideswapSettings.licenseAcceptedField,
    SideswapSettings.enableEndpointField,
    SideswapSettings.useBiometricProtectionField,
    SideswapSettings.envField,
    SideswapSettings.phoneKeyField,
    SideswapSettings.phoneNumberField,
    SideswapSettings.pinSaltField,
    SideswapSettings.pinEncryptedDataField,
    SideswapSettings.pinIdentifierField,
    SideswapSettings.pinHmacField,
    SideswapSettings.usePinProtectionField,
    SideswapSettings.settingsNetworkTypeField,
    SideswapSettings.settingsHostField,
    SideswapSettings.settingsPortField,
    SideswapSettings.settingsUseTLSField,
    SideswapSettings.knownNewReleaseField,
    SideswapSettings.showAmpOnboardingField,
    SideswapSettings.networkSettingsModelField,
    SideswapSettings.hideTxChainingPromptField,
    SideswapSettings.proxyHostField,
    SideswapSettings.proxyPortField,
    SideswapSettings.useProxyField,
    SideswapSettings.defaultCurrencyField,
    SideswapSettings.stokrSettingsModelField,
    SideswapSettings.autosignDomainsField,
    SideswapSettings.desktopWindowGeometryField,
  ];

  /// A store holding [blob] under a raised flag, as an earlier run of the app
  /// would have left it.
  ///
  /// The default currency is seeded because `_setDefaultCurrency` writes
  /// nothing when the value is null, and every key the round writes must be
  /// under test.
  FakeSharedPreferences storeHolding(PinDataStateData? blob) {
    return FakeSharedPreferences({
      SideswapSettings.defaultCurrencyField: 'USD',
      if (blob != null) ...{
        SideswapSettings.pinSaltField: blob.salt,
        SideswapSettings.pinEncryptedDataField: blob.encryptedData,
        SideswapSettings.pinIdentifierField: blob.pinIdentifier,
        SideswapSettings.pinHmacField: blob.hmac,
        SideswapSettings.usePinProtectionField: true,
      },
    });
  }

  final mnemonic = Uint8List.fromList([1, 2, 3]);
  final noMnemonic = Uint8List.fromList([]);

  /// The two starting states a user can reach the PIN screens from. A new blob
  /// under a standing flag — a rekey — has no entrance from the UI: both
  /// settings screens open PIN setup only when PIN protection is off. A
  /// failure inside the blob under a standing flag leaves a mixed blob for the
  /// length of one round, and this invariant does not cover it. See ADR-0017.
  final startingStates = <String, StartingState>{
    'enabling from a lowered flag': (
      store: () => storeHolding(null),
      change: (notifier) => notifier.activatePinProtection(blobA),
      // The flag is only ever raised over the blob this round writes.
      whileFlagStands: blobA,
      // Enabling does not touch the mnemonic.
      mnemonicAfter: noMnemonic,
    ),
    'disabling from a raised flag': (
      store: () => storeHolding(blobA),
      change: (notifier) =>
          notifier.deactivatePinProtection(mnemonicEncrypted: mnemonic),
      // The disable rounds only ever lower the flag, so a flag still standing
      // must stand over the blob that was already there.
      whileFlagStands: blobA,
      mnemonicAfter: mnemonic,
    ),
  };

  /// Runs [state]'s change with [key] refused, and hands back the store and
  /// the container that wrote it.
  ///
  /// The container is handed back rather than rebuilt: a second container over
  /// the same store is a second writer racing the first, which is what
  /// `reloadSettings` exists to avoid.
  Future<({FakeSharedPreferences prefs, ProviderContainer container})>
  roundRefusing(
    StartingState state,
    String key, {
    required bool byThrowing,
  }) async {
    final prefs = state.store();
    final container = settingsContainer(prefs);
    final notifier = container.read(configurationProvider.notifier);
    // Let the round the build fires finish, so the refusal lands inside the
    // round under test and nowhere else.
    await prefs.settle();

    if (byThrowing) {
      prefs.throwOn(key);
    } else {
      prefs.failOn(key);
    }
    state.change(notifier);
    await prefs.settle();
    return (prefs: prefs, container: container);
  }

  group('a refused write never leaves the wallet-losing state', () {
    test('every key the round writes is under test', () async {
      final written = <String>{};
      for (final state in startingStates.values) {
        final prefs = state.store();
        final notifier = settingsContainer(prefs)
            .read(configurationProvider.notifier);
        await prefs.settle();
        prefs.writeLog.clear();
        state.change(notifier);
        await prefs.settle();
        written.addAll(prefs.writeLog);
      }

      expect(
        written,
        writtenKeys.toSet(),
        reason: 'a key was added to the persist round but not to this list',
      );
    });

    for (final MapEntry(key: stateName, value: state)
        in startingStates.entries) {
      for (final key in writtenKeys) {
        for (final byThrowing in [true, false]) {
          final mode = byThrowing ? 'a throw' : 'a refused write';

          test('$stateName, $mode on $key', () async {
            final round = await roundRefusing(
              state,
              key,
              byThrowing: byThrowing,
            );

            expectNotWalletLosing(
              round.prefs,
              whileFlagStands: state.whileFlagStands,
              mnemonicBefore: noMnemonic,
              mnemonicAfter: state.mnemonicAfter,
              reason: '$mode on $key',
            );
          });
        }
      }
    }
  });

  /// The four keys of the PIN blob, in write order. A refusal on the last of
  /// them is the case the cache reload exists for: the three before it land on
  /// the disk *and* in the cache, the fourth lands in the cache only, and the
  /// skip guard in `_setPinData` reads the cache. Without the reload the next
  /// round skips a blob the disk never got whole, and then raises the flag
  /// over it.
  const blobKeys = [
    SideswapSettings.pinSaltField,
    SideswapSettings.pinEncryptedDataField,
    SideswapSettings.pinIdentifierField,
    SideswapSettings.pinHmacField,
  ];

  group('the next round repairs the disk', () {
    for (final MapEntry(key: stateName, value: state)
        in startingStates.entries) {
      for (final byThrowing in [true, false]) {
        final mode = byThrowing ? 'a throw' : 'a refused write';

        for (final blobKey in blobKeys) {
          test(
            '$stateName, $mode on $blobKey does not stop the queue',
            () async {
              final (:prefs, :container) = await roundRefusing(
                state,
                blobKey,
                byThrowing: byThrowing,
              );
              final notifier = container.read(configurationProvider.notifier);

              // The refusal disarmed itself, so the store answers again and
              // any later state change starts a round that rewrites the whole
              // snapshot.
              notifier.setJadeId('jade-after-the-refusal');
              await prefs.settle();

              final inMemory = container.read(configurationProvider);
              final onDisk = reloadSettings(prefs);
              expect(onDisk.jadeId, 'jade-after-the-refusal');
              expect(
                onDisk.pinDataState,
                // `_pinData` reads a store with no blob as `PinDataStateEmpty`
                // where the notifier holds null. Two spellings of no blob.
                inMemory.pinDataState ?? const PinDataStateEmpty(),
                reason: 'the blob skip guard must not trust the cache',
              );
              expect(onDisk.usePinProtection, inMemory.usePinProtection);
              expect(onDisk.mnemonicEncrypted, inMemory.mnemonicEncrypted);
            },
          );
        }
      }
    }
  });

  group('a failed round is reported', () {
    for (final byThrowing in [true, false]) {
      final mode = byThrowing ? 'a throw' : 'a refused write';

      test('$mode on the salt key logs the key and the failed round', () async {
        await roundRefusing(
          startingStates['enabling from a lowered flag']!,
          SideswapSettings.pinSaltField,
          byThrowing: byThrowing,
        );

        expect(
          capturedLog.lines.where(
            (line) => line.contains(SideswapSettings.pinSaltField),
          ),
          isNotEmpty,
          reason: 'the refused key is never reported',
        );
        expect(
          capturedLog.lines.where(
            (line) => line.contains('The settings round failed'),
          ),
          hasLength(1),
          reason: 'the queue reports the round it dropped exactly once',
        );
      });
    }
  });

  // A known gap, reported rather than hidden. Disabling takes two persist
  // rounds: round one lowers the flag, round two drops the blob. Round two is
  // safe only because round one landed the lowered flag on the disk. A refusal
  // that spans both rounds — one file lock outliving one round — breaks that
  // assumption: round one leaves the flag up, round two removes the blob and
  // is refused the flag again, and the disk ends with a raised flag over no
  // blob at all. That is the wallet-losing state.
  //
  // Nothing inside the fence of #285 repairs it, and ADR-0017 records why
  // under "A refusal spanning both disable rounds is a new gap".
  //
  // These tests assert what the code does today, so the day a write-order
  // change lands they turn red and say so.
  group('a refusal spanning both disable rounds (known gap)', () {
    for (final byThrowing in [true, false]) {
      final mode = byThrowing ? 'a throw' : 'a refused write';

      test('$mode on the flag key in both rounds loses the blob', () async {
        final prefs = storeHolding(blobA);
        final notifier = settingsContainer(prefs)
            .read(configurationProvider.notifier);
        await prefs.settle();

        if (byThrowing) {
          prefs.throwOn(SideswapSettings.usePinProtectionField, times: 2);
        } else {
          prefs.failOn(SideswapSettings.usePinProtectionField, times: 2);
        }
        notifier.deactivatePinProtection(mnemonicEncrypted: mnemonic);
        await prefs.settle();

        final onDisk = reloadSettings(prefs);
        expect(
          onDisk.usePinProtection,
          true,
          reason: 'neither round landed the lowered flag',
        );
        expect(
          onDisk.pinDataState,
          isA<PinDataStateEmpty>(),
          reason: 'round two dropped the blob under the standing flag',
        );
      });
    }
  });
}
