import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/d_jade_info_dialog.dart';
import 'package:sideswap/desktop/desktop_wallet_main.dart';
import 'package:sideswap/desktop/main/d_jade_import.dart';
import 'package:sideswap/desktop/onboarding/d_amp_login.dart';
import 'package:sideswap/desktop/onboarding/d_amp_register.dart';
import 'package:sideswap/desktop/onboarding/d_first_launch.dart';
import 'package:sideswap/desktop/onboarding/d_import_wallet_error.dart';
import 'package:sideswap/desktop/onboarding/d_license.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_failed.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_check_succeed.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup_skip_prompt.dart';
import 'package:sideswap/desktop/onboarding/d_new_wallet_backup.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_submit_amp.dart';
import 'package:sideswap/desktop/onboarding/d_pegx_submit_finish_dialog.dart';
import 'package:sideswap/desktop/onboarding/d_pin_setup.dart';
import 'package:sideswap/desktop/onboarding/d_wallet_import.dart';
import 'package:sideswap/desktop/pageRoute/desktop_page_route.dart';
import 'package:sideswap/desktop/settings/d_settings.dart';
import 'package:sideswap/desktop/settings/d_settings_about_us.dart';
import 'package:sideswap/desktop/settings/d_settings_logs.dart';
import 'package:sideswap/desktop/settings/d_settings_network_access.dart';
import 'package:sideswap/desktop/settings/d_settings_pin_success.dart';
import 'package:sideswap/desktop/settings/d_settings_view_backup.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/onboarding/license.dart';
import 'package:sideswap/screens/onboarding/widgets/new_wallet_pin_welcome.dart';

class RouteName {
  static const String first = '/';
  static const String noWallet = '/noWallet';
  static const String reviewLicenseCreateWallet = '/reviewLicenseCreateWallet';
  static const String reviewLicenseImportWallet = '/reviewLicenseImportWallet';
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
  static const String pinSuccess = '/pinSuccess';
  static const String settingsNetwork = '/settingsNetwork';
  static const String settingsLogs = '/settingsLogs';
  static const String ampRegister = '/ampRegister';
  static const String stokrLogin = '/stokrLogin';
  static const String pegxRegister = '/pegxRegister';
  static const String pegxSubmitAmp = '/pegxSubmitAmp';
  static const String pegxSubmitFinish = '/pegxSubmitFinish';
  static const String jadeImport = '/jadeImport';
  static const String jadeInfoDialog = '/jadeInfoDialog';
}

