import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_terms_viewer/flutter_terms_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/gpl_license.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class LicenseTerms extends ConsumerWidget {
  const LicenseTerms({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstLaunchState = ref.watch(firstLaunchStateProvider);

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 38, left: 16, right: 16),
            child: Text(
              'Terms and conditions'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: Material(
              elevation: 3.0,
              color: Colors.transparent,
              shadowColor: const Color(0xFF1E6389),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 8,
                  top: 8,
                  bottom: 8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TermsViewer(
                          data: Terms.from(kMappedEnAgreements),
                          titleStyleBuilder: (data, style, index) {
                            return style.copyWith(fontSize: 16);
                          },
                          textStyleBuilder: (data, style, index) {
                            return style.copyWith(fontSize: 14);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 126,
            color: const Color(0xFF1E6389),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Center(
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54,
                  text: 'I AGREE'.tr(),
                  backgroundColor: SideSwapColors.brightTurquoise,
                  onPressed: () async {
                    ref.read(walletProvider).setLicenseAccepted();
                    return switch (firstLaunchState) {
                      FirstLaunchStateTypeCreateWallet() =>
                        await ref
                            .read(walletProvider)
                            .setReviewLicenseCreateWallet(),
                      _ => ref.read(walletProvider).startMnemonicImport(),
                    };
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
