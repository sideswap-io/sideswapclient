import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:secure_application/secure_application.dart';
import 'package:sideswap/common/theme.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/listeners/pin_listener.dart';
import 'package:sideswap/listeners/sideswap_notification_listener.dart';
import 'package:sideswap/listeners/ui_states_listener.dart';
import 'package:sideswap/listeners/warmup_app_listener.dart';
import 'package:sideswap/prelaunch_page.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/local_notifications_service.dart';
import 'package:sideswap/providers/locales_provider.dart';
import 'package:sideswap/providers/pin_protection_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/background/preload_background_painter.dart';
import 'package:sideswap/screens/balances.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/home/wallet_locked.dart';
import 'package:sideswap/screens/markets/create_order_success.dart';
import 'package:sideswap/screens/markets/create_order_view.dart';
import 'package:sideswap/screens/markets/order_entry.dart';
import 'package:sideswap/screens/onboarding/amp_register.dart';
import 'package:sideswap/screens/onboarding/associate_phone_welcome.dart';
import 'package:sideswap/screens/onboarding/confirm_phone.dart';
import 'package:sideswap/screens/onboarding/confirm_phone_success.dart';
import 'package:sideswap/screens/onboarding/first_launch.dart';
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
import 'package:sideswap/screens/pin/pin_protection.dart';
import 'package:sideswap/screens/receive/asset_receive_screen.dart';
import 'package:sideswap/screens/receive/generate_address_screen.dart';
import 'package:sideswap/screens/select_env.dart';
import 'package:sideswap/screens/settings/settings.dart';
import 'package:sideswap/screens/settings/settings_about_us.dart';
import 'package:sideswap/screens/settings/settings_network.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/settings_user_details.dart';
import 'package:sideswap/screens/settings/settings_view_backup.dart';
import 'package:sideswap/screens/swap/peg_in_address.dart';
import 'package:sideswap/screens/tx/tx_details_popup.dart';
import 'package:sideswap/screens/wallet_main/wallet_main.dart';

class AppMain extends StatelessWidget {
  const AppMain({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PreloadBackgroundPainter(),
      child: EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: supportedLocales(),
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (!FlavorConfig.isFdroid) {
      ref.read(localNotificationsProvider).init();
    }
    ref.read(universalLinkProvider).handleIncomingLinks();
    ref.read(universalLinkProvider).handleInitialUri();
  }

  @override
  dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    ref.read(walletProvider).handleAppStateChange(state);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(mobileAppThemeProvider).themeData();

    return MaterialApp(
      title: 'SideSwap',
      debugShowCheckedModeBanner: false,
      theme: themeData,
      themeMode: ThemeMode.dark,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      builder: (context, widget) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: Builder(builder: (context) {
            return widget!;
          }),
        );
      },
      home: Builder(builder: (context) {
        return SecureApplication(
          nativeRemoveDelay: 100,
          onNeedUnlock: (secureApplicationController) async {
            secureApplicationController?.unlock();
            return SecureApplicationAuthenticationStatus.NONE;
          },
          child: const RootWidget(),
        );
      }),
    );
  }
}

class MyPopupPage<T> extends Page<T> {
  const MyPopupPage({required this.child});

  final Widget child;

  @override
  Route<T> createRoute(BuildContext context) {
    return MyPopupPageRoute<T>(page: this);
  }
}

class MyPopupPageRoute<T> extends PageRoute<T>
    with MaterialRouteTransitionMixin<T> {
  MyPopupPageRoute({
    required MyPopupPage<T> page,
  }) : super(settings: page);

  MyPopupPage<T> get _page => settings as MyPopupPage<T>;

  @override
  Widget buildContent(BuildContext context) {
    return _page.child;
  }

  @override
  bool get opaque => false;

  @override
  bool get maintainState => true;

  @override
  bool get fullscreenDialog => false;
}

class RootWidget extends StatefulHookConsumerWidget {
  const RootWidget({super.key});

  @override
  RootWidgetState createState() => RootWidgetState();
}

