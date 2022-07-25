import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/onboarding/widgets/biometric_logo.dart';

class WalletBiometricPrompt extends StatelessWidget {
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  const WalletBiometricPrompt({
    super.key,
    required this.onYesPressed,
    required this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 56),
              child: BiometricLogo(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32, left: 40, right: 40),
              child: Text(
                'Do you wish to activate biometric authentication?'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                'Protect your keys by enabling biometric authentication'.tr(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomBigButton(
                width: double.infinity,
                height: 54,
                text: 'YES'.tr(),
                backgroundColor: const Color(0xFF00C5FF),
                onPressed: onYesPressed,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54,
                  text: 'NOT NOW'.tr(),
                  textColor: const Color(0xFF00C5FF),
                  backgroundColor: Colors.transparent,
                  onPressed: onNoPressed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
