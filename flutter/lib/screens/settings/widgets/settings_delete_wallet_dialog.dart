import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/providers/wallet.dart';

void showDeleteWalletDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          width: 343,
          height: 437,
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
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: SideSwapColors.chathamsBlue,
                    border: Border.all(
                      color: SideSwapColors.bitterSweet,
                      style: BorderStyle.solid,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/delete.svg',
                      width: 20,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                          SideSwapColors.bitterSweet, BlendMode.srcIn),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Are you sure to delete wallet?'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: SizedBox(
                    height: 88,
                    child: SingleChildScrollView(
                      child: Text(
                        'Please make sure you have backed up your wallet before proceeding.'
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
                Consumer(
                  builder: (context, ref, _) {
                    return CustomBigButton(
                      width: 279,
                      height: 54,
                      text: 'YES'.tr(),
                      backgroundColor: SideSwapColors.brightTurquoise,
                      onPressed: () async {
                        final navigator =
                            Navigator.of(context, rootNavigator: true);
                        if (await ref.read(walletProvider).isAuthenticated()) {
                          await ref
                              .read(walletProvider)
                              .settingsDeletePromptConfirm();
                        }
                        navigator.pop();
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: CustomBigButton(
                    width: 279,
                    height: 54,
                    text: 'NO'.tr(),
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
