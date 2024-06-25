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
  transactions,
  orderFilers,

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
  settingsCurrency,

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

  jadeBluetoothPermission,
  jadeImport,
  jadeDevices,
  jadeConnecting,
  jadeLogin,

  stokrRestrictionsInfo,
  stokrNeedRegister,
}

@Riverpod(keepAlive: true)
class PageStatusNotifier extends _$PageStatusNotifier {
  @override
  Status build() {
    ref.listenSelf((_, next) {
      logger.d('${pageStatusNotifierProvider.toString()}: $next');
    });
    return Status.walletLoading;
  }

  void setStatus(Status status) {
    state = status;
  }
}
