import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({
    Key? key,
    this.isResponse = false,
  }) : super(key: key);

  final bool isResponse;

  @override
  Widget build(BuildContext context) {
    // final orderData = context.read(walletProvider).orderDetailsData;
    return SideSwapPopup(
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: isResponse ? 'Response submitted' : 'Order submitted'.tr(),
        button: 'OK'.tr(),
        onPressed: () {
          context.read(walletProvider).goBack();
        },
      ),
    );
  }
}
