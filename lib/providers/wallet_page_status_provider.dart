import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

part 'wallet_page_status_provider.g.dart';

enum Status {
  networkAccessOnboarding,
  reviewLicense,
  noWallet,
  selectEnv,
  lockedWalet,
  walletLoading,
  generateWalletAddress,
  walletAddressDetail,
  newWalletBackupPrompt,
  newWalletBackupView,
  newWalletBackupCheck,
  newWalletBackupCheckFailed,
  newWalletBackupCheckSucceed,
  newWalletBiometricPrompt,
  importWallet,
  importWalletBiometricPrompt,
  importWalletError,
  importWalletSuccess,
  newWalletPinWelcome,
  pinWelcome,
  pinSetup,
  pinSuccess,
  transactions,

  registered,
  assetsSelect,
  assetDetails,
  txDetails,
  txEditMemo,

  assetReceive,
  assetReceiveFromWalletMain,

  swapWaitPegTx,
  swapTxDetails,

  settingsPage,
  settingsBackup,
  settingsAboutUs,
  settingsSecurity,
  settingsNetwork,
  settingsLogs,
  settingsCurrency,

  paymentPage,
  paymentAmountPage,
  paymentSend,

  ampRegister,
  stokrLogin,

  pegxRegister,
  pegxSubmitAmp,
  pegxSubmitFinish,

  jadeBluetoothPermission,
  jadeImport,
  jadeDevices,
  jadeConnecting,
  jadeLogin,

  stokrRestrictionsInfo,
  stokrNeedRegister,

  marketSwap,
  marketLimit,
}

@Riverpod(keepAlive: true)
class PageStatusNotifier extends _$PageStatusNotifier {
  @override
  Status build() {
    listenSelf((_, next) {
      logger.d('${pageStatusNotifierProvider.toString()}: $next');
    });
    return Status.walletLoading;
  }

  void setStatus(Status status) {
    state = status;
  }
}
