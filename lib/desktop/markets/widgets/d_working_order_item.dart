import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/button_styles.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/markets/widgets/d_edit_order_dialog.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_orders_row.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_order_amount.dart';
import 'package:sideswap/desktop/markets/widgets/d_working_order_button.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DWorkingOrderItem extends HookConsumerWidget {
  const DWorkingOrderItem({super.key, required this.order});

  final UiOwnOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// * set background to red when order expiration time is approaching
    final backgroundColor = useState(Colors.transparent);
    ref.listen(orderExpireDescriptionProvider(Option.of(order)), (_, _) {
      if (order.ttl != null && order.ttl! <= 5) {
        backgroundColor.value = SideSwapColors.bitterSweet.shade500;
      }
    });

    final isSell = order.tradeDir == TradeDir.SELL;
    final dirStr = isSell ? 'Sell'.tr() : 'Buy'.tr();
    final dirColor = isSell
        ? Theme.of(context).extension<MarketColorsStyle>()!.sellColor
        : Theme.of(context).extension<MarketColorsStyle>()!.buyColor;

    final showCancelDialogCallback = useCallback(() {
      return showDialog<bool>(
        context: context,
        builder: (context) {
          return HookBuilder(
            builder: (context) {
              final dialogCancelFocusNode = useFocusNode();

              useEffect(() {
                dialogCancelFocusNode.requestFocus();

                return;
              }, const []);

              return AlertDialog(
                title: Text('Delete order?'.tr()),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actions: <Widget>[
                  TextButton(
                    style: Theme.of(
                      context,
                    ).extension<SideswapYesButtonStyle>()!.style,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(true);
                    },
                    child: Text('Yes'.tr()).tr(),
                  ),
                  TextButton(
                    focusNode: dialogCancelFocusNode,
                    style: Theme.of(
                      context,
                    ).extension<SideswapNoButtonStyle>()!.style,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(false);
                    },
                    child: Text('No'.tr()).tr(),
                  ),
                ],
              );
            },
          );
        },
      );
    });

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      color: backgroundColor.value,
      child: DWorkingOrdersRow(
        children: [
          Row(
            children: [
              Text(order.productName),
              if (order.exclamationMark) ...[
                SizedBox(width: 6),
                Tooltip(
                  message:
                      'Order amount become less than the minimum after partially matching or there is no UTXOs'
                          .tr(),
                  child: Icon(
                    Icons.error_outline,
                    color: SideSwapColors.bitterSweet,
                  ),
                ),
              ],
              if (order.questionMark) ...[
                SizedBox(width: 6),
                Tooltip(
                  message: 'Not enough UTXOs to cover the requested amount'
                      .tr(),
                  child: Icon(Icons.warning_amber_rounded, color: Colors.amber),
                ),
              ],
            ],
          ),
          DWorkingOrderAmount(icon: order.amountIcon, text: order.amountString),
          DWorkingOrderAmount(icon: order.priceIcon, text: order.priceString),
          DWorkingOrderAmount(icon: order.priceIcon, text: order.total),
          Text(dirStr, style: TextStyle(color: dirColor)),
          Text(order.orderTypeDescription),
          Text(order.offlineSwapTypeDescription),
          Row(
            children: [
              Icon(Icons.schedule, size: 18),
              const SizedBox(width: 6),
              Consumer(
                builder: (context, ref, child) {
                  final expire = ref.watch(
                    orderExpireDescriptionProvider(Option.of(order)),
                  );
                  return Text(expire);
                },
              ),
              const Spacer(),
              if (order.orderType == OrderType.private()) ...[
                DWorkingOrderButton(
                  icon: Icon(Icons.content_copy_rounded, size: 20),
                  onPressed: () {
                    final shareUrl = ref.read(
                      addressToShareByOrderProvider(order),
                    );
                    copyToClipboard(context, shareUrl);
                  },
                ),
              ],
              if (order.offlineSwapType != OfflineSwapType.twoStep()) ...[
                DWorkingOrderButton(
                  icon: Icon(Icons.edit, size: 20),
                  onPressed: () async {
                    ref
                        .read(marketEditDetailsOrderNotifierProvider.notifier)
                        .setState(order);

                    await showDialog<void>(
                      context: context,
                      builder: (context) {
                        return DEditOrderDialog();
                      },
                      routeSettings: RouteSettings(name: orderEditRouteName),
                      useRootNavigator: false,
                    );

                    ref.invalidate(marketEditDetailsOrderNotifierProvider);
                  },
                ),
              ],
              DWorkingOrderButton(
                icon: Icon(Icons.delete_forever, size: 20),
                onPressed: () async {
                  final ret = await showCancelDialogCallback();

                  if (ret == true) {
                    final msg = To();
                    msg.orderCancel = To_OrderCancel(orderId: order.orderId);
                    ref.read(walletProvider).sendMsg(msg);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
