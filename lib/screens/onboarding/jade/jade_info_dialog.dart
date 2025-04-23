import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/jade_model.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/screens/onboarding/jade/widgets/jade_circular_progress_indicator.dart';

class JadeInfoDialog extends HookConsumerWidget {
  const JadeInfoDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jadeStatus = ref.watch(jadeStatusNotifierProvider);

    return switch (jadeStatus) {
      JadeStatusConnecting() => JadeInfoDialogWaitingInteraction(),
      JadeStatusMasterBlindingKey() => JadeInfoDialogMasterblinding(),
      JadeStatusAuthUser() => JadeInfoDialogEnterPin(),
      JadeStatusSignMessage() => JadeInfoDialogWaitingInteraction(
        text: 'Please sign to continue'.tr(),
      ),
      JadeStatusSignOfflineSwap() ||
      JadeStatusSignSwap() ||
      JadeStatusSignSwapOutput() ||
      JadeStatusSignTx() => JadeInfoDialogSign(),
      _ => const SizedBox(),
    };
  }
}

class JadeInfoDialogWaitingInteraction extends StatelessWidget {
  const JadeInfoDialogWaitingInteraction({this.text, super.key});

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 282,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          color: SideSwapColors.chathamsBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 56),
              const JadeCircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                text ?? 'Connecting to JADE'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JadeInfoDialogEnterPin extends StatelessWidget {
  const JadeInfoDialogEnterPin({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 282,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          color: SideSwapColors.chathamsBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 56),
              SvgPicture.asset('assets/jade_device_pin.svg'),
              const SizedBox(height: 24),
              Text(
                'Enter PIN on JADE'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JadeInfoDialogMasterblinding extends StatelessWidget {
  const JadeInfoDialogMasterblinding({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 377,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          color: SideSwapColors.chathamsBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 32),
              SvgPicture.asset('assets/jade_device_masterblinding.svg'),
              const SizedBox(height: 24),
              Text(
                'SideSwap needs the master blinding key from Jade'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                'To show balances and transactions on Liquid accounts up to 10x faster at every login, and it’s necessary to use Liquid singlesig accounts.'
                    .tr(),
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'Learn more'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: SideSwapColors.brightTurquoise,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JadeInfoDialogSign extends ConsumerWidget {
  const JadeInfoDialogSign({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionQuoteSuccess = ref.watch(
      previewOrderQuoteSuccessNotifierProvider,
    );
    final previewOrderTtl = ref.watch(previewOrderQuoteSuccessTtlProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 282,
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          color: SideSwapColors.chathamsBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 56),
              SvgPicture.asset('assets/jade_device_masterblinding.svg'),
              const SizedBox(height: 24),
              Text(
                'Sign transaction on JADE'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              optionQuoteSuccess.match(
                () {
                  return SizedBox();
                },
                (quoteSuccess) {
                  return Column(
                    children: [
                      SizedBox(height: 8),
                      SizedBox(
                        width: 150,
                        child: Row(
                          children: [
                            Text(
                              'Time-to-live'.tr(),
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: SideSwapColors.brightTurquoise,
                              ),
                            ),
                            Spacer(),
                            Text(
                              '$previewOrderTtl s.',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
