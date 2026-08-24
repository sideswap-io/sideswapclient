import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/app_main.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/pageRoute/desktop_page_route.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/route_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_logger/custom_logger.dart';

import '../helpers/test_utils.dart';

class MockWallet extends Mock implements SideswapWallet {}

class _FakeBuildContext extends Fake implements BuildContext {}

class _FakeRoute extends Fake implements Route<dynamic> {
  @override
  bool get isFirst => false;
}

class MockNavigatorState extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      super.toString();
}

class MockNavigatorKey extends Mock implements GlobalKey<NavigatorState> {
  final NavigatorState _state;
  MockNavigatorKey(this._state);

  @override
  NavigatorState? get currentState => _state;
}

void main() {
  setUpAll(() {
    logger = CustomLogger('SideSwap', output: NoOpLogOutput());
    TestWidgetsFlutterBinding.ensureInitialized();
    registerFallbackValue(const RouteSettings(name: RouteName.first));
    registerFallbackValue((Route<dynamic> route) => false);
  });

  group('mobileRoutePage provider', () {
    test('returns MobileRoutePage with correct status and ref', () {
      final container = ProviderContainer.test(
        overrides: [pageStatusProvider.overrideWithValue(Status.walletLoading)],
      );
      addTearDown(container.dispose);

      final result = container.read(mobileRoutePageProvider);

      expect(result, isA<MobileRoutePage>());
      expect(result.status, Status.walletLoading);
      expect(result.ref, isNotNull);
    });

    test('returns MobileRoutePage for each enum status variant', () {
      final statuses = Status.values;

      for (final status in statuses) {
        final container = ProviderContainer.test(
          overrides: [pageStatusProvider.overrideWithValue(status)],
        );
        addTearDown(container.dispose);

        final result = container.read(mobileRoutePageProvider);

        expect(
          result.status,
          status,
          reason: 'MobileRoutePage should reflect $status',
        );
      }
    });
  });

  group('desktopRoutePage provider', () {
    test('returns DesktopRoutePage with status and firstLaunchStateType', () {
      final container = ProviderContainer.test(
        overrides: [
          pageStatusProvider.overrideWithValue(Status.walletLoading),
          firstLaunchStateProvider.overrideWithValue(
            const FirstLaunchStateTypeEmpty(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = container.read(desktopRoutePageProvider);

      expect(result, isA<DesktopRoutePage>());
      expect(result.status, Status.walletLoading);
      expect(result.firstLaunchStateType, isA<FirstLaunchStateTypeEmpty>());
      expect(result.ref, isNotNull);
    });
  });

  group('RouteName', () {
    test('first constant is root path', () {
      expect(RouteName.first, '/');
    });

    test('all route constants are non-empty strings', () {
      expect(RouteName.noWallet, isNotEmpty);
      expect(RouteName.reviewLicense, isNotEmpty);
      expect(RouteName.importWallet, isNotEmpty);
      expect(RouteName.importWalletError, isNotEmpty);
      expect(RouteName.newWalletBackupPrompt, isNotEmpty);
      expect(RouteName.newWalletBackupSkipPrompt, isNotEmpty);
      expect(RouteName.newWalletBackupView, isNotEmpty);
      expect(RouteName.newWalletBackupCheck, isNotEmpty);
      expect(RouteName.newWalletBackupCheckFailed, isNotEmpty);
      expect(RouteName.newWalletBackupCheckSucceed, isNotEmpty);
      expect(RouteName.newWalletPinWelcome, isNotEmpty);
      expect(RouteName.pinSetup, isNotEmpty);
      expect(RouteName.registered, isNotEmpty);
      expect(RouteName.errorRoute, isNotEmpty);
      expect(RouteName.settingsPage, isNotEmpty);
      expect(RouteName.settingsBackup, isNotEmpty);
      expect(RouteName.settingsAboutUs, isNotEmpty);
      expect(RouteName.settingsNetwork, isNotEmpty);
      expect(RouteName.settingsLogs, isNotEmpty);
      expect(RouteName.settingsFiat, isNotEmpty);
      expect(RouteName.pinSuccess, isNotEmpty);
      expect(RouteName.ampRegister, isNotEmpty);
      expect(RouteName.stokrLogin, isNotEmpty);
      expect(RouteName.pegxRegister, isNotEmpty);
      expect(RouteName.pegxSubmitAmp, isNotEmpty);
      expect(RouteName.pegxSubmitFinish, isNotEmpty);
      expect(RouteName.jadeImport, isNotEmpty);
      expect(RouteName.jadeInfoDialog, isNotEmpty);
      expect(RouteName.stokrRestrictionsInfo, isNotEmpty);
      expect(RouteName.stokrNeedRegister, isNotEmpty);
      expect(RouteName.networkAccessOnboarding, isNotEmpty);
    });

    test('route names start with forward slash', () {
      expect(RouteName.noWallet.startsWith('/'), isTrue);
      expect(RouteName.reviewLicense.startsWith('/'), isTrue);
      expect(RouteName.importWallet.startsWith('/'), isTrue);
      expect(RouteName.importWalletError.startsWith('/'), isTrue);
      expect(RouteName.registered.startsWith('/'), isTrue);
      expect(RouteName.settingsPage.startsWith('/'), isTrue);
      expect(RouteName.settingsBackup.startsWith('/'), isTrue);
      expect(RouteName.settingsAboutUs.startsWith('/'), isTrue);
      expect(RouteName.ampRegister.startsWith('/'), isTrue);
      expect(RouteName.stokrLogin.startsWith('/'), isTrue);
      expect(RouteName.jadeImport.startsWith('/'), isTrue);
      expect(RouteName.errorRoute.startsWith('/'), isTrue);
      expect(RouteName.networkAccessOnboarding.startsWith('/'), isTrue);
    });

    test('each route name has unique value', () {
      final routeNames = [
        RouteName.first,
        RouteName.noWallet,
        RouteName.reviewLicense,
        RouteName.importWallet,
        RouteName.importWalletError,
        RouteName.newWalletBackupPrompt,
        RouteName.newWalletBackupSkipPrompt,
        RouteName.newWalletBackupView,
        RouteName.newWalletBackupCheck,
        RouteName.newWalletBackupCheckFailed,
        RouteName.newWalletBackupCheckSucceed,
        RouteName.newWalletPinWelcome,
        RouteName.pinSetup,
        RouteName.registered,
        RouteName.errorRoute,
        RouteName.settingsPage,
        RouteName.settingsBackup,
        RouteName.settingsAboutUs,
        RouteName.settingsNetwork,
        RouteName.settingsLogs,
        RouteName.settingsFiat,
        RouteName.pinSuccess,
        RouteName.ampRegister,
        RouteName.stokrLogin,
        RouteName.pegxRegister,
        RouteName.pegxSubmitAmp,
        RouteName.pegxSubmitFinish,
        RouteName.jadeImport,
        RouteName.jadeInfoDialog,
        RouteName.stokrRestrictionsInfo,
        RouteName.stokrNeedRegister,
        RouteName.networkAccessOnboarding,
      ];

      final uniqueRoutes = routeNames.toSet();
      expect(
        uniqueRoutes.length,
        routeNames.length,
        reason: 'Route names should be unique, but found duplicates',
      );
    });

    test('common routes have expected values', () {
      expect(RouteName.first, '/');
      expect(RouteName.registered, '/registered');
      expect(RouteName.settingsPage, '/settingsPage');
      expect(RouteName.errorRoute, '/errorRoute');
    });
  });

  group('MobileRoutePage.pages()', () {
    MobileRoutePage makeRoutePage(Status status) {
      final container = ProviderContainer.test(
        overrides: [pageStatusProvider.overrideWithValue(status)],
      );
      addTearDown(container.dispose);
      return container.read(mobileRoutePageProvider);
    }

    test('networkAccessOnboarding returns empty list', () {
      final pages = makeRoutePage(Status.networkAccessOnboarding).pages();
      expect(pages, isEmpty);
    });

    group('single-page statuses return exactly 1 page', () {
      final singlePageStatuses = [
        Status.walletLoading,
        Status.reviewLicense,
        Status.noWallet,
        Status.jadeImport,
        Status.lockedWalet,
        Status.importWalletBiometricPrompt,
        Status.importWalletSuccess,
        Status.importWalletError,
        Status.newWalletBackupPrompt,
        Status.newWalletBiometricPrompt,
        Status.registered,
        Status.assetsSelect,
        Status.assetDetails,
        Status.assetReceive,
        Status.assetReceiveFromWalletMain,
        Status.txEditMemo,
        Status.swapTxDetails,
        Status.settingsPage,
        Status.paymentPage,
        Status.paymentAmountPage,
        Status.paymentSend,
        Status.newWalletPinWelcome,
        Status.pinWelcome,
        Status.pinSetup,
        Status.pinSuccess,
        Status.ampRegister,
        Status.pegxSubmitFinish,
        Status.generateWalletAddress,
        Status.walletAddressDetail,
        Status.transactions,
        Status.stokrRestrictionsInfo,
        Status.stokrNeedRegister,
        Status.jadeBluetoothPermission,
        Status.jadeDevices,
        Status.jadeConnecting,
        Status.jadeLogin,
        Status.marketSwap,
        Status.marketLimit,
      ];

      for (final status in singlePageStatuses) {
        test('$status returns 1 page', () {
          final pages = makeRoutePage(status).pages();
          expect(
            pages.length,
            1,
            reason: '$status should return exactly 1 page',
          );
        });
      }
    });

    group('multi-page statuses return correct length', () {
      test('selectEnv returns 2 pages', () {
        expect(makeRoutePage(Status.selectEnv).pages().length, 2);
      });

      test('importWallet returns 2 pages', () {
        expect(makeRoutePage(Status.importWallet).pages().length, 2);
      });

      test('newWalletBackupView returns 2 pages', () {
        expect(makeRoutePage(Status.newWalletBackupView).pages().length, 2);
      });

      test('newWalletBackupCheck returns 3 pages', () {
        expect(makeRoutePage(Status.newWalletBackupCheck).pages().length, 3);
      });

      test('newWalletBackupCheckFailed returns 2 pages', () {
        expect(
          makeRoutePage(Status.newWalletBackupCheckFailed).pages().length,
          2,
        );
      });

      test('newWalletBackupCheckSucceed returns 2 pages', () {
        expect(
          makeRoutePage(Status.newWalletBackupCheckSucceed).pages().length,
          2,
        );
      });

      test('txDetails returns 2 pages', () {
        expect(makeRoutePage(Status.txDetails).pages().length, 2);
      });

      test('swapWaitPegTx returns 2 pages', () {
        expect(makeRoutePage(Status.swapWaitPegTx).pages().length, 2);
      });

      test('settingsBackup returns 2 pages', () {
        expect(makeRoutePage(Status.settingsBackup).pages().length, 2);
      });

      test('settingsDescriptors returns 2 pages', () {
        expect(makeRoutePage(Status.settingsDescriptors).pages().length, 2);
      });

      test('settingsAboutUs returns 2 pages', () {
        expect(makeRoutePage(Status.settingsAboutUs).pages().length, 2);
      });

      test('settingsNetwork returns 2 pages', () {
        expect(makeRoutePage(Status.settingsNetwork).pages().length, 2);
      });

      test('settingsSecurity returns 2 pages', () {
        expect(makeRoutePage(Status.settingsSecurity).pages().length, 2);
      });

      test('settingsLogs returns 2 pages', () {
        expect(makeRoutePage(Status.settingsLogs).pages().length, 2);
      });

      test('settingsCurrency returns 2 pages', () {
        expect(makeRoutePage(Status.settingsCurrency).pages().length, 2);
      });

      test('stokrLogin returns 2 pages', () {
        expect(makeRoutePage(Status.stokrLogin).pages().length, 2);
      });

      test('pegxRegister returns 2 pages', () {
        expect(makeRoutePage(Status.pegxRegister).pages().length, 2);
      });

      test('pegxSubmitAmp returns 2 pages', () {
        expect(makeRoutePage(Status.pegxSubmitAmp).pages().length, 2);
      });
    });

    group('page types', () {
      test('walletLoading first page is MaterialPage', () {
        final pages = makeRoutePage(Status.walletLoading).pages();
        expect(pages.first, isA<MaterialPage<Widget>>());
      });

      test('reviewLicense first page is MyPopupPage', () {
        final pages = makeRoutePage(Status.reviewLicense).pages();
        expect(pages.first, isA<MyPopupPage<Widget>>());
      });

      test('selectEnv: first page MaterialPage, second MyPopupPage', () {
        final pages = makeRoutePage(Status.selectEnv).pages();
        expect(pages[0], isA<MaterialPage<Widget>>());
        expect(pages[1], isA<MyPopupPage<Widget>>());
      });

      test('newWalletBackupCheck has mixed page types', () {
        final pages = makeRoutePage(Status.newWalletBackupCheck).pages();
        expect(pages[0], isA<MaterialPage<Widget>>());
        expect(pages[1], isA<MyPopupPage<Widget>>());
        expect(pages[2], isA<MyPopupPage<Widget>>());
      });

      test('importWalletSuccess first page is MyPopupPage', () {
        final pages = makeRoutePage(Status.importWalletSuccess).pages();
        expect(pages.first, isA<MyPopupPage<Widget>>());
      });

      test('pinSuccess first page is MyPopupPage', () {
        final pages = makeRoutePage(Status.pinSuccess).pages();
        expect(pages.first, isA<MyPopupPage<Widget>>());
      });
    });
  });

  group('DesktopRoutePage.generateRoute()', () {
    DesktopRoutePage makeDesktopRoutePage({
      FirstLaunchStateType firstLaunchStateType =
          const FirstLaunchStateTypeEmpty(),
    }) {
      final container = ProviderContainer.test(
        overrides: [
          pageStatusProvider.overrideWithValue(Status.walletLoading),
          firstLaunchStateProvider.overrideWithValue(firstLaunchStateType),
        ],
      );
      addTearDown(container.dispose);
      return container.read(desktopRoutePageProvider);
    }

    group('routes returning DesktopPageRoute', () {
      final desktopPageRouteNames = [
        RouteName.first,
        RouteName.noWallet,
        RouteName.reviewLicense,
        RouteName.networkAccessOnboarding,
        RouteName.importWallet,
        RouteName.importWalletError,
        RouteName.newWalletBackupPrompt,
        RouteName.newWalletBackupSkipPrompt,
        RouteName.newWalletBackupView,
        RouteName.newWalletBackupCheck,
        RouteName.newWalletBackupCheckFailed,
        RouteName.newWalletBackupCheckSucceed,
        RouteName.newWalletPinWelcome,
        RouteName.ampRegister,
      ];

      for (final name in desktopPageRouteNames) {
        test('$name returns DesktopPageRoute', () {
          final routePage = makeDesktopRoutePage();
          final route =
              routePage.generateRoute(RouteSettings(name: name))
                  as DesktopPageRoute<Widget>;
          expect(route, isA<DesktopPageRoute<Widget>>());
          final anim = const AlwaysStoppedAnimation(1.0);
          route.buildPage(_FakeBuildContext(), anim, anim);
        });
      }
    });

    group('routes returning RawDialogRoute', () {
      final rawDialogRouteNames = [
        RouteName.registered,
        RouteName.settingsPage,
        RouteName.settingsBackup,
        RouteName.settingsDescriptors,
        RouteName.settingsAboutUs,
        RouteName.settingsLogs,
        RouteName.pinSuccess,
        RouteName.settingsNetwork,
        RouteName.stokrLogin,
        RouteName.pegxRegister,
        RouteName.pegxSubmitAmp,
        RouteName.pegxSubmitFinish,
        RouteName.jadeImport,
        RouteName.jadeInfoDialog,
        RouteName.settingsFiat,
        RouteName.stokrRestrictionsInfo,
        RouteName.stokrNeedRegister,
      ];

      for (final name in rawDialogRouteNames) {
        test('$name returns RawDialogRoute', () {
          final routePage = makeDesktopRoutePage();
          final route =
              routePage.generateRoute(RouteSettings(name: name))
                  as RawDialogRoute<Widget>;
          expect(route, isA<RawDialogRoute<Widget>>());
          final anim = const AlwaysStoppedAnimation(1.0);
          route.buildPage(_FakeBuildContext(), anim, anim);
        });
      }
    });

    group('pinSetup guard on firstLaunchStateType', () {
      test(
        'pinSetup returns DesktopPageRoute when firstLaunchStateType != empty',
        () {
          final routePage = makeDesktopRoutePage(
            firstLaunchStateType: const FirstLaunchStateTypeCreateWallet(),
          );
          final route =
              routePage.generateRoute(
                    const RouteSettings(name: RouteName.pinSetup),
                  )
                  as DesktopPageRoute<Widget>;
          expect(route, isA<DesktopPageRoute<Widget>>());
          final anim = const AlwaysStoppedAnimation(1.0);
          route.buildPage(_FakeBuildContext(), anim, anim);
        },
      );

      test(
        'pinSetup returns RawDialogRoute when firstLaunchStateType == empty',
        () {
          final routePage = makeDesktopRoutePage(
            firstLaunchStateType: const FirstLaunchStateTypeEmpty(),
          );
          final route =
              routePage.generateRoute(
                    const RouteSettings(name: RouteName.pinSetup),
                  )
                  as RawDialogRoute<Widget>;
          expect(route, isA<RawDialogRoute<Widget>>());
          final anim = const AlwaysStoppedAnimation(1.0);
          route.buildPage(_FakeBuildContext(), anim, anim);
        },
      );

      test(
        'pinSetup returns DesktopPageRoute when firstLaunchStateType == importWallet',
        () {
          final routePage = makeDesktopRoutePage(
            firstLaunchStateType: const FirstLaunchStateTypeImportWallet(),
          );
          final route =
              routePage.generateRoute(
                    const RouteSettings(name: RouteName.pinSetup),
                  )
                  as DesktopPageRoute<Widget>;
          expect(route, isA<DesktopPageRoute<Widget>>());
          final anim = const AlwaysStoppedAnimation(1.0);
          route.buildPage(_FakeBuildContext(), anim, anim);
        },
      );
    });

    test(
      'unknown route name calls errorRoute and returns DesktopPageRoute',
      () {
        final routePage = makeDesktopRoutePage();
        final route =
            routePage.generateRoute(const RouteSettings(name: '/unknownRoute'))
                as DesktopPageRoute<Widget>;
        expect(route, isA<DesktopPageRoute<Widget>>());
        final anim = const AlwaysStoppedAnimation(1.0);
        route.buildPage(_FakeBuildContext(), anim, anim);
      },
    );

    test('errorRoute returns DesktopPageRoute', () {
      final routePage = makeDesktopRoutePage();
      final route =
          routePage.errorRoute(const RouteSettings(name: '/someError'))
              as DesktopPageRoute<Widget>;
      expect(route, isA<DesktopPageRoute<Widget>>());
      final anim = const AlwaysStoppedAnimation(1.0);
      route.buildPage(_FakeBuildContext(), anim, anim);
    });
  });

  group('DesktopRoutePage.mapStatus()', () {
    late MockWallet mockWallet;
    late MockNavigatorState mockNavigator;
    late MockNavigatorKey mockNavKey;

    setUp(() {
      mockWallet = MockWallet();
      mockNavigator = MockNavigatorState();
      mockNavKey = MockNavigatorKey(mockNavigator);

      when(
        () => mockNavigator.pushNamedAndRemoveUntil(any(), any()),
      ).thenAnswer((invocation) async {
        final predicate = invocation.positionalArguments[1] as RoutePredicate;
        predicate(_FakeRoute());
        return null;
      });
      when(() => mockNavigator.popUntil(any())).thenAnswer((invocation) {
        final predicate = invocation.positionalArguments[0] as RoutePredicate;
        predicate(_FakeRoute());
      });
      when(
        () => mockNavigator.pushReplacementNamed(any()),
      ).thenAnswer((_) async => null);
    });

    ProviderContainer makeContainer({
      required Status status,
      FirstLaunchStateType firstLaunchStateType =
          const FirstLaunchStateTypeEmpty(),
    }) {
      final container = ProviderContainer.test(
        overrides: [
          pageStatusProvider.overrideWithValue(status),
          firstLaunchStateProvider.overrideWithValue(firstLaunchStateType),
          navigatorKeyProvider.overrideWithValue(mockNavKey),
          walletProvider.overrideWithValue(mockWallet),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    group('simple pushNamedAndRemoveUntil statuses', () {
      final cases = {
        Status.walletLoading: RouteName.first,
        Status.noWallet: RouteName.noWallet,
        Status.selectEnv: RouteName.noWallet,
        Status.reviewLicense: RouteName.reviewLicense,
        Status.importWallet: RouteName.importWallet,
        Status.importWalletError: RouteName.importWalletError,
        Status.newWalletPinWelcome: RouteName.newWalletPinWelcome,
        Status.newWalletBackupPrompt: RouteName.newWalletBackupPrompt,
        Status.newWalletBackupView: RouteName.newWalletBackupView,
        Status.newWalletBackupCheck: RouteName.newWalletBackupCheck,
        Status.newWalletBackupCheckFailed: RouteName.newWalletBackupCheckFailed,
        Status.newWalletBackupCheckSucceed:
            RouteName.newWalletBackupCheckSucceed,
        Status.settingsPage: RouteName.settingsPage,
        Status.settingsBackup: RouteName.settingsBackup,
        Status.settingsDescriptors: RouteName.settingsDescriptors,
        Status.settingsAboutUs: RouteName.settingsAboutUs,
        Status.settingsNetwork: RouteName.settingsNetwork,
        Status.settingsLogs: RouteName.settingsLogs,
        Status.settingsCurrency: RouteName.settingsFiat,
        Status.ampRegister: RouteName.ampRegister,
        Status.stokrLogin: RouteName.stokrLogin,
        Status.pegxRegister: RouteName.pegxRegister,
        Status.pegxSubmitAmp: RouteName.pegxSubmitAmp,
        Status.pegxSubmitFinish: RouteName.pegxSubmitFinish,
        Status.jadeImport: RouteName.jadeImport,
        Status.stokrRestrictionsInfo: RouteName.stokrRestrictionsInfo,
        Status.stokrNeedRegister: RouteName.stokrNeedRegister,
        Status.networkAccessOnboarding: RouteName.networkAccessOnboarding,
      };

      for (final entry in cases.entries) {
        test('${entry.key} navigates to ${entry.value}', () async {
          final container = makeContainer(status: entry.key);
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          verify(
            () => mockNavigator.pushNamedAndRemoveUntil(entry.value, any()),
          ).called(1);
        });
      }
    });

    group('importWalletSuccess', () {
      test(
        'calls setImportWalletBiometricPrompt then navigates to registered',
        () async {
          when(
            () => mockWallet.setImportWalletBiometricPrompt(),
          ).thenAnswer((_) async {});

          final container = makeContainer(status: Status.importWalletSuccess);
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          verify(() => mockWallet.setImportWalletBiometricPrompt()).called(1);
          verify(
            () => mockNavigator.pushNamedAndRemoveUntil(
              RouteName.registered,
              any(),
            ),
          ).called(1);
        },
      );
    });

    group('pinWelcome / pinSetup', () {
      test(
        'when firstLaunchStateType == empty: pushNamedAndRemoveUntil with route.isFirst predicate',
        () async {
          final container = makeContainer(
            status: Status.pinWelcome,
            firstLaunchStateType: const FirstLaunchStateTypeEmpty(),
          );
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          // isFirst predicate branch — navigator still called with pinSetup
          verify(
            () => mockNavigator.pushNamedAndRemoveUntil(
              RouteName.pinSetup,
              any(),
            ),
          ).called(1);
        },
      );

      test(
        'when firstLaunchStateType != empty: pushNamedAndRemoveUntil with false predicate',
        () async {
          final container = makeContainer(
            status: Status.pinSetup,
            firstLaunchStateType: const FirstLaunchStateTypeCreateWallet(),
          );
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          verify(
            () => mockNavigator.pushNamedAndRemoveUntil(
              RouteName.pinSetup,
              any(),
            ),
          ).called(1);
        },
      );
    });

    group('pinSuccess', () {
      test(
        'when firstLaunchStateType == empty: navigates to pinSuccess route',
        () async {
          final container = makeContainer(
            status: Status.pinSuccess,
            firstLaunchStateType: const FirstLaunchStateTypeEmpty(),
          );
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          verify(
            () => mockNavigator.pushNamedAndRemoveUntil(
              RouteName.pinSuccess,
              any(),
            ),
          ).called(1);
          verifyNever(() => mockWallet.walletBiometricSkip());
        },
      );

      test(
        'when firstLaunchStateType == createWallet: calls walletBiometricSkip then newWalletBackupPrompt',
        () async {
          when(
            () => mockWallet.walletBiometricSkip(),
          ).thenAnswer((_) async => true);
          when(() => mockWallet.newWalletBackupPrompt()).thenReturn(null);

          final container = makeContainer(
            status: Status.pinSuccess,
            firstLaunchStateType: const FirstLaunchStateTypeCreateWallet(),
          );
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          verify(() => mockWallet.walletBiometricSkip()).called(1);
          verify(() => mockWallet.newWalletBackupPrompt()).called(1);
          verifyNever(
            () => mockNavigator.pushNamedAndRemoveUntil(any(), any()),
          );
        },
      );

      test(
        'when firstLaunchStateType == importWallet: calls walletBiometricSkip then setImportWalletBiometricPrompt',
        () async {
          when(
            () => mockWallet.walletBiometricSkip(),
          ).thenAnswer((_) async => true);
          when(
            () => mockWallet.setImportWalletBiometricPrompt(),
          ).thenAnswer((_) async {});

          final container = makeContainer(
            status: Status.pinSuccess,
            firstLaunchStateType: const FirstLaunchStateTypeImportWallet(),
          );
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          verify(() => mockWallet.walletBiometricSkip()).called(1);
          verify(() => mockWallet.setImportWalletBiometricPrompt()).called(1);
          verifyNever(
            () => mockNavigator.pushNamedAndRemoveUntil(any(), any()),
          );
        },
      );
    });

    group('registered', () {
      test(
        'when canPop is true: calls popUntil then pushReplacementNamed',
        () async {
          when(() => mockNavigator.canPop()).thenReturn(true);

          final container = makeContainer(status: Status.registered);
          final routePage = container.read(desktopRoutePageProvider);

          await routePage.mapStatus();

          verify(() => mockNavigator.canPop()).called(1);
          verify(() => mockNavigator.popUntil(any())).called(1);
          verify(
            () => mockNavigator.pushReplacementNamed(RouteName.registered),
          ).called(1);
        },
      );

      test('when canPop is false: calls only pushReplacementNamed', () async {
        when(() => mockNavigator.canPop()).thenReturn(false);

        final container = makeContainer(status: Status.registered);
        final routePage = container.read(desktopRoutePageProvider);

        await routePage.mapStatus();

        verify(() => mockNavigator.canPop()).called(1);
        verifyNever(() => mockNavigator.popUntil(any()));
        verify(
          () => mockNavigator.pushReplacementNamed(RouteName.registered),
        ).called(1);
      });
    });

    group('default (unhandled status)', () {
      // statuses not handled by mapStatus() fall through to the default logger.w branch
      final unhandledStatuses = [
        Status.lockedWalet,
        Status.importWalletBiometricPrompt,
        Status.newWalletBiometricPrompt,
        Status.assetsSelect,
        Status.assetDetails,
        Status.assetReceive,
        Status.assetReceiveFromWalletMain,
        Status.txDetails,
        Status.txEditMemo,
        Status.swapWaitPegTx,
        Status.swapTxDetails,
        Status.settingsSecurity,
        Status.paymentPage,
        Status.paymentAmountPage,
        Status.paymentSend,
        Status.generateWalletAddress,
        Status.walletAddressDetail,
        Status.transactions,
        Status.jadeBluetoothPermission,
        Status.jadeDevices,
        Status.jadeConnecting,
        Status.jadeLogin,
        Status.marketSwap,
        Status.marketLimit,
      ];

      for (final status in unhandledStatuses) {
        test('$status logs warning and does not navigate', () async {
          final container = makeContainer(status: status);
          final routePage = container.read(desktopRoutePageProvider);

          // should not throw; just logs warning
          await routePage.mapStatus();

          verifyNever(
            () => mockNavigator.pushNamedAndRemoveUntil(any(), any()),
          );
          verifyNever(() => mockNavigator.pushReplacementNamed(any()));
        });
      }
    });
  });
}
