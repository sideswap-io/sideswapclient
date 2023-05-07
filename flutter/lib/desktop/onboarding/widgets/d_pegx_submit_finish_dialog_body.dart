import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_amp_login_dialog_bottom_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/success_icon.dart';

class DPegxSubmitFinishDialogBody extends HookConsumerWidget {
  const DPegxSubmitFinishDialogBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ampId = ref.watch(ampIdProvider);
    final textTheme = ref.watch(desktopAppThemeProvider).textTheme;

    return SizedBox(
      width: 628,
      height: 400,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Text(
                'AMP ID was successfully submitted'.tr(),
                style: textTheme.bodyMedium,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: AmpIdPanel(
                  width: 355,
                  height: 36,
                  ampId: ampId,
                  backgroundColor: SideSwapColors.tarawera,
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: SuccessIcon(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: SideSwapColors.turquoise,
                      ),
                      icon: Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 95),
                child: DCustomFilledBigButton(
                  width: 460,
                  height: 49,
                  onPressed: () {
                    ref
                        .read(pageStatusStateProvider.notifier)
                        .setStatus(Status.ampRegister);
                  },
                  child: Text(
                    'FINISH'.tr(),
                  ),
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
          )
        ],
      ),
    );
  }
}
