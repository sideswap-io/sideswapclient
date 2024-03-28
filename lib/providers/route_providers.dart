import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:secure_application/secure_gate.dart';
import 'package:sideswap/app_main.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/d_jade_info_dialog.dart';
import 'package:sideswap/desktop/desktop_wallet_main.dart';
import 'package:sideswap/desktop/main/d_jade_import.dart';
import 'package:sideswap/desktop/onboarding/d_amp_login.dart';
import 'package:sideswap/desktop/onboarding/d_amp_register.dart';
import 'package:sideswap/desktop/onboarding/d_first_launch.dart';
import 'package:sideswap/desktop/onboarding/d_import_wallet_error.dart';
import 'package:sideswap/desktop/onboarding/d_license.dart';
import 'package:sideswap/desktop/onboarding/d_network_access_onboarding.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_failed.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_succeed.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_skip_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_submit_amp.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_submit_finish_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_pin_setup.dart';
import 'package:sideswap/desktop/onboarding/d_wallet_import.dart';
import 'package:sideswap/desktop/pageRoute/desktop_page_route.dart';
import 'package:sideswap/desktop/settings/d_settings.dart';
import 'package:sideswap/desktop/settings/d_settings_about_us.dart';
import 'package:sideswap/desktop/settings/d_settings_default_currency.dart';
import 'package:sideswap/desktop/settings/d_settings_logs.dart';
import 'package:sideswap/desktop/settings/d_settings_network_access.dart';
import 'package:sideswap/desktop/settings/d_settings_pin_success.dart';
import 'package:sideswap/desktop/settings/d_settings_view_backup.dart';
import 'package:sideswap/desktop/stokr/d_stokr_country_restrictions_info_popup.dart';
import 'package:sideswap/desktop/stokr/d_stokr_need_register_popup.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/order_details_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/home/wallet_locked.dart';
import 'package:sideswap/screens/markets/create_order_success.dart';
import 'package:sideswap/screens/markets/create_order_view.dart';
import 'package:sideswap/screens/markets/order_entry.dart';
import 'package:sideswap/screens/markets/order_filters.dart';
import 'package:sideswap/screens/onboarding/amp_register.dart';
import 'package:sideswap/screens/onboarding/associate_phone_welcome.dart';
import 'package:sideswap/screens/onboarding/confirm_phone.dart';
import 'package:sideswap/screens/onboarding/confirm_phone_success.dart';
import 'package:sideswap/screens/onboarding/first_launch_page.dart';
import 'package:sideswap/screens/onboarding/import_avatar.dart';
import 'package:sideswap/screens/onboarding/import_avatar_success.dart';
import 'package:sideswap/screens/onboarding/import_contacts.dart';
import 'package:sideswap/screens/onboarding/import_contacts_success.dart';
import 'package:sideswap/screens/onboarding/import_wallet_error.dart';
import 'package:sideswap/screens/onboarding/import_wallet_success.dart';
import 'package:sideswap/screens/onboarding/license.dart';
import 'package:sideswap/screens/onboarding/pegx_register.dart';
import 'package:sideswap/screens/onboarding/pegx_submit_amp.dart';
import 'package:sideswap/screens/onboarding/pin_setup.dart';
import 'package:sideswap/screens/onboarding/pin_welcome.dart';
import 'package:sideswap/screens/onboarding/stokr_login.dart';
import 'package:sideswap/screens/onboarding/wallet_backup.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_check.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_check_failed.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_check_succeed.dart';
import 'package:sideswap/screens/onboarding/wallet_backup_new_prompt.dart';
import 'package:sideswap/screens/onboarding/wallet_import.dart';
import 'package:sideswap/screens/onboarding/widgets/import_wallet_biometric_prompt.dart';
import 'package:sideswap/screens/onboarding/widgets/new_wallet_biometric_prompt.dart';
import 'package:sideswap/screens/onboarding/widgets/new_wallet_pin_welcome.dart';
import 'package:sideswap/screens/onboarding/widgets/pin_success.dart';
import 'package:sideswap/screens/order/order_popup.dart';
import 'package:sideswap/screens/order/order_success.dart';
import 'package:sideswap/screens/order/swap_prompt.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/payment_page.dart';
import 'package:sideswap/screens/pay/payment_send_popup.dart';
import 'package:sideswap/screens/receive/asset_receive_screen.dart';
import 'package:sideswap/screens/receive/generate_address_screen.dart';
import 'package:sideswap/screens/select_env.dart';
import 'package:sideswap/screens/settings/settings.dart';
import 'package:sideswap/screens/settings/settings_about_us.dart';
import 'package:sideswap/screens/settings/settings_default_currency.dart';
import 'package:sideswap/screens/settings/settings_logs.dart';
import 'package:sideswap/screens/settings/settings_network.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/settings_user_details.dart';
import 'package:sideswap/screens/settings/settings_view_backup.dart';
import 'package:sideswap/screens/stokr/stokr_country_restrictions_info_popup.dart';
import 'package:sideswap/screens/stokr/stokr_need_register_popup.dart';
import 'package:sideswap/screens/swap/peg_in_address.dart';
import 'package:sideswap/screens/tx/transactions.dart';
import 'package:sideswap/screens/tx/tx_details_popup.dart';
import 'package:sideswap/screens/wallet_main/wallet_main.dart';

