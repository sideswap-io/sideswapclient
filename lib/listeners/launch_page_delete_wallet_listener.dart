import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/delete_wallet_providers.dart';
import 'package:sideswap/providers/wallet.dart';

class LaunchPageDeleteWalletListener extends ConsumerWidget {
  const LaunchPageDeleteWalletListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(launchPageDeleteWalletNotifierProvider, (_, next) async {
      if (next is LaunchPageDeleteWalletStateDelete) {
        final ret = await showDialog<bool>(
          useRootNavigator: false,
          barrierDismissible: false,
          context: context,
          builder: (_) => const DeleteWalletConfirmationDialog(),
        );

        ref.invalidate(launchPageDeleteWalletNotifierProvider);

        if (ret == true) {
          ref.read(walletProvider).deleteWalletAndCleanup();
        }
      }
    });

    return Container();
  }
}

class DeleteWalletConfirmation extends ConsumerWidget {
  const DeleteWalletConfirmation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}

class DeleteWalletConfirmationDialog extends ConsumerWidget {
  const DeleteWalletConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).defaultDialogTheme;

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 250),
      style: const DContentDialogThemeData().merge(
        defaultDialogTheme.merge(
          const DContentDialogThemeData(
            titlePadding: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.all(20),
        child: DContentDialogTitle(
          content: Text(
            'Delete wallet'.tr(),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          onClose: () {
            Navigator.pop(context, false);
          },
        ),
      ),
      content: SizedBox(
        width: 400,
        height: 150,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                'Are you sure to delete wallet?'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DCustomFilledBigButton(
                    width: 150,
                    height: 35,
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text('YES'.tr()),
                  ),
                  DCustomFilledBigButton(
                    width: 150,
                    height: 35,
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('NO'.tr()),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
