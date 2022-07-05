import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class ImportWalletError extends ConsumerWidget {
  const ImportWalletError({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopup(
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.error,
        header: 'Oops!'.tr(),
        description:
            'Your wallet could not be re-created. Please ensure the words exactly matches your recovery seed.'
                .tr(),
        buttonText: 'RETRY'.tr(),
        onPressed: () => ref.read(walletProvider).startMnemonicImport(),
      ),
    );
  }
}
