import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/encryption_providers.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

part 'wallet_descriptors_gate_provider.g.dart';

// keepAlive: the gate is invoked as a listener-less one-shot
// (`ref.read(...).open()`), and its `open()` awaits the PIN prompt / biometric
// decrypt before navigating through the captured `ref`. An auto-dispose
// provider would be reaped during that async gap, invalidating the ref before
// `_navigate` runs. The seams it reads (pin/encryption/wallet providers) are
// keepAlive for the same reason.
@Riverpod(keepAlive: true)
WalletDescriptorsGate walletDescriptorsGate(Ref ref) =>
    WalletDescriptorsGate(ref);

/// Access gate for the watch-only descriptors screen.
///
/// Mirrors the recovery-phrase gate (`SideswapWallet.settingsViewBackup`), with
/// a Jade-lease branch inserted for hardware wallets without an app PIN. The
/// three branches are mutually exclusive:
///
/// - **app PIN on** -> the generic PIN blockade;
/// - **Jade wallet, PIN off** -> the five-minute Jade unlock lease (enter if
///   held, otherwise trigger the device-unlock refresh, which does not
///   navigate) -- the same authorization that gates trading;
/// - **software wallet, PIN off** -> biometric/fallback mnemonic
///   decrypt-and-compare, identical to the recovery-phrase view.
///
/// Navigation is a single `pageStatusProvider` transition to
/// [Status.settingsDescriptors]; the route providers react to it.
class WalletDescriptorsGate {
  WalletDescriptorsGate(this.ref);

  final Ref ref;

  Future<void> open() async {
    final config = ref.read(configurationProvider);

    if (config.usePinProtection) {
      if (await ref.read(pinProtectionHelperProvider).pinBlockadeUnlocked()) {
        _navigate();
      }
      return;
    }

    if (ref.read(isJadeWalletProvider)) {
      final jadeLockRepository = ref.read(jadeLockRepositoryProvider);
      if (jadeLockRepository.isUnlocked()) {
        _navigate();
      } else {
        jadeLockRepository.refreshJadeLockState();
      }
      return;
    }

    final encryption = ref.read(encryptionRepositoryProvider);
    final wallet = ref.read(walletProvider);
    final mnemonic = config.useBiometricProtection
        ? await encryption.decryptBiometric(config.mnemonicEncrypted)
        : await encryption.decryptFallback(config.mnemonicEncrypted);
    if (mnemonic == wallet.mnemonicRepository.mnemonic() &&
        wallet.validateMnemonic(mnemonic)) {
      _navigate();
    }
  }

  void _navigate() {
    ref.read(pageStatusProvider.notifier).setStatus(Status.settingsDescriptors);
  }
}