part 'route_providers.g.dart';

class RouteName {
  static const String first = '/';
  static const String noWallet = '/noWallet';
  static const String reviewLicense = '/reviewLicense';
  static const String importWallet = '/importWallet';
  static const String importWalletError = '/importWalletError';
  static const String newWalletBackupPrompt = '/newWalletBackupPrompt';
  static const String newWalletBackupSkipPrompt = '/newWalletBackupSkipPrompt';
  static const String newWalletBackupView = '/newWalletBackupView';
  static const String newWalletBackupCheck = '/newWalletBackupCheck';
  static const String newWalletBackupCheckFailed =
      '/newWalletBackupCheckFailed';
  static const String newWalletBackupCheckSucceed =
      '/newWalletBackupCheckSucceed';
  static const String newWalletPinWelcome = '/newWalletPinWelcome';
  static const String pinSetup = '/pinSetup';
  static const String registered = '/registered';
  static const String errorRoute = '/errorRoute';
  static const String settingsPage = '/settingsPage';
  static const String settingsBackup = '/settingsBackup';
  static const String settingsAboutUs = '/settingsAboutUs';
  static const String settingsNetwork = '/settingsNetwork';
  static const String settingsLogs = '/settingsLogs';
  static const String settingsFiat = '/settingsFiat';
  static const String pinSuccess = '/pinSuccess';
  static const String ampRegister = '/ampRegister';
  static const String stokrLogin = '/stokrLogin';
  static const String pegxRegister = '/pegxRegister';
  static const String pegxSubmitAmp = '/pegxSubmitAmp';
  static const String pegxSubmitFinish = '/pegxSubmitFinish';
  static const String jadeImport = '/jadeImport';
  static const String jadeInfoDialog = '/jadeInfoDialog';
  static const String stokrRestrictionsInfo = '/stokrRestrictionsInfo';
  static const String stokrNeedRegister = '/stokrRegister';
  static const String networkAccessOnboarding = '/networkAccessOnboarding';
}

@Riverpod(keepAlive: true)
MobileRoutePage mobileRoutePage(MobileRoutePageRef ref) {
  final status = ref.watch(pageStatusNotifierProvider);

  return MobileRoutePage(ref: ref, status: status);
}

class MobileRoutePage {
  final Ref ref;
  final Status status;

  MobileRoutePage({
    required this.ref,
    required this.status,
  });

