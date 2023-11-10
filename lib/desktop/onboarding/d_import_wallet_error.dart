import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_error_icon.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/widgets/sideswap_popup_page.dart';
import 'package:sideswap/providers/wallet.dart';

class DImportWalletError extends ConsumerWidget {
  const DImportWalletError({super.key});

  void goBack(WidgetRef ref) {
    ref.read(walletProvider).startMnemonicImport();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapPopupPage(
      onClose: () {
        goBack(ref);
      },
      onEnterKey: () {
        logger.d('onEnter');
        goBack(ref);
      },
      constraints: const BoxConstraints(maxWidth: 628, maxHeight: 418),
      content: Center(
        child: SizedBox(
          width: 484,
          height: 239,
          child: Column(
            children: [
              const DErrorIcon(),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Oops!'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Your wallet could not be re-created. Please ensure the words exactly matches your recovery seed.'
                      .tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Center(
          child: DCustomFilledBigButton(
            width: 460,
            height: 49,
            onPressed: () {
              goBack(ref);
            },
            child: Text(
              'RETRY'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
