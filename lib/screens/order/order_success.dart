import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = context.read(walletProvider).orderDetailsData;
    return SideSwapPopup(
      hideCloseButton: true,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Order submitted'.tr(),
        descriptionWidget: OrderDetails(
          placeOrderData: orderData,
        ),
        button: 'OK'.tr(),
        onPressed: () {
          context.read(walletProvider).goBack();
        },
      ),
    );
  }
}
