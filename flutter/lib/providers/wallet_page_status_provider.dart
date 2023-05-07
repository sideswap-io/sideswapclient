import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/custom_logger.dart';

enum Status {
  loading,
  reviewLicenseCreateWallet,
  reviewLicenseImportWallet,
  noWallet,
  selectEnv,
  lockedWalet,
  walletLoading,

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
}

final pageStatusStateProvider =
    AutoDisposeStateNotifierProvider<PageStatus, Status>((ref) {
  ref.keepAlive();
  return PageStatus(ref);
});

class PageStatus extends StateNotifier<Status> {
  final Ref ref;

  PageStatus(this.ref) : super(Status.loading);

  void setStatus(Status status) {
    logger.d(status);
    state = status;
  }
}
