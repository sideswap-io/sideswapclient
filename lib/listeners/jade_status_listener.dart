import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/d_jade_info_dialog.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';

class JadeStatusListener extends HookConsumerWidget {
  const JadeStatusListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeStatus = ref.watch(jadeStatusNotifierProvider);
    final showAmpOnboarding =
        ref.watch(configurationProvider).showAmpOnboarding;
    final jadeInfoDialogRoute = ref.watch(jadeInfoDialogNotifierProvider);

    ref.listen(jadeStatusNotifierProvider, (previous, next) {
      if (previous == const JadeStatusMasterBlindingKey() &&
          next == const JadeStatusIdle()) {
        Future.microtask(() => ref
            .read(jadeOnboardingRegistrationNotifierProvider.notifier)
            .setState(const JadeOnboardingRegistrationStateDone()));
      }
    });

    useEffect(() {
      if (jadeStatus == const JadeStatusIdle() &&
          jadeInfoDialogRoute != null &&
          jadeInfoDialogRoute.isActive == true) {
        // close dialog
        Future.microtask(() {
          Navigator.of(context).removeRoute(jadeInfoDialogRoute);
          ref.read(jadeInfoDialogNotifierProvider.notifier).setState(null);
        });
      }

      if (jadeStatus != const JadeStatusIdle() && jadeInfoDialogRoute == null) {
        // open dialog
        Future.microtask(() {
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
        });
      }

      return;
    }, [jadeStatus, jadeInfoDialogRoute]);

    final jadeOnboardingRegistration =
        ref.watch(jadeOnboardingRegistrationNotifierProvider);

    useEffect(() {
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
