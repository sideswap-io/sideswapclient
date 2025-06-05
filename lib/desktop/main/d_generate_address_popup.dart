import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/main/widgets/d_option_generate_widget.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DGenerateAddressPopup extends HookConsumerWidget {
  const DGenerateAddressPopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);

    useEffect(() {
      Future.microtask(() {
        ref.invalidate(currentReceiveAddressProvider);
        ref.invalidate(selectedAccountTypeNotifierProvider);
      });

      return;
    }, const []);

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 505),
      title: DContentDialogTitle(
        content: Text('Generate address'.tr()),
        onClose: () {
          Navigator.of(context).pop();
        },
      ),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Text(
              'Select address type'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(2),
            width: 500,
            height: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: SideSwapColors.tarawera,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DOptionGenerateWidget(
                  isSelected: selectedAccountType == Account.REG,
                  assetIcon: 'assets/regular_wallet.svg',
                  title: 'Regular wallet'.tr(),
                  subTitle: 'Single-signature wallet'.tr(),
                  message:
                      'Your default wallet which contains asset are secured by a single key under your control.'
                          .tr(),
                  onPressed: () {
                    if (selectedAccountType == Account.REG) {
                      Navigator.pop(context);
                      ref.read(desktopDialogProvider).showRecvAddress();
                      return;
                    }

                    ref
                        .read(selectedAccountTypeNotifierProvider.notifier)
                        .setAccountType(Account.REG);
                  },
                ),
                const SizedBox(width: 2),
                DOptionGenerateWidget(
                  isSelected: selectedAccountType == Account.AMP_,
                  assetIcon: 'assets/amp_wallet.svg',
                  title: 'AMP Securities wallet'.tr(),
                  subTitle: '2-of-2 multi-signature wallet'.tr(),
                  message:
                      'Your securities wallet which may hold Transfer Restricted assets, such as BMN or SSWP, which require the issuer to co-sign and approve transactions.'
                          .tr(),
                  onPressed: () {
                    if (selectedAccountType == Account.AMP_) {
                      Navigator.pop(context);
                      ref.read(desktopDialogProvider).showRecvAddress();
                      return;
                    }

                    ref
                        .read(selectedAccountTypeNotifierProvider.notifier)
                        .setAccountType(Account.AMP_);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          DCustomButton(
            height: 44,
            isFilled: true,
            onPressed: () {
              Navigator.pop(context);
              ref.read(desktopDialogProvider).showRecvAddress();
            },
            child: Text('GENERATE'.tr()),
          ),
        ],
      ),
    );
  }
}
