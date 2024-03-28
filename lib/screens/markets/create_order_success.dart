import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/order_details_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/result_page.dart';
import 'package:sideswap/screens/order/widgets/order_details.dart';
import 'package:sideswap/screens/markets/widgets/order_table_row.dart';
import 'package:sideswap/screens/markets/widgets/share_and_copy_buttons_row.dart';
import 'package:sideswap/screens/markets/widgets/order_table.dart';

class CreateOrderSuccess extends ConsumerWidget {
  const CreateOrderSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    OrderDetailsData orderDetailsData =
        ref.read(orderDetailsDataNotifierProvider);

    return SideSwapPopup(
      canPop: false,
      hideCloseButton: true,
      enableInsideTopPadding: false,
      child: ResultPage(
        resultType: ResultPageType.success,
        header: 'Order created'.tr(),
        topPadding: 40,
        descriptionWidget: Column(
          children: [
            OrderTable(
              orderDetailsData: orderDetailsData,
              orderTableRowType: OrderTableRowType.small,
            ),
            if (orderDetailsData.private) ...[
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 16),
                child: ShareAndCopyButtonsRow(
                  buttonWidth: 166,
                  onShare: () async {
                    await Share.share(ref.read(addressToShareByOrderIdProvider(
                        orderDetailsData.orderId)));
                  },
                  onCopy: () async {
                    await copyToClipboard(
                        context,
                        ref.read(addressToShareByOrderIdProvider(
                            orderDetailsData.orderId)));
                  },
                ),
              )
            ]
          ],
        ),
        buttonText: 'OK'.tr(),
        buttonBackgroundColor: orderDetailsData.private
            ? Colors.transparent
            : SideSwapColors.brightTurquoise,
        buttonSide: orderDetailsData.private
            ? const BorderSide(color: SideSwapColors.brightTurquoise, width: 2)
            : null,
        onPressed: () {
          // clear old order data
          ref
              .read(orderDetailsDataNotifierProvider.notifier)
              .setOrderDetailsData(OrderDetailsData.empty());
          ref
              .read(indexPriceSubscriberNotifierProvider.notifier)
              .unsubscribeAll();
          ref
              .read(pageStatusNotifierProvider.notifier)
              .setStatus(Status.registered);
        },
      ),
    );
  }
}
