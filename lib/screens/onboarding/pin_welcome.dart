import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';

class PinWelcome extends StatelessWidget {
  const PinWelcome({
    super.key,
    this.onYesPressed,
    this.onNoPressed,
  });

  final VoidCallback? onYesPressed;
  final VoidCallback? onNoPressed;

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: PinWelcomeBody(
                    onYesPressed: onYesPressed,
                    onNoPressed: onNoPressed,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PinWelcomeBody extends ConsumerWidget {
  const PinWelcomeBody({
    super.key,
    this.onYesPressed,
    this.onNoPressed,
  });

  final VoidCallback? onYesPressed;
  final VoidCallback? onNoPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 56),
              child: SvgPicture.asset(
                'assets/locker2.svg',
                width: 156,
                height: 202,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Text(
                'Do you wish to set a PIN to protect your wallet?'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Protect your wallet with the PIN'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            CustomBigButton(
              width: double.maxFinite,
              height: 54,
              backgroundColor: SideSwapColors.brightTurquoise,
              text: 'YES'.tr(),
              onPressed: onYesPressed ??
                  () {
                    ref.read(pinHelperProvider).initPinSetupPinWelcome();
                  },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: CustomBigButton(
                width: double.maxFinite,
                height: 54,
                backgroundColor: Colors.transparent,
                text: 'NOT NOW'.tr(),
                textColor: SideSwapColors.brightTurquoise,
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
    );
  }
}
