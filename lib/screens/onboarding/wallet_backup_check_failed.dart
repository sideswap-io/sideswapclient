import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class WalletBackupCheckFailed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.error,
        header: 'Oops!'.tr(),
        description: 'You are selected the wrong words'.tr(),
        button: 'RETRY'.tr(),
        onPressed: () => context.read(walletProvider).goBack(),
        visibleSecondButton: true,
        secondButton: 'SEE MY 12 WORDS AGAIN'.tr(),
        onSecondButtonPressed: () =>
            context.read(walletProvider).backupNewWalletEnable(),
      ),
    );
  }
}
