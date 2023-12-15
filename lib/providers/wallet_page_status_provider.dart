import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';

enum Status {
  reviewLicenseCreateWallet,
  reviewLicenseImportWallet,
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
  importAvatar,
  importAvatarSuccess,
  associatePhoneWelcome,
  confirmPhone,
  confirmPhoneSuccess,
  importContacts,
  importContactsSuccess,
  newWalletPinWelcome,
  pinWelcome,
  pinSetup,
  pinSuccess,

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
  settingsUserDetails,
  settingsNetwork,
  settingsLogs,

  paymentPage,
  paymentAmountPage,
  paymentSend,

  orderPopup,
  orderSuccess,
  orderResponseSuccess,
  swapPrompt,

  createOrderEntry,
  createOrder,
  createOrderSuccess,
  orderRequestView,

  ampRegister,
  stokrLogin,

  pegxRegister,
  pegxSubmitAmp,
  pegxSubmitFinish,

  jadeImport,
}

final pageStatusStateProvider =
    AutoDisposeStateNotifierProvider<PageStatus, Status>((ref) {
  ref.keepAlive();

  return PageStatus(ref);
});

class PageStatus extends StateNotifier<Status> {
  final Ref ref;

  PageStatus(this.ref) : super(Status.walletLoading) {
    ref.listenSelf((_, next) {
      logger.d('${pageStatusStateProvider.toString()}: $next');
    });
  }

  void setStatus(Status status) {
    logger.d(status);
    if (mounted) {
      state = status;
    }
  }
}
