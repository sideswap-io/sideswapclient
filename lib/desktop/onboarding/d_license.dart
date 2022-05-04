import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/license.dart';

class DLicense extends ConsumerWidget {
  const DLicense({Key? key, required this.nextStep}) : super(key: key);

  final LicenseNextStep nextStep;

  Future<String> loadLicense() async {
    return await rootBundle.loadString('LICENSE');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopupPage(
      onClose: () {
        ref.read(walletProvider).goBack();
      },
      constraints: const BoxConstraints(maxWidth: 628, maxHeight: 752),
      title: Center(
        child: Text(
          'Terms and conditions'.tr(),
          style: GoogleFonts.roboto(
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
                      style: GoogleFonts.roboto(
                        fontSize: 16,
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
      actions: [
        DCustomFilledBigButton(
          width: 580,
          height: 49,
          child: Text('I AGREE'.tr()),
          onPressed: () async {
            Navigator.pop(context);
            await ref.read(walletProvider).setLicenseAccepted();
            if (nextStep == LicenseNextStep.createWallet) {
              await ref.read(walletProvider).setReviewLicenseCreateWallet();
              return;
            }

            if (nextStep == LicenseNextStep.importWallet) {
              ref.read(walletProvider).startMnemonicImport();
            }
          },
        ),
      ],
    );
  }
}
