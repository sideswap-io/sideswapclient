import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/screens/swap/widgets/swap_button.dart';

class WalletTypeButtons extends HookConsumerWidget {
  const WalletTypeButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxButtonWidth = constraints.maxWidth / 2;
        final maxTextWidth = maxButtonWidth - 65 - 18;

        return Container(
          width: constraints.maxWidth,
          height: 36,
          decoration: const BoxDecoration(
            color: SideSwapColors.prussianBlue,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SwapButton(
                color:
                    selectedAccountType == AccountType.reg
                        ? SideSwapColors.cyanCornflowerBlue
                        : SideSwapColors.prussianBlue,
                onPressed: () {
                  ref
                      .read(selectedAccountTypeNotifierProvider.notifier)
                      .setAccountType(AccountType.reg);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: maxTextWidth,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Regular wallet'.tr(),
                            maxLines: 1,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color:
                                  selectedAccountType == AccountType.reg
                                      ? Colors.white
                                      : SideSwapColors.ceruleanFrost,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      WalletTypeIcon(
                        text: 'Singlesig',
                        enabled: selectedAccountType == AccountType.reg,
                      ),
                    ],
                  ),
                ),
              ),
              SwapButton(
                color:
                    selectedAccountType == AccountType.amp
                        ? SideSwapColors.cyanCornflowerBlue
                        : SideSwapColors.prussianBlue,
                onPressed: () {
                  ref
                      .read(selectedAccountTypeNotifierProvider.notifier)
                      .setAccountType(AccountType.amp);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: maxTextWidth,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'AMP wallet'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                              color:
                                  selectedAccountType == AccountType.amp
                                      ? Colors.white
                                      : SideSwapColors.ceruleanFrost,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      WalletTypeIcon(
                        text: 'Multisig',
                        enabled: selectedAccountType == AccountType.amp,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class WalletTypeIcon extends StatelessWidget {
  const WalletTypeIcon({
    super.key,
    this.text,
    this.backgroundColor = SideSwapColors.brightTurquoise,
    this.enabled = true,
  });

  final String? text;
  final Color? backgroundColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration:
          enabled
              ? ShapeDecoration(
                color: SideSwapColors.brightTurquoise,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(56),
                ),
              )
              : ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: SideSwapColors.ceruleanFrost,
                  ),
                  borderRadius: BorderRadius.circular(56),
                ),
              ),
      child: Center(
        child: Text(
          text ?? '',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: enabled ? Colors.white : SideSwapColors.ceruleanFrost,
          ),
        ),
      ),
    );
  }
}
