import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ImportWalletSuccess extends ConsumerWidget {
  const ImportWalletSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      onWillPop: () async {
        return false;
      },
      hideCloseButton: true,
      child: ResultPage(
          resultType: ResultPageType.success,
          header: 'Success!'.tr(),
          description:
              'You have successfully imported your wallet to this device'.tr(),
          buttonText: 'CONTINUE'.tr(),
          onPressed: () async {
            await ref.read(walletProvider).setPinWelcome();
          }),
    );
  }
}
