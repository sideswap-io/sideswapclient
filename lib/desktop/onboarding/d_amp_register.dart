import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/amp_service_register_box.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class DAmpRegister extends HookConsumerWidget {
  const DAmpRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stokrItems = ref.watch(stokrSecuritiesProvider);
    final pegxItems = ref.watch(pegxSecuritiesProvider);
    final ampId = ref.watch(ampIdNotifierProvider);
    final textTheme = ref.watch(
        desktopAppThemeNotifierProvider.select((value) => value.textTheme));
    final pegxLoginState = ref.watch(pegxLoginStateNotifierProvider);
    final registerFailedReason = ref.watch(pegxRegisterFailedNotifierProvider);
    final checkAmpStatus = ref.watch(checkAmpStatusProvider);

    useEffect(() {
      Future.microtask(() {
        ref.read(pegxWebsocketClientProvider).disconnect();
      });

      return;
    }, const []);

    useEffect(() {
      // check amp status again
      checkAmpStatus.refreshAmpStatus();

      return;
    }, [checkAmpStatus]);

    useEffect(() {
      Future.microtask(
        () => pegxLoginState.maybeWhen(
          loginDialog: () {
            ref
                .read(pageStatusStateProvider.notifier)
                .setStatus(Status.pegxRegister);
          },
          orElse: () {},
        ),
      );

      return;
    }, [pegxLoginState]);

    useEffect(() {
      if (registerFailedReason.isNotEmpty) {
        Future.microtask(() {
          final snackBar = SnackBar(
            content: Text(
              registerFailedReason,
              style: textTheme.titleSmall?.copyWith(color: Colors.white),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: SideSwapColors.chathamsBlue,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          ref.read(pegxRegisterFailedNotifierProvider.notifier).setState('');
        });
      }
      return;
    }, [registerFailedReason]);

    return Scaffold(
      body: SideSwapScaffoldPage(
        content: Padding(
          padding: const EdgeInsets.only(top: 70, bottom: 59),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Register your AMP ID to trade securities'.tr(),
                style: textTheme.titleLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AmpIdPanel(
                      width: 360,
                      ampId: ampId,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: SizedBox(
                  width: 581,
                  height: 333,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final stokrGaidState =
                              ref.watch(stokrGaidNotifierProvider);

                          return AmpServiceRegisterBox(
                            boxLogo: 'assets/stokr_logo.svg',
                            onPressed: (stokrGaidState ==
                                    const StokrGaidStateUnregistered())
                                ? () {
                                    ref
                                        .read(pageStatusStateProvider.notifier)
                                        .setStatus(Status.stokrLogin);
                                  }
                                : null,
                            items: stokrItems,
                            registered: (stokrGaidState ==
                                const StokrGaidStateRegistered()),
                            loading: (stokrGaidState ==
                                const StokrGaidStateLoading()),
                          );
                        },
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final pegxGaidState =
                              ref.watch(pegxGaidNotifierProvider);
                          final env = ref.watch(envProvider);
                          return AmpServiceRegisterBox(
                            boxLogo: 'assets/pegx_logo.svg',
                            onPressed: (pegxGaidState ==
                                        const PegxGaidStateUnregistered()) ||
                                    (env == SIDESWAP_ENV_TESTNET ||
                                        env == SIDESWAP_ENV_LOCAL_TESTNET)
                                ? () {
                                    ref
                                        .read(pegxLoginStateNotifierProvider
                                            .notifier)
                                        .setState(
                                            const PegxLoginStateLoginDialog());
                                  }
                                : null,
                            items: pegxItems,
                            registered: (pegxGaidState ==
                                const PegxGaidStateRegistered()),
                            loading:
                                (pegxGaidState == const PegxGaidStateLoading()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Consumer(
                builder: (context, ref, child) {
                  final stokrGaidState = ref.watch(stokrGaidNotifierProvider);
                  final textTheme =
                      ref.watch(desktopAppThemeNotifierProvider).textTheme;

                  return stokrGaidState.maybeWhen(
                    registered: () {
                      return DCustomFilledBigButton(
                        width: 460,
                        onPressed: () {
                          ref
                              .read(configurationProvider.notifier)
                              .setShowAmpOnboarding(false);
                          ref.read(walletProvider).setRegistered();
                        },
                        child:
                            Text('CONTINUE'.tr(), style: textTheme.labelLarge),
                      );
                    },
                    orElse: () {
                      return DCustomTextBigButton(
                        width: 460,
                        onPressed: () {
                          ref
                              .read(configurationProvider.notifier)
                              .setShowAmpOnboarding(false);
                          ref.read(walletProvider).setRegistered();
                        },
                        child: Text(
                          'NOT NOW'.tr(),
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: SideSwapColors.brightTurquoise,
                                  ),
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'If you skip this step, you can do so at a later date by pressing the AMP ID "icon" on desktop'
                      .tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: SideSwapColors.hippieBlue, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
