import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share/share.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/markets/widgets/share_and_copy_buttons_row.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';

class CreateOrderSuccess extends StatelessWidget {
  const CreateOrderSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    OrderDetailsData orderDetailsData =
        context.read(walletProvider).orderDetailsData;

    return SideSwapPopup(
      onWillPop: () async {
        return false;
      },
      hideCloseButton: true,
      enableInsideTopPadding: false,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Order created'.tr(),
        topPadding: 40.h,
        descriptionWidget: Column(
          children: [
            OrderTable(
              orderDetailsData: orderDetailsData,
              orderTableRowType: OrderTableRowType.small,
            ),
            if (orderDetailsData.private) ...[
              Padding(
                padding: EdgeInsets.only(top: 30.h, bottom: 16.h),
                child: ShareAndCopyButtonsRow(
                  buttonWidth: 166.w,
                  onShare: () async {
                    await Share.share(context
                        .read(requestOrderProvider)
                        .getAddressToShare(orderDetailsData));
                  },
                  onCopy: () async {
                    await copyToClipboard(
                        context,
                        context
                            .read(requestOrderProvider)
                            .getAddressToShare(orderDetailsData));
                  },
                ),
              )
            ]
          ],
        ),
        buttonText: 'OK'.tr(),
        buttonBackgroundColor: orderDetailsData.private
            ? Colors.transparent
            : const Color(0xFF00C5FF),
        buttonSide: orderDetailsData.private
            ? BorderSide(color: const Color(0xFF00C5FF), width: 2.w)
            : null,
        onPressed: () {
          // clear old order data
          context.read(walletProvider).orderDetailsData =
              OrderDetailsData.empty();
          context.read(walletProvider).setRegistered();
        },
      ),
    );
  }
}
