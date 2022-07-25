import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/swap_provider.dart';

void showInsufficientBalanceDialog(
    WidgetRef ref, BuildContext? context, String ticker) {
  if (context == null) {
    logger.w('Context is null');
    return;
  }

  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ), //this right here
        child: Container(
          width: 343,
          height: 378,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            color: Color(0xFF1C6086),
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
                    color: const Color(0xFF135579),
                    border: Border.all(
                      color: const Color(0xFFFF7878),
                      style: BorderStyle.solid,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/error.svg',
                      width: 20,
                      height: 22,
                      color: const Color(0xFFFF7878),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Text(
                    'Insufficient {} balance'.tr(args: [ticker]),
                    textAlign: TextAlign.center,
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
                    'Please swap a small amount for {} to pay for transaction fees'
                        .tr(args: [ticker]),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                const Spacer(),
                CustomBigButton(
                  width: double.maxFinite,
                  height: 54,
                  text: 'SWAP NOW'.tr(),
                  backgroundColor: const Color(0xFF00C5FF),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();

                    ref.read(swapProvider).selectSwap();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 14),
                  child: CustomBigButton(
                    width: double.maxFinite,
                    height: 54,
                    text: 'CANCEL'.tr(),
                    backgroundColor: Colors.transparent,
                    onPressed: () async {
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
