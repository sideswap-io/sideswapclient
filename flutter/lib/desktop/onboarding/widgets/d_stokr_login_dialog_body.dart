import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_amp_login_dialog_bottom_panel.dart';
import 'package:sideswap/screens/onboarding/widgets/stokr_login_panels.dart';

class DStokrLoginDialogBody extends StatelessWidget {
  const DStokrLoginDialogBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 628,
      height: 400,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 84),
            child: Column(
              children: [
                const StokrLoginPanels(),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 95),
                  child: DCustomFilledBigButton(
                    width: double.infinity,
                    onPressed: () {
                      openUrl('https://stokr.io/signup');
                    },
                    child: Text(
                      'OPEN IN BROWSER'.tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: DAmpLoginDialogBottomPanel(
              url: 'https://stokr.io',
              urlText: 'stokr.io',
            ),
          )
        ],
      ),
    );
  }
}
