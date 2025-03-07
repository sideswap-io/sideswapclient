import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_amp_login_dialog_bottom_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/success_icon.dart';

class DPegxSubmitAmpDialogBody extends HookConsumerWidget {
  const DPegxSubmitAmpDialogBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ampId = ref.watch(ampIdNotifierProvider);
    final textTheme = ref.watch(desktopAppThemeNotifierProvider).textTheme;
    final pegxLoginState = ref.watch(pegxLoginStateNotifierProvider);
    final gaidWaiting = useState(false);

    useEffect(() {
      Future.microtask(
        () =>
            (switch (pegxLoginState) {
              PegxLoginStateGaidWaiting() => () {
                gaidWaiting.value = true;
              },
              PegxLoginStateGaidAdded() => () {
                ref
                    .read(pageStatusNotifierProvider.notifier)
                    .setStatus(Status.pegxSubmitFinish);
              },
              PegxLoginStateGaidError() => () {
                ref
                    .read(pegxWebsocketClientProvider)
                    .errorAndGoBack(
                      'Adding AMP ID failed or cancelled by the user'.tr(),
                    );
              },
              _ => () {},
            }()),
      );

      return;
    }, [pegxLoginState]);

    return SizedBox(
      width: 628,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                'Do you want to submit new AMP ID for the current wallet?'.tr(),
                style: textTheme.bodyMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: AmpIdPanel(
                  width: 355,
                  height: 36,
                  ampId: ampId,
                  backgroundColor: SideSwapColors.chathamsBlue,
                  prefixTextStyle: textTheme.titleSmall?.merge(
                    const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 10, right: 8),
                    child: SuccessIcon(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      icon: Icon(
                        Icons.add,
                        color: SideSwapColors.brightTurquoise,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: gaidWaiting.value,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'The request has been sent. Please open your Authenticate eID app and sign to add your AMP ID.'
                        .tr(),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 95),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DCustomTextBigButton(
                      width: 245,
                      height: 49,
                      onPressed: () {
                        ref
                            .read(pageStatusNotifierProvider.notifier)
                            .setStatus(Status.ampRegister);
                      },
                      child: Text('CANCEL'.tr()),
                    ),
                    const SizedBox(width: 10),
                    DCustomFilledBigButton(
                      width: 245,
                      height: 49,
                      onPressed:
                          gaidWaiting.value
                              ? null
                              : () {
                                ref.read(pegxWebsocketClientProvider).addGaid();
                              },
                      child: Row(
                        children: [
                          const Spacer(),
                          Text('YES'.tr()),
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
                  ],
                ),
              ),
            ],
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: DAmpLoginDialogBottomPanel(
              url: 'https://pegx.io',
              urlText: 'pegx.io',
            ),
          ),
        ],
      ),
    );
  }
}
