import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MarketsBottomPanel extends ConsumerWidget {
  const MarketsBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.maxFinite,
      height: 102.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
        color: const Color(0xFF0F4766),
      ),
      child: Center(
        child: CustomBigButton(
          width: 343.w,
          height: 54.h,
          text: 'CREATE ORDER'.tr(),
          backgroundColor: const Color(0xFF00C5FF),
          onPressed: () {
            ref.read(walletProvider).setCreateOrderEntry();
          },
        ),
      ),
    );
  }
}