  List<Page<Widget>> pages() {
    return switch (status) {
      Status.walletLoading => [
          const MaterialPage<Widget>(child: PreLaunchPage()),
        ],
      Status.networkAccessOnboarding => [],
      Status.reviewLicense => [
          const MyPopupPage<Widget>(
            child: LicenseTerms(),
          ),
        ],
      Status.noWallet || Status.jadeImport => [
          const MaterialPage<Widget>(child: FirstLaunchPage()),
        ],
      Status.selectEnv => [
          const MaterialPage<Widget>(child: FirstLaunchPage()),
          const MyPopupPage<Widget>(child: SelectEnv()),
        ],
      Status.lockedWalet => [
          const MaterialPage<Widget>(child: WalletLocked()),
        ],
      Status.importWallet => [
          const MaterialPage<Widget>(child: FirstLaunchPage()),
          const MaterialPage<Widget>(child: WalletImport()),
        ],
      Status.importWalletBiometricPrompt => [
          const MaterialPage<Widget>(child: ImportWalletBiometricPrompt()),
        ],
      Status.importWalletSuccess => [
          const MyPopupPage<Widget>(child: ImportWalletSuccess()),
        ],
      Status.importWalletError => [
          const MyPopupPage<Widget>(child: ImportWalletError()),
        ],
      Status.newWalletBackupPrompt => [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
        ],
      Status.newWalletBackupView => [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackup()),
        ],
      Status.newWalletBackupCheck => [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackup()),
          const MyPopupPage<Widget>(child: WalletBackupCheck()),
        ],
      Status.newWalletBackupCheckFailed => [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackupCheckFailed()),
        ],
      Status.newWalletBackupCheckSucceed => [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackupCheckSucceed()),
        ],
      Status.newWalletBiometricPrompt => [
          const MaterialPage<Widget>(child: NewWalletBiometricPrompt()),
        ],
      Status.importAvatar => [
          const MaterialPage<Widget>(child: ImportAvatar()),
        ],
      Status.importAvatarSuccess => [
          const MaterialPage<Widget>(child: ImportAvatar()),
          const MyPopupPage<Widget>(child: ImportAvatarSuccess()),
        ],
      Status.associatePhoneWelcome => [
          const MaterialPage<Widget>(child: AssociatePhoneWelcome()),
        ],
      Status.confirmPhone => [
          const MyPopupPage<Widget>(child: ConfirmPhone()),
        ],
      Status.confirmPhoneSuccess => [
          const MyPopupPage<Widget>(child: ConfirmPhoneSuccess()),
        ],
      Status.importContacts => [
          const MaterialPage<Widget>(child: ImportContacts()),
        ],
      Status.importContactsSuccess => [
          const MyPopupPage<Widget>(child: ImportContactsSuccess()),
        ],
      // WalletMain has it's own navigation system because of
      // MainBottomNavigationBar
      // Use uiStateArgsProvider for changing page
      Status.registered ||
      Status.assetsSelect ||
      Status.assetDetails ||
      Status.assetReceive ||
      Status.assetReceiveFromWalletMain =>
        [
          const MaterialPage<Widget>(child: WalletMain()),
        ],
      Status.txDetails => [
          const MaterialPage<Widget>(child: WalletMain()),
          const MaterialPage<Widget>(child: TxDetailsPopup()),
        ],
      Status.txEditMemo => [
          const MaterialPage<Widget>(child: WalletTxMemo()),
        ],
      Status.swapWaitPegTx => [
          const MaterialPage<Widget>(child: WalletMain()),
          const MaterialPage<Widget>(child: PegInAddress()),
        ],
      Status.swapTxDetails => [
          const MyPopupPage<Widget>(child: TxDetailsPopup()),
        ],
      Status.settingsPage => [
          const MaterialPage<Widget>(child: Settings()),
        ],
      Status.settingsBackup => [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(
            child: SecureGate(
              child: SettingsViewBackup(),
            ),
          ),
        ],
      Status.settingsUserDetails => [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsUserDetails()),
        ],
      Status.settingsAboutUs => [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsAboutUs()),
        ],
      Status.settingsNetwork => [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsNetwork()),
        ],
      Status.settingsSecurity => [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsSecurity()),
        ],
      Status.settingsLogs => [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsLogs()),
        ],
      Status.settingsCurrency => [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsDefaultCurrency()),
        ],
      Status.paymentPage => [
          const MaterialPage<Widget>(child: PaymentPage()),
        ],
      Status.paymentAmountPage => [
          const MaterialPage<Widget>(child: PaymentAmountPage()),
        ],
      Status.paymentSend => [
          const MyPopupPage<Widget>(child: PaymentSendPopup()),
        ],
      Status.orderPopup => () {
          final orderId = ref.read(orderDetailsDataNotifierProvider).orderId;
          return [
            const MaterialPage<Widget>(child: WalletMain()),
            MaterialPage<Widget>(child: OrderPopup(key: Key(orderId))),
          ];
        }(),
      Status.orderSuccess => [
          const MyPopupPage<Widget>(child: OrderSuccess()),
        ],
      Status.orderResponseSuccess => [
          const MyPopupPage<Widget>(
            child: OrderSuccess(
              isResponse: true,
            ),
          ),
        ],
      Status.newWalletPinWelcome => [
          const MaterialPage<Widget>(child: NewWalletPinWelcome()),
        ],
      Status.pinWelcome => [
          const MaterialPage<Widget>(child: PinWelcome()),
        ],
      Status.pinSetup => [
          const MaterialPage<Widget>(child: PinSetup()),
        ],
      Status.pinSuccess => [
          const MyPopupPage<Widget>(child: PinSuccess()),
        ],
      Status.createOrderEntry => [
          const MaterialPage<Widget>(child: OrderEntry()),
        ],
      Status.createOrder => [
          const MaterialPage<Widget>(child: CreateOrderView()),
        ],
      Status.createOrderSuccess => [
          const MyPopupPage<Widget>(child: CreateOrderSuccess()),
        ],
      Status.orderRequestView => [
          const MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(
              child: CreateOrderView(
            requestOrder: ref.read(currentRequestOrderViewProvider),
          )),
        ],
      Status.swapPrompt => () {
          final orderId = ref.read(walletProvider).swapDetails?.orderId ?? '';
          return [
            const MaterialPage<Widget>(child: WalletMain()),
            MaterialPage<Widget>(child: SwapPrompt(key: Key(orderId))),
          ];
        }(),
      Status.stokrLogin => [
          const MaterialPage<Widget>(child: AmpRegister()),
          const MyPopupPage<Widget>(child: StokrLogin()),
        ],
      Status.pegxRegister => [
          const MaterialPage<Widget>(child: AmpRegister()),
          const MyPopupPage<Widget>(child: PegxRegister()),
        ],
      Status.pegxSubmitAmp => [
          const MaterialPage<Widget>(child: AmpRegister()),
          const MyPopupPage<Widget>(child: PegxSubmitAmp()),
        ],
      Status.ampRegister || Status.pegxSubmitFinish => [
          const MaterialPage<Widget>(child: AmpRegister()),
        ],
      Status.generateWalletAddress => [
          const MaterialPage<Widget>(child: GenerateAddressScreen()),
        ],
      Status.walletAddressDetail => [
          const MaterialPage<Widget>(child: AssetReceiveScreen()),
        ],
      Status.transactions => [
          const MaterialPage<Widget>(child: Transactions()),
        ],
      Status.orderFilers => [
          const MaterialPage<Widget>(child: OrderFilters()),
        ],
      Status.stokrRestrictionsInfo => [
          const MyPopupPage<Widget>(child: StokrCountryRestrictionsInfoPopup()),
        ],
      Status.stokrNeedRegister => [
          const MyPopupPage<Widget>(child: StokrNeedRegisterPopup()),
        ],
    };
  }
}

