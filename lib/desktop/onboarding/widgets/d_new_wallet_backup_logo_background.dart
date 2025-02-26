import 'package:flutter/material.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_new_wallet_backup_logo.dart';

class DNewWalletBackupLogoBackground extends StatelessWidget {
  const DNewWalletBackupLogoBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const SizedBox(height: 640, child: DNewWalletBackupLogo()),
        Container(color: Colors.black.withValues(alpha: 0.5)),
      ],
    );
  }
}
