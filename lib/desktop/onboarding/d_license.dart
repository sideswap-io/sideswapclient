import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/first_launch_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class DLicense extends ConsumerWidget {
  const DLicense({super.key});

  Future<String> loadLicense() async {
    return await rootBundle.loadString('LICENSE');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstLaunchState = ref.watch(firstLaunchStateNotifierProvider);

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
          child: SingleChildScrollView(
            child: Center(
              child: FutureBuilder(
                future: loadLicense(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    );
                  }

                  return const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: SpinKitThreeBounce(color: Colors.white, size: 24),
                  );
                },
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
              FirstLaunchStateCreateWallet() =>
                await ref.read(walletProvider).setReviewLicenseCreateWallet(),
              _ => ref.read(walletProvider).startMnemonicImport(),
            };
          },
        ),
      ],
    );
  }
}
