import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/allow_tx_chaining_button.dart';
import 'package:sideswap/providers/config_provider.dart';

Future<bool> allowTxChaining(BuildContext context, WidgetRef ref) async {
  final hideTxChainingPromptValue =
      ref.read(configurationProvider).hideTxChainingPromptValue;

  if (hideTxChainingPromptValue) {
    return true;
  }

  final result = await showDialog<AllowTxChaining>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: const AllowTxChainingWidget(),
      );
    },
  );

  if (result == AllowTxChaining.always) {
    ref.read(configurationProvider.notifier).setHideTxChainingPromptValue(true);
  }

  return result == AllowTxChaining.always || result == AllowTxChaining.once;
}

enum AllowTxChaining {
  no,
  once,
  always,
}

class AllowTxChainingWidget extends StatelessWidget {
  const AllowTxChainingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 460,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: SideSwapColors.blumine,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 28,
              child: SvgPicture.asset(
                'assets/info.svg',
                width: 13,
                height: 32,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: SizedBox(
                height: 110,
                child: SingleChildScrollView(
                  child: Text(
                    'Offline swaps may not have a return balance. Do you wish to auto-create the correct input amount when submitting your order?'
                        .tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Spacer(),
            AllowTxChainingButton(
              text: 'Yes, only once'.tr(),
              value: AllowTxChaining.once,
            ),
            const SizedBox(height: 12),
            AllowTxChainingButton(
              text: 'Yes, do not ask me again'.tr(),
              value: AllowTxChaining.always,
            ),
            const SizedBox(height: 12),
            AllowTxChainingButton(
              text: 'Cancel'.tr(),
              value: AllowTxChaining.no,
            ),
          ],
        ),
      ),
    );
  }
}
