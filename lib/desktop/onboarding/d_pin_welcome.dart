import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';

class DPinWelcome extends ConsumerWidget {
  const DPinWelcome({
    Key? key,
    this.onYesPressed,
    this.onNoPressed,
  }) : super(key: key);

  final void Function()? onYesPressed;
  final void Function()? onNoPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffoldPage(
      onEscapeKey: () {
        ref.read(pinSetupProvider).isNewWallet = false;
        ref.read(walletProvider).status = Status.noWallet;
      },
      content: Center(
        child: SizedBox(
          height: 640,
          child: Column(
            children: [
              const DPinWelcomeLogo(),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Do you wish to set a PIN to protect your wallet?'.tr(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Protect your wallet with the PIN'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: DCustomFilledBigButton(
                  child: Text('YES'.tr()),
                  width: 266,
                  height: 49,
                  onPressed: onYesPressed ??
                      () {
                        ref.read(pinSetupProvider).initPinSetupPinWelcome();
                      },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: DCustomTextBigButton(
                  width: 266,
                  height: 49,
                  child: Text('NOT NOW'.tr()),
                  onPressed: onNoPressed ??
                      () async {
                        await ref
                            .read(walletProvider)
                            .setImportWalletBiometricPrompt();
                      },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DPinWelcomeLogo extends StatelessWidget {
  const DPinWelcomeLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 376,
      height: 202,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SvgPicture.asset(
            'assets/locker2.svg',
            width: 156,
            height: 202,
          ),
        ],
      ),
    );
  }
}