class RouteGenerator {
  static Route<Widget> generateRoute(RouteSettings settings) {
    final container = ProviderContainer();

    switch (settings.name) {
      case RouteName.first:
        return DesktopPageRoute<Widget>(
            builder: (_) => const PreLaunchPage(), settings: settings);
      case RouteName.noWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DFirstLaunch(), settings: settings);
      case RouteName.reviewLicenseCreateWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DLicense(
                  nextStep: LicenseNextStep.createWallet,
                ),
            settings: settings);
      case RouteName.reviewLicenseImportWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DLicense(
                  nextStep: LicenseNextStep.importWallet,
                ),
            settings: settings);
      case RouteName.importWallet:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DWalletImport(), settings: settings);
      case RouteName.importWalletError:
        return DesktopPageRoute<Widget>(
            builder: (_) => const DImportWalletError(), settings: settings);
      case RouteName.newWalletBackupPrompt:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupPrompt(), settings: settings);
      case RouteName.newWalletBackupSkipPrompt:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupSkipPrompt(),
            settings: settings);
      case RouteName.newWalletBackupView:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackup(), settings: settings);
      case RouteName.newWalletBackupCheck:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupCheck(), settings: settings);
      case RouteName.newWalletBackupCheckFailed:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupCheckFailed(),
            settings: settings);
      case RouteName.newWalletBackupCheckSucceed:
        return DesktopPageRoute(
            builder: (_) => const DNewWalletBackupCheckSucceed(),
            settings: settings);
      case RouteName.newWalletPinWelcome:
        return DesktopPageRoute(
            builder: (_) => const NewWalletPinWelcome(), settings: settings);
      case RouteName.pinSetup:
        if (container.read(pinSetupProvider).isNewWallet) {
          return DesktopPageRoute(
              builder: (_) => const DPinSetup(), settings: settings);
        } else {
          return RawDialogRoute<Widget>(
              pageBuilder: (_, __, ___) => const DPinSetup(),
              settings: settings);
        }
      case RouteName.registered:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DesktopWalletMain(),
            settings: settings);
      case RouteName.settingsPage:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettings(), settings: settings);
      case RouteName.settingsBackup:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsViewBackup(),
            settings: settings);
      case RouteName.settingsAboutUs:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsAboutUs(),
            settings: settings);
      case RouteName.settingsLogs:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsLogs(),
            settings: settings);
      case RouteName.pinSuccess:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsPinSuccess(),
            settings: settings);
      case RouteName.settingsNetwork:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DSettingsNetworkAccess(),
            settings: settings);
      case RouteName.stokrLogin:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) =>
                const DAmpLogin(ampLoginEnum: AmpLoginEnum.stokr),
            settings: settings);
      case RouteName.ampRegister:
        return DesktopPageRoute<Widget>(
          builder: (_) => const DAmpRegister(),
          settings: settings,
        );
      case RouteName.pegxRegister:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) =>
                const DAmpLogin(ampLoginEnum: AmpLoginEnum.pegx),
            settings: settings);
      case RouteName.pegxSubmitAmp:
        return RawDialogRoute(
            pageBuilder: (_, __, ___) => const DPegxSubmitAmp(),
            settings: settings);
      case RouteName.pegxSubmitFinish:
        return RawDialogRoute(
            pageBuilder: (_, __, ___) => const DPegxSubmitFinishDialog(),
            settings: settings);
      case RouteName.jadeImport:
        return RawDialogRoute(
            pageBuilder: (_, __, ___) => const DJadeImport(),
            settings: settings);
      case RouteName.jadeInfoDialog:
        return RawDialogRoute<Widget>(
            pageBuilder: (_, __, ___) => const DJadeInfoDialog(),
            settings: settings);

      default:
        return errorRoute(settings);
    }
  }

  static Route<Widget> errorRoute(RouteSettings settings) {
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

class RouteContainer extends ConsumerStatefulWidget {
  const RouteContainer({super.key});

  @override
  ConsumerState<RouteContainer> createState() => RouteContainerState();
}

class RouteContainerState extends ConsumerState<RouteContainer> {
  Future<void> onStatus(Status status) async {
    final context = ref.read(navigatorKeyProvider).currentContext!;
    final navigator = Navigator.of(context);

    var routeName = RouteName.errorRoute;
    switch (status) {
      case Status.walletLoading:
        routeName = RouteName.first;
        break;
      case Status.noWallet:
      case Status.selectEnv:
        routeName = RouteName.noWallet;
        break;
      case Status.reviewLicenseCreateWallet:
        routeName = RouteName.reviewLicenseCreateWallet;
        break;
      case Status.reviewLicenseImportWallet:
        routeName = RouteName.reviewLicenseImportWallet;
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

        if (!ref.read(pinSetupProvider).isNewWallet) {
          navigator.pushNamedAndRemoveUntil(
              routeName, (route) => route.isFirst);
          return;
        }
        break;
      case Status.pinSuccess:
        if (ref.read(pinSetupProvider).isNewWallet) {
          final wallet = ref.read(walletProvider);
          await wallet.walletBiometricSkip();
          if (wallet.walletImporting) {
            wallet.setImportWalletBiometricPrompt();
          } else {
            wallet.newWalletBackupPrompt();
          }
          return;
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
    }

    await navigator.pushNamedAndRemoveUntil(routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(pageStatusStateProvider, (_, next) async {
      await onStatus(next);
    });
    return const SizedBox();
  }
}
