import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class LicenseTerms extends ConsumerWidget {
  const LicenseTerms({
    super.key,
  });

  Future<String> loadLicense() async {
    return await rootBundle.loadString('LICENSE');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstLaunchState = ref.watch(firstLaunchStateNotifierProvider);

    return SideSwapPopup(
      enableInsideHorizontalPadding: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 38, left: 16, right: 16),
            child: Text(
              'Terms and conditions'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Material(
                elevation: 3.0,
                color: Colors.transparent,
                shadowColor: const Color(0xFF1E6389),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 8, bottom: 8),
                  child: SingleChildScrollView(
                    child: Center(
                      child: FutureBuilder(
                        future: loadLicense(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            );
                          }

                          return const Padding(
                            padding: EdgeInsets.only(top: 32),
                            child: SpinKitThreeBounce(
                              color: Colors.white,
                              size: 24,
                            ),
                          );
                        },
                      ),
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
                      FirstLaunchStateCreateWallet() => await ref
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
