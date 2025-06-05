import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';

class DJadeInfoDialog extends HookConsumerWidget {
  const DJadeInfoDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeStatus = ref.watch(jadeStatusNotifierProvider);
    final jadeOnboardingRegistration = ref.watch(
      jadeOnboardingRegistrationNotifierProvider,
    );
    final showAmpOnboarding =
        ref.watch(configurationProvider).showAmpOnboarding;
    final orderTtlState = ref.watch(orderTtlNotifierProvider);
    final orderSignTtl = ref.watch(orderSignTtlProvider);

    useEffect(() {
      if (jadeStatus != const JadeStatusMasterBlindingKey()) {
        return;
      }

      if (jadeOnboardingRegistration !=
          const JadeOnboardingRegistrationStateProcessing()) {
        return;
      }

      if (!showAmpOnboarding) {
        Future.microtask(
          () => ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered),
        );
        return;
      }

      return;
    }, [jadeStatus, jadeOnboardingRegistration, showAmpOnboarding]);

    return PopScope(
      canPop: false,
      child: DContentDialog(
        constraints: const BoxConstraints(minWidth: 200, minHeight: 100),
        style: const DContentDialogThemeData().merge(
          const DContentDialogThemeData(
            padding: EdgeInsets.zero,
            titlePadding: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            decoration: BoxDecoration(),
          ),
        ),
        content: Row(
          children: [
            const Spacer(),
            Container(
              constraints: const BoxConstraints(minWidth: 200, minHeight: 100),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: SideSwapColors.ataneoBlue,
                border: Border.all(
                  color: SideSwapColors.brightTurquoise,
                  width: 1.0,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 20,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SpinKitCircle(color: Colors.white, size: 32),
                        const SizedBox(width: 16),
                        Consumer(
                          builder: (context, ref, child) {
                            final jadeStatus = ref.watch(
                              jadeStatusNotifierProvider,
                            );

                            final statusText = switch (jadeStatus) {
                              JadeStatusIdle() => 'Idle'.tr(),
                              JadeStatusReadStatus() => 'Connecting...'.tr(),
                              JadeStatusAuthUser() => 'Please enter PIN'.tr(),
                              JadeStatusSignTx() => 'Please sign tx'.tr(),
                              JadeStatusMasterBlindingKey() =>
                                'Please allow master blinding key export'.tr(),
                              JadeStatusSignSwap() =>
                                'Sign swap transaction'.tr(),
                              JadeStatusSignSwapOutput() =>
                                'Create swap output'.tr(),
                              JadeStatusSignOfflineSwap() =>
                                'Sign offline swap transaction'.tr(),
                              JadeStatusSignMessage() =>
                                'Please sign to continue'.tr(),
                              _ => '',
                            };

                            return Column(
                              children: [
                                Text(statusText),
                                switch (orderTtlState) {
                                  OrderTtlStateEmpty() => const SizedBox(),
                                  _ => Column(
                                    children: [
                                      SizedBox(height: 8),
                                      SizedBox(
                                        width: 120,
                                        child: Row(
                                          children: [
                                            Text(
                                              'Time-to-live'.tr(),
                                              style: Theme.of(
                                                context,
                                              ).textTheme.titleSmall?.copyWith(
                                                color:
                                                    SideSwapColors
                                                        .brightTurquoise,
                                              ),
                                            ),
                                            Spacer(),
                                            Text('$orderSignTtl s.'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                },
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