@Riverpod(keepAlive: true)
DesktopRoutePage desktopRoutePage(DesktopRoutePageRef ref) {
  final status = ref.watch(pageStatusNotifierProvider);
  final firstLaunchState = ref.watch(firstLaunchStateNotifierProvider);

  return DesktopRoutePage(
    ref: ref,
    status: status,
    firstLaunchState: firstLaunchState,
  );
}

class DesktopRoutePage {
  final Ref ref;
  final Status status;
  final FirstLaunchState firstLaunchState;

  DesktopRoutePage({
    required this.ref,
    required this.status,
    required this.firstLaunchState,
  });

  Future<void> mapStatus() async {
    final context = ref.read(navigatorKeyProvider).currentContext!;
    final navigator = ref.read(navigatorKeyProvider).currentState!;

    var routeName = RouteName.errorRoute;
    switch (status) {
      case Status.walletLoading:
        routeName = RouteName.first;
        break;
      case Status.noWallet:
      case Status.selectEnv:
        routeName = RouteName.noWallet;
        break;
      case Status.reviewLicense:
        routeName = RouteName.reviewLicense;
        break;
      case Status.importWallet:
        routeName = RouteName.importWallet;
        break;
      case Status.importWalletError:
        routeName = RouteName.importWalletError;
        break;
      case Status.importWalletSuccess:
        // TODO: temporary, to handle login wallet after importing
        ref.read(walletProvider).setImportWalletBiometricPrompt();
        routeName = RouteName.registered;
        break;
      case Status.newWalletPinWelcome:
        routeName = RouteName.newWalletPinWelcome;
        break;
      case Status.pinWelcome:
      case Status.pinSetup:
        routeName = RouteName.pinSetup;

        if (firstLaunchState == const FirstLaunchStateEmpty()) {
          navigator.pushNamedAndRemoveUntil(
              routeName, (route) => route.isFirst);
          return;
        }
        break;
      case Status.pinSuccess:
        if (firstLaunchState != const FirstLaunchStateEmpty()) {
          await ref.read(walletProvider).walletBiometricSkip();
          final firstLaunchState = ref.read(firstLaunchStateNotifierProvider);

          return switch (firstLaunchState) {
            FirstLaunchStateCreateWallet() =>
              ref.read(walletProvider).newWalletBackupPrompt(),
            _ => ref.read(walletProvider).setImportWalletBiometricPrompt(),
          };
        }

        routeName = RouteName.pinSuccess;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.importAvatar:
      case Status.importAvatarSuccess:
      case Status.associatePhoneWelcome:
      case Status.confirmPhone:
      case Status.confirmPhoneSuccess:
      case Status.importContacts:
      case Status.importContactsSuccess:
        await ref.read(walletProvider).newWalletBiometricPrompt();
        return;
      case Status.newWalletBackupPrompt:
        routeName = RouteName.newWalletBackupPrompt;
        break;
      case Status.newWalletBackupView:
        routeName = RouteName.newWalletBackupView;
        break;
      case Status.newWalletBackupCheck:
        routeName = RouteName.newWalletBackupCheck;
        break;
      case Status.newWalletBackupCheckFailed:
        routeName = RouteName.newWalletBackupCheckFailed;
        break;
      case Status.newWalletBackupCheckSucceed:
        routeName = RouteName.newWalletBackupCheckSucceed;
        break;
      case Status.registered:
        routeName = RouteName.registered;

        if (Navigator.canPop(context)) {
          navigator.popUntil((route) => route.isFirst);
          navigator.pushReplacementNamed(routeName);
        } else {
          navigator.pushReplacementNamed(routeName);
        }

        return;
      case Status.settingsPage:
        routeName = RouteName.settingsPage;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.settingsBackup:
        routeName = RouteName.settingsBackup;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.settingsAboutUs:
        routeName = RouteName.settingsAboutUs;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.settingsNetwork:
        routeName = RouteName.settingsNetwork;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.settingsLogs:
        routeName = RouteName.settingsLogs;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.settingsCurrency:
        routeName = RouteName.settingsFiat;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;

      case Status.lockedWalet:
      case Status.newWalletBiometricPrompt:
      case Status.importWalletBiometricPrompt:
      case Status.assetsSelect:
      case Status.assetDetails:
      case Status.txDetails:
      case Status.txEditMemo:
      case Status.assetReceive:
      case Status.assetReceiveFromWalletMain:
      case Status.swapWaitPegTx:
      case Status.swapTxDetails:
      case Status.settingsSecurity:
      case Status.settingsUserDetails:
      case Status.paymentPage:
      case Status.paymentAmountPage:
      case Status.paymentSend:
      case Status.orderPopup:
      case Status.orderSuccess:
      case Status.orderResponseSuccess:
      case Status.swapPrompt:
      case Status.createOrderEntry:
      case Status.createOrder:
      case Status.createOrderSuccess:
      case Status.orderRequestView:
      case Status.generateWalletAddress:
      case Status.walletAddressDetail:
      case Status.transactions:
      case Status.orderFilers:
        // Not used on desktop
        break;
      case Status.ampRegister:
        routeName = RouteName.ampRegister;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.stokrLogin:
        routeName = RouteName.stokrLogin;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.pegxRegister:
        routeName = RouteName.pegxRegister;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.pegxSubmitAmp:
        routeName = RouteName.pegxSubmitAmp;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.pegxSubmitFinish:
        routeName = RouteName.pegxSubmitFinish;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.jadeImport:
        routeName = RouteName.jadeImport;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.stokrRestrictionsInfo:
        routeName = RouteName.stokrRestrictionsInfo;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.stokrNeedRegister:
        routeName = RouteName.stokrNeedRegister;
        navigator.pushNamedAndRemoveUntil(routeName, (route) => route.isFirst);
        return;
      case Status.networkAccessOnboarding:
        routeName = RouteName.networkAccessOnboarding;
        break;
    }

    await navigator.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  Route<Widget> generateRoute(RouteSettings settings) {
    return switch (settings.name) {
      RouteName.first => DesktopPageRoute<Widget>(
          builder: (_) => const PreLaunchPage(), settings: settings),
      RouteName.noWallet => DesktopPageRoute<Widget>(
          builder: (_) => const DFirstLaunch(), settings: settings),
      RouteName.reviewLicense => DesktopPageRoute<Widget>(
          builder: (_) => const DLicense(), settings: settings),
      RouteName.networkAccessOnboarding => DesktopPageRoute<Widget>(
          builder: (_) => const DNetworkAccessOnboarding(), settings: settings),
      RouteName.importWallet => DesktopPageRoute<Widget>(
          builder: (_) => const DWalletImport(), settings: settings),
      RouteName.importWalletError => DesktopPageRoute<Widget>(
          builder: (_) => const DImportWalletError(), settings: settings),
      RouteName.newWalletBackupPrompt => DesktopPageRoute(
          builder: (_) => const DNewWalletBackupPrompt(), settings: settings),
      RouteName.newWalletBackupSkipPrompt => DesktopPageRoute(
          builder: (_) => const DNewWalletBackupSkipPrompt(),
          settings: settings),
      RouteName.newWalletBackupView => DesktopPageRoute(
          builder: (_) => const DNewWalletBackup(), settings: settings),
      RouteName.newWalletBackupCheck => DesktopPageRoute(
          builder: (_) => const DNewWalletBackupCheck(), settings: settings),
      RouteName.newWalletBackupCheckFailed => DesktopPageRoute(
          builder: (_) => const DNewWalletBackupCheckFailed(),
          settings: settings),
      RouteName.newWalletBackupCheckSucceed => DesktopPageRoute(
          builder: (_) => const DNewWalletBackupCheckSucceed(),
          settings: settings),
      RouteName.newWalletPinWelcome => DesktopPageRoute(
          builder: (_) => const NewWalletPinWelcome(), settings: settings),
      RouteName.pinSetup
          when firstLaunchState != const FirstLaunchStateEmpty() =>
        DesktopPageRoute(builder: (_) => const DPinSetup(), settings: settings),
      RouteName.pinSetup => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DPinSetup(), settings: settings),
      RouteName.registered => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DesktopWalletMain(),
          settings: settings),
      RouteName.settingsPage => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DSettings(), settings: settings),
      RouteName.settingsBackup => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DSettingsViewBackup(),
          settings: settings),
      RouteName.settingsAboutUs => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DSettingsAboutUs(),
          settings: settings),
      RouteName.settingsLogs => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DSettingsLogs(),
          settings: settings),
      RouteName.pinSuccess => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DSettingsPinSuccess(),
          settings: settings),
      RouteName.settingsNetwork => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DSettingsNetworkAccess(),
          settings: settings),
      RouteName.stokrLogin => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) =>
              const DAmpLogin(ampLoginEnum: AmpLoginEnum.stokr),
          settings: settings),
      RouteName.ampRegister => DesktopPageRoute<Widget>(
          builder: (_) => const DAmpRegister(),
          settings: settings,
        ),
      RouteName.pegxRegister => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) =>
              const DAmpLogin(ampLoginEnum: AmpLoginEnum.pegx),
          settings: settings),
      RouteName.pegxSubmitAmp => RawDialogRoute(
          pageBuilder: (_, __, ___) => const DPegxSubmitAmp(),
          settings: settings),
      RouteName.pegxSubmitFinish => RawDialogRoute(
          pageBuilder: (_, __, ___) => const DPegxSubmitFinishDialog(),
          settings: settings),
      RouteName.jadeImport => RawDialogRoute(
          pageBuilder: (_, __, ___) => const DJadeImport(), settings: settings),
      RouteName.jadeInfoDialog => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DJadeInfoDialog(),
          settings: settings),
      RouteName.settingsFiat => RawDialogRoute<Widget>(
          pageBuilder: (_, __, ___) => const DSettingsDefaultCurrency(),
          settings: settings),
      RouteName.stokrRestrictionsInfo => RawDialogRoute<Widget>(
          barrierDismissible: false,
          pageBuilder: (_, __, ___) =>
              const DStokrCountryRestrictionsInfoPopup(),
          settings: settings),
      RouteName.stokrNeedRegister => RawDialogRoute<Widget>(
          barrierDismissible: false,
          pageBuilder: (_, __, ___) => const DStokrNeedRegisterPopup(),
          settings: settings),
      _ => errorRoute(settings),
    };
  }

  Route<Widget> errorRoute(RouteSettings settings) {
    logger.e('Unhandled page status ${settings.name}');
    return DesktopPageRoute<Widget>(
        builder: (_) {
          return const SideSwapScaffoldPage(
            content: Center(
              child: Text('ERROR'),
            ),
          );
        },
        settings: settings);
  }
}
