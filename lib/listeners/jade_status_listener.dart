import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/styles/button_styles.dart';
import 'package:sideswap/desktop/d_jade_info_dialog.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/jade/jade_info_dialog.dart';

class JadeStatusListener extends HookConsumerWidget {
  const JadeStatusListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeLockState = ref.watch(jadeLockStateNotifierProvider);
    final jadeStatus = ref.watch(jadeStatusNotifierProvider);
    final showAmpOnboarding = ref
        .watch(configurationProvider)
        .showAmpOnboarding;
    final jadeInfoDialogRoute = ref.watch(jadeInfoDialogNotifierProvider);

    ref.listen(jadeStatusNotifierProvider, (previous, next) {
      if (previous == const JadeStatusSignMessage() &&
          next == const JadeStatusIdle()) {
        if (FlavorConfig.isDesktop) {
          Future.microtask(
            () => ref
                .read(jadeOnboardingRegistrationNotifierProvider.notifier)
                .setState(const JadeOnboardingRegistrationStateDone()),
          );
        } else {
          Future.microtask(() {
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      }
    });

    useEffect(() {
      if (jadeLockState is JadeLockStateError) {
        Future.microtask(() async {
          if (!context.mounted) return;
          await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Jade Unlock Error'),
                content: const Text(
                  'There was an error with the Jade unlock. Please try again.',
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      style: Theme.of(
                        context,
                      ).extension<SideswapYesButtonStyle>()!.style,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Close').tr(),
                    ),
                  ),
                ],
              );
            },
          );
          ref.invalidate(jadeLockStateNotifierProvider);
        });
      }
      return;
    }, [jadeLockState]);

    useEffect(() {
      if (jadeStatus == const JadeStatusIdle() &&
          jadeInfoDialogRoute != null &&
          jadeInfoDialogRoute.isActive == true) {
        // close dialog
        Future.microtask(() {
          if (context.mounted) {
            Navigator.of(context).removeRoute(jadeInfoDialogRoute);
            ref.read(jadeInfoDialogNotifierProvider.notifier).setState(null);
            // rest of MarketTradeRepository.makeSwapTrade
            ref.invalidate(previewOrderQuoteSuccessNotifierProvider);
          }
        });
      }

      if (jadeInfoDialogRoute != null && !jadeInfoDialogRoute.isActive) {
        Future.microtask(() {
          ref.read(jadeInfoDialogNotifierProvider.notifier).setState(null);
        });
      }

      if (jadeStatus != const JadeStatusIdle() && jadeInfoDialogRoute == null) {
        // open dialog
        if (FlavorConfig.isDesktop) {
          Future.microtask(() {
            if (context.mounted) {
              final dialogRoute = DialogRoute(
                context: context,
                builder: (context) {
                  return const DJadeInfoDialog();
                },
                barrierDismissible: false,
              );

              Navigator.of(context).push(dialogRoute);
              ref
                  .read(jadeInfoDialogNotifierProvider.notifier)
                  .setState(dialogRoute);
            }
          });
        } else {
          final CapturedThemes themes = InheritedTheme.capture(
            from: context,
            to: Navigator.of(context, rootNavigator: true).context,
          );

          Future.microtask(() {
            if (context.mounted) {
              final dialogRoute = DialogRoute(
                context: context,
                builder: (context) {
                  return const JadeInfoDialog();
                },
                barrierDismissible: false,
                barrierColor:
                    Theme.of(context).dialogTheme.barrierColor ??
                    Colors.black54,
                useSafeArea: true,
                traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
                themes: themes,
              );

              Navigator.of(context, rootNavigator: true).push(dialogRoute);
              ref
                  .read(jadeInfoDialogNotifierProvider.notifier)
                  .setState(dialogRoute);
            }
          });
        }
      }

      return;
    }, [jadeStatus, jadeInfoDialogRoute]);

    final jadeOnboardingRegistration = ref.watch(
      jadeOnboardingRegistrationNotifierProvider,
    );

    useEffect(() {
      if (!FlavorConfig.isDesktop) {
        return;
      }

      if (jadeOnboardingRegistration ==
          const JadeOnboardingRegistrationStateDone()) {
        Future.microtask(() {
          ref
              .read(jadeOnboardingRegistrationNotifierProvider.notifier)
              .setState(const JadeOnboardingRegistrationStateIdle());
        });
      }

      return;
    }, [jadeOnboardingRegistration, showAmpOnboarding]);

    return const SizedBox();
  }
}
