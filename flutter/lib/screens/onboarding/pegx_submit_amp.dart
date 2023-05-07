import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/success_icon.dart';

class PegxSubmitAmp extends HookConsumerWidget {
  const PegxSubmitAmp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ampId = ref.watch(ampIdProvider);
    final pegxLoginState = ref.watch(pegxLoginStateProvider);
    final gaidWaiting = useState(false);

    var registered = pegxLoginState.maybeWhen<bool>(
      gaidAdded: () {
        return true;
      },
      orElse: () {
        return false;
      },
    );

    useEffect(() {
      Future.microtask(
        () => pegxLoginState.maybeWhen(
          gaidWaiting: () {
            gaidWaiting.value = true;
          },
          gaidError: () {
            ref.read(pegxLoginStateProvider.notifier).state =
                const PegxLoginStateLoading();
            ref
                .read(pegxWebsocketClientProvider)
                .errorAndGoBack('Adding AMP ID failed. Try again.'.tr());
          },
          orElse: () {},
        ),
      );

      return;
    }, [pegxLoginState]);

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      onClose: () {
        ref.read(pegxLoginStateProvider.notifier).state =
            const PegxLoginStateLoading();
        ref
            .read(pageStatusStateProvider.notifier)
            .setStatus(Status.ampRegister);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/pegx_logo.svg',
              width: 104,
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                height: 44,
                child: Text(
                  registered
                      ? 'AMP ID was successfully submitted'.tr()
                      : 'Do you want to submit new AMP ID for the current wallet?'
                          .tr(),
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 18),
              child: AmpIdPanel(
                height: 48,
                ampId: ampId,
                backgroundColor: SideSwapColors.tarawera,
                prefixTextStyle: Theme.of(context).textTheme.titleSmall?.merge(
                    const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: SideSwapColors.brightTurquoise)),
                icon: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 8),
                  child: SuccessIcon(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: registered
                          ? SideSwapColors.turquoise
                          : Colors.transparent,
                    ),
                    icon: Icon(
                      registered ? Icons.done : Icons.add,
                      color: registered
                          ? Colors.white
                          : SideSwapColors.brightTurquoise,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (registered) ...[
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 12),
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54,
                  backgroundColor: SideSwapColors.brightTurquoise,
                  onPressed: () {
                    ref.read(pegxLoginStateProvider.notifier).state =
                        const PegxLoginStateLoading();
                    ref
                        .read(pageStatusStateProvider.notifier)
                        .setStatus(Status.ampRegister);
                  },
                  child: Text(
                    'FINISH'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ] else ...[
              CustomBigButton(
                width: double.infinity,
                height: 54,
                backgroundColor: SideSwapColors.brightTurquoise,
                onPressed: gaidWaiting.value
                    ? null
                    : () {
                        ref.read(pegxWebsocketClientProvider).addGaid();
                      },
                child: Row(
                  children: [
                    const Spacer(),
                    Text(
                      'YES'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          Visibility(
                            visible: gaidWaiting.value,
                            child: const SpinKitCircle(
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 12),
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54,
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    ref.read(pegxLoginStateProvider.notifier).state =
                        const PegxLoginStateLoading();
                    ref
                        .read(pageStatusStateProvider.notifier)
                        .setStatus(Status.ampRegister);
                  },
                  child: Text(
                    'CANCEL'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
