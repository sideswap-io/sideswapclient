import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/stokr_bottom_panel.dart';
import 'package:sideswap/screens/onboarding/widgets/stokr_login_panels.dart';
import 'package:url_launcher/url_launcher.dart';

class StokrLogin extends HookConsumerWidget {
  const StokrLogin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      onClose: () {
        ref.invalidate(stokrGaidNotifierProvider);
        ref.invalidate(pegxGaidNotifierProvider);
        ref.read(walletProvider).goBack();
      },
      bottomNavigationBar: const StokrBottomPanel(),
      child: Column(
        children: [
          SvgPicture.asset('assets/stokr_logo.svg', width: 104, height: 24),
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: StokrLoginPanels(),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: CustomBigButton(
              width: double.infinity,
              height: 54,
              backgroundColor: SideSwapColors.brightTurquoise,
              onPressed: () async {
                await openUrl(
                  'https://stokr.io/signup',
                  mode: LaunchMode.externalNonBrowserApplication,
                );
              },
              child: Text('OPEN IN BROWSER'.tr()),
            ),
          ),
        ],
      ),
    );
  }
}
