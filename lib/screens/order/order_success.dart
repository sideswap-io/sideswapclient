import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class OrderSuccess extends ConsumerWidget {
  const OrderSuccess({
    super.key,
    this.isResponse = false,
  });

  final bool isResponse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final orderData = context.read(walletProvider).orderDetailsData;
    return SideSwapPopup(
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: isResponse ? 'Response submitted' : 'Order submitted'.tr(),
        buttonText: 'OK'.tr(),
        onPressed: () {
          ref.read(walletProvider).goBack();
        },
      ),
    );
  }
}
