import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class WalletBackupCheckFailed extends ConsumerWidget {
  const WalletBackupCheckFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.error,
        header: 'Oops!'.tr(),
        description: 'You are selected the wrong words'.tr(),
        buttonText: 'RETRY'.tr(),
        onPressed: () => ref.read(walletProvider).goBack(),
        visibleSecondButton: true,
        secondButtonText: 'SEE MY 12 WORDS AGAIN'.tr(),
        onSecondButtonPressed: () =>
            ref.read(walletProvider).backupNewWalletEnable(),
      ),
    );
  }
}