class RootWidgetState extends ConsumerState<RootWidget> {
  List<Page<dynamic>> pages(
      WidgetRef ref, BuildContext context, Status status) {
    switch (status) {
      case Status.walletLoading:
        return [
          const MaterialPage<Widget>(child: PreLaunchPage()),
        ];
      case Status.reviewLicenseCreateWallet:
        return [
          const MyPopupPage<Widget>(
            child: LicenseTerms(
              nextStep: LicenseNextStep.createWallet,
            ),
          ),
        ];
      case Status.reviewLicenseImportWallet:
        return [
          const MyPopupPage<Widget>(
            child: LicenseTerms(
              nextStep: LicenseNextStep.importWallet,
            ),
          ),
        ];
      case Status.noWallet:
      case Status.jadeImport:
        return [
          const MaterialPage<Widget>(child: FirstLaunch()),
        ];
      case Status.selectEnv:
        return [
          const MaterialPage<Widget>(child: FirstLaunch()),
          const MyPopupPage<Widget>(child: SelectEnv()),
        ];
      case Status.lockedWalet:
        return [
          const MaterialPage<Widget>(child: WalletLocked()),
        ];
      case Status.importWallet:
        return [
          const MaterialPage<Widget>(child: FirstLaunch()),
          const MaterialPage<Widget>(child: WalletImport()),
        ];
      case Status.importWalletBiometricPrompt:
        return [
          const MaterialPage<Widget>(child: ImportWalletBiometricPrompt()),
        ];
      case Status.importWalletSuccess:
        return [
          const MyPopupPage<Widget>(child: ImportWalletSuccess()),
        ];
      case Status.importWalletError:
        return [
          const MyPopupPage<Widget>(child: ImportWalletError()),
        ];
      case Status.newWalletBackupPrompt:
        return [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
        ];
      case Status.newWalletBackupView:
        return [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackup()),
        ];
      case Status.newWalletBackupCheck:
        return [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackup()),
          const MyPopupPage<Widget>(child: WalletBackupCheck()),
        ];
      case Status.newWalletBackupCheckFailed:
        return [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackupCheckFailed()),
        ];
      case Status.newWalletBackupCheckSucceed:
        return [
          const MaterialPage<Widget>(child: WalletBackupNewPrompt()),
          const MyPopupPage<Widget>(child: WalletBackupCheckSucceed()),
        ];
      case Status.newWalletBiometricPrompt:
        return [
          const MaterialPage<Widget>(child: NewWalletBiometricPrompt()),
        ];
      case Status.importAvatar:
        return [
          const MaterialPage<Widget>(child: ImportAvatar()),
        ];
      case Status.importAvatarSuccess:
        return [
          const MaterialPage<Widget>(child: ImportAvatar()),
          const MyPopupPage<Widget>(child: ImportAvatarSuccess()),
        ];
      case Status.associatePhoneWelcome:
        return [
          const MaterialPage<Widget>(child: AssociatePhoneWelcome()),
        ];
      case Status.confirmPhone:
        return [
          const MyPopupPage<Widget>(child: ConfirmPhone()),
        ];
      case Status.confirmPhoneSuccess:
        return [
          const MyPopupPage<Widget>(child: ConfirmPhoneSuccess()),
        ];
      case Status.importContacts:
        return [
          const MaterialPage<Widget>(child: ImportContacts()),
        ];
      case Status.importContactsSuccess:
        return [
          const MyPopupPage<Widget>(child: ImportContactsSuccess()),
        ];
      // WalletMain has it's own navigation system because of
      // MainBottomNavigationBar
      // Use uiStateArgsProvider for changing page
      case Status.registered:
      case Status.assetsSelect:
      case Status.assetDetails:
      case Status.assetReceive:
      case Status.assetReceiveFromWalletMain:
        return [
          const MaterialPage<Widget>(child: WalletMain()),
        ];
      case Status.txDetails:
        return [
          const MyPopupPage<Widget>(child: TxDetailsPopup()),
        ];
      case Status.txEditMemo:
        return [
          const MaterialPage<Widget>(child: WalletTxMemo()),
        ];

      case Status.swapWaitPegTx:
        return [
          const MaterialPage<Widget>(child: WalletMain()),
          const MaterialPage<Widget>(child: PegInAddress()),
        ];
      case Status.swapTxDetails:
        return [
          const MyPopupPage<Widget>(child: TxDetailsPopup()),
        ];
      case Status.settingsPage:
        return [
          const MaterialPage<Widget>(child: Settings()),
        ];
      case Status.settingsBackup:
        return [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(
            child: SecureGate(
              child: SettingsViewBackup(),
            ),
          ),
        ];
      case Status.settingsUserDetails:
        return [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsUserDetails()),
        ];
      case Status.settingsAboutUs:
        return [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsAboutUs()),
        ];
      case Status.settingsNetwork:
        return [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsNetwork()),
        ];
      case Status.settingsSecurity:
        return [
          const MaterialPage<Widget>(child: Settings()),
          const MaterialPage<Widget>(child: SettingsSecurity()),
        ];
      case Status.paymentPage:
        return [
          const MaterialPage<Widget>(child: PaymentPage()),
        ];
      case Status.paymentAmountPage:
        return [
          const MaterialPage<Widget>(child: PaymentAmountPage()),
        ];
      case Status.paymentSend:
        return [
          const MyPopupPage<Widget>(child: PaymentSendPopup()),
        ];
      case Status.orderPopup:
        final orderId = ref.read(walletProvider).orderDetailsData.orderId;
        return [
          const MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(child: OrderPopup(key: Key(orderId))),
        ];
      case Status.orderSuccess:
        return [
          const MyPopupPage<Widget>(child: OrderSuccess()),
        ];
      case Status.orderResponseSuccess:
        return [
          const MyPopupPage<Widget>(
            child: OrderSuccess(
              isResponse: true,
            ),
          ),
        ];
      case Status.newWalletPinWelcome:
        return [
          const MaterialPage<Widget>(child: NewWalletPinWelcome()),
        ];

      case Status.pinWelcome:
        return [
          const MaterialPage<Widget>(child: PinWelcome()),
        ];
      case Status.pinSetup:
        return [
          const MaterialPage<Widget>(child: PinSetup()),
        ];
      case Status.pinSuccess:
        return [
          const MyPopupPage<Widget>(child: PinSuccess()),
        ];
      case Status.createOrderEntry:
        return [
          const MaterialPage<Widget>(child: OrderEntry()),
        ];
      case Status.createOrder:
        return [
          const MaterialPage<Widget>(child: CreateOrderView()),
        ];
      case Status.createOrderSuccess:
        return [
          const MyPopupPage<Widget>(child: CreateOrderSuccess()),
        ];
      case Status.orderRequestView:
        return [
          const MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(
              child: CreateOrderView(
            requestOrder: ref.read(currentRequestOrderViewProvider),
          )),
        ];
      case Status.swapPrompt:
        final orderId = ref.read(walletProvider).swapDetails?.orderId ?? '';
        return [
          const MaterialPage<Widget>(child: WalletMain()),
          MaterialPage<Widget>(child: SwapPrompt(key: Key(orderId))),
        ];
      case Status.stokrLogin:
        return [
          const MaterialPage<Widget>(child: AmpRegister()),
          const MyPopupPage<Widget>(child: StokrLogin()),
        ];
      case Status.pegxRegister:
        return [
          const MaterialPage<Widget>(child: AmpRegister()),
          const MyPopupPage<Widget>(child: PegxRegister()),
        ];
      case Status.pegxSubmitAmp:
        return [
          const MaterialPage<Widget>(child: AmpRegister()),
          const MyPopupPage<Widget>(child: PegxSubmitAmp()),
        ];
      case Status.ampRegister:
      case Status.pegxSubmitFinish:
        return [
          const MaterialPage<Widget>(child: AmpRegister()),
        ];
      case Status.generateWalletAddress:
        return [const MaterialPage<Widget>(child: GenerateAddressScreen())];
      case Status.walletAddressDetail:
        return [const MaterialPage<Widget>(child: AssetReceiveScreen())];
    }
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    ref.read(pinProtectionProvider).onPinBlockadeCallback = onPinBlockade;
  }

  Future<bool> onPinBlockade(
      String? title, bool backButton, PinKeyboardAcceptType iconType) async {
    final ret = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PinProtection(
          title: title,
          iconType: iconType,
        );
      },
    );
    ref.read(pinProtectionProvider).deinit();
    return ret ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final navigatorKey = useMemoized(() => GlobalKey<NavigatorState>());

    useEffect(() {
      ref.read(walletProvider).navigatorKey = navigatorKey;

      return;
    }, [navigatorKey]);

    return Stack(
      children: [
        const PinListener(),
        const UiStatesListener(),
        const SideswapNotificationListener(),
        const WarmupAppListener(),
        // TODO (malcolmpl): fix WillPopScope https://docs.flutter.dev/release/breaking-changes/android-predictive-back#migration-guide
        WillPopScope(
          onWillPop: () async {
            // https://github.com/flutter/flutter/issues/66349
            final ret = await navigatorKey.currentState?.maybePop() ?? false;
            return !ret;
          },
          child: Consumer(
            builder: (context, ref, child) {
              final status = ref.watch(pageStatusStateProvider);
              return Navigator(
                key: navigatorKey,
                pages: pages(ref, context, status),
                onPopPage: (route, dynamic result) {
                  logger.d('on pop page');
                  if (!route.didPop(result)) {
                    return false;
                  }
                  return true;
                },
              );
            },
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final env = ref.watch(configProvider).env;
            return switch (env) {
              0 => Container(),
              _ => Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                      ),
                      child: Text(
                        envName(env),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            };
          },
        ),
      ],
    );
  }
}
