import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_terms_viewer/flutter_terms_viewer.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/gpl_license.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class DLicense extends ConsumerWidget {
  const DLicense({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstLaunchState = ref.watch(firstLaunchStateProvider);

    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).goBack();
      },
      constraints: const BoxConstraints(maxWidth: 628, maxHeight: 752),
      title: Center(
        child: Text(
          'Terms and conditions'.tr(),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      content: SizedBox(
        height: 550,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
      ),
      actions: [
        DCustomFilledBigButton(
          width: 580,
          height: 49,
          child: Text('I AGREE'.tr()),
          onPressed: () async {
            Navigator.pop(context);
            ref.read(walletProvider).setLicenseAccepted();
            return switch (firstLaunchState) {
              FirstLaunchStateTypeCreateWallet() =>
                await ref.read(walletProvider).setReviewLicenseCreateWallet(),
              _ => ref.read(walletProvider).startMnemonicImport(),
            };
          },
        ),
      ],
    );
  }
}
