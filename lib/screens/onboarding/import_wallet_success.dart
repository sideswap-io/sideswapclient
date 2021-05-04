import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ImportWalletSuccess extends StatelessWidget {
  const ImportWalletSuccess({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          button: 'CONTINUE'.tr(),
          onPressed: () async {
            await context.read(walletProvider).setPinWelcome();
          }),
    );
  }
}
