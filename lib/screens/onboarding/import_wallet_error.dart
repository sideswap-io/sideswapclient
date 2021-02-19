import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ImportWalletError extends StatelessWidget {
  const ImportWalletError({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.error,
        header: 'Oops!'.tr(),
        description:
            'Your wallet could not be re-created. Please ensure the 12 words exactly matches your recovery seed.'
                .tr(),
        button: 'RETRY'.tr(),
        onPressed: () => context.read(walletProvider).startMnemonicImport(),
      ),
    );
  }
}
