import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/env_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/amp_service_register_box.dart';
import 'package:sideswap/side_swap_client_ffi.dart';

class AmpRegister extends HookConsumerWidget {
  const AmpRegister({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ampId = ref.watch(ampIdNotifierProvider);
    final stokrItems = ref.watch(stokrSecuritiesProvider);
    final pegxItems = ref.watch(pegxSecuritiesProvider);
    final pegxLoginState = ref.watch(pegxLoginStateNotifierProvider);
    final registerFailedReason = ref.watch(pegxRegisterFailedNotifierProvider);
    final checkAmpStatus = ref.watch(checkAmpStatusProvider);

    useEffect(() {
      // check amp status again
      checkAmpStatus.refreshAmpStatus();

      return;
    }, [checkAmpStatus]);

    useEffect(() {
      Future.microtask(
        () =>
            switch (pegxLoginState) {
              PegxLoginStateLoginDialog() => () {
                ref
                    .read(pageStatusNotifierProvider.notifier)
                    .setStatus(Status.pegxRegister);
              },
              PegxLoginStateLoading() => () {
                ref.read(pegxWebsocketClientProvider).disconnect();
              },
              _ => () {},
            }(),
      );

      return;
    }, [pegxLoginState]);

    useEffect(() {
      if (registerFailedReason.isEmpty) {
        return;
      }

      Future.microtask(() {
        if (context.mounted) {
          final snackBar = SnackBar(
            content: Text(
              registerFailedReason,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(color: Colors.white),
            ),
            duration: const Duration(seconds: 3),
            backgroundColor: SideSwapColors.chathamsBlue,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          ref.read(pegxRegisterFailedNotifierProvider.notifier).setState('');
        }
      });

      return;
    }, [registerFailedReason]);

    return SideSwapScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 21,
                              left: 24,
                              right: 24,
                            ),
                            child: Text(
                              'Register your AMP ID to trade securities'.tr(),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(letterSpacing: .22, height: 1.27),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: AmpIdPanel(
                              width: double.infinity,
                              height: 48,
                              ampId: ampId,
                              copyIconWidth: 22,
                              copyIconHeight: 22,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer(
                                  builder: (context, ref, child) {
                                    final stokrGaidState = ref.watch(
                                      stokrGaidNotifierProvider,
                                    );

                                    return AmpServiceRegisterBox(
                                      width: 170,
                                      height: 340,
                                      boxLogo: 'assets/stokr_logo.svg',
                                      items: stokrItems,
                                      registered:
                                          (stokrGaidState ==
                                              const StokrGaidStateRegistered()),
                                      loading:
                                          (stokrGaidState ==
                                              const StokrGaidStateLoading()),
                                      onPressed:
                                          (stokrGaidState ==
                                                  const StokrGaidStateUnregistered())
                                              ? () {
                                                ref
                                                    .read(
                                                      pageStatusNotifierProvider
                                                          .notifier,
                                                    )
                                                    .setStatus(
                                                      Status.stokrLogin,
                                                    );
                                              }
                                              : null,
                                    );
                                  },
                                ),
                                Consumer(
                                  builder: (context, ref, child) {
                                    final pegxGaidState = ref.watch(
                                      pegxGaidNotifierProvider,
                                    );
                                    final env = ref.watch(envProvider);

                                    return AmpServiceRegisterBox(
                                      width: 170,
                                      height: 340,
                                      boxLogo: 'assets/pegx_logo.svg',
                                      items: pegxItems,
                                      registered:
                                          (pegxGaidState ==
                                              const PegxGaidStateRegistered()),
                                      loading:
                                          (pegxGaidState ==
                                              const PegxGaidStateLoading()),
                                      onPressed:
                                          (pegxGaidState ==
                                                      const PegxGaidStateUnregistered()) ||
                                                  (env ==
                                                          SIDESWAP_ENV_TESTNET ||
                                                      env ==
                                                          SIDESWAP_ENV_LOCAL_TESTNET)
                                              ? () {
                                                ref
                                                    .read(
                                                      pegxLoginStateNotifierProvider
                                                          .notifier,
                                                    )
                                                    .setState(
                                                      const PegxLoginStateLoginDialog(),
                                                    );
                                              }
                                              : null,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          CustomBigButton(
                            width: double.infinity,
                            backgroundColor: SideSwapColors.brightTurquoise,
                            onPressed: () async {
                              if (ref
                                  .read(configurationProvider)
                                  .showAmpOnboarding) {
                                ref
                                    .read(pageStatusNotifierProvider.notifier)
                                    .setStatus(Status.registered);
                              } else {
                                ref
                                    .read(pageStatusNotifierProvider.notifier)
                                    .setStatus(Status.settingsPage);
                              }

                              ref
                                  .read(configurationProvider.notifier)
                                  .setShowAmpOnboarding(false);
                            },
                            child: Text('NOT NOW'.tr()),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 23, top: 10),
                            child: Text(
                              'If you skip this step, you can do so at a later date by pressing the AMP ID "icon" on desktop'
                                  .tr(),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: SideSwapColors.hippieBlue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
