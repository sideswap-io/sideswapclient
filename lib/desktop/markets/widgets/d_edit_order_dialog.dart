import 'package:easy_localization/easy_localization.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/button_styles.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/common/button/d_custom_button.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/screens/markets/widgets/market_amount_text_field.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

const orderEditRouteName = '/desktopOrderEdit';

class DEditOrderDialog extends HookConsumerWidget {
  const DEditOrderDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeNotifierProvider)
        .dialogTheme
        .merge(
          const DContentDialogThemeData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: SideSwapColors.blumine,
            ),
          ),
        );

    final optionOrder = ref.watch(marketEditDetailsOrderNotifierProvider);

    final closeCallback = useCallback(() {
      Navigator.of(context, rootNavigator: false).popUntil((route) {
        return route.settings.name != orderEditRouteName;
      });
    });

    final editAmountController = useTextEditingController();
    final amountFocusNode = useFocusNode();

    useEffect(() {
      editAmountController.addListener(() {
        Future.microtask(() {
          ref
              .read(marketEditOrderAmountControllerNotifierProvider.notifier)
              .setState(editAmountController.text);
        });
      });

      return;
    }, const []);

    final editPriceController = useTextEditingController();
    final priceFocusNode = useFocusNode();

    useEffect(() {
      editPriceController.addListener(() {
        Future.microtask(() {
          ref
              .read(marketEditOrderPriceControllerNotifierProvider.notifier)
              .setState(editPriceController.text);
        });
      });

      return;
    }, const []);

    useEffect(() {
      optionOrder.match(
        () => () {},
        (order) => () {
          editAmountController.text = order.amountTextInputString;
          editPriceController.text = order.priceTextInputString;
        },
      )();

      return;
    }, [optionOrder]);

    final acceptEnabled = ref.watch(marketEditOrderAcceptEnabledProvider);

    final optionEditAmount = ref.watch(marketEditOrderAmountProvider);
    final optionEditPrice = ref.watch(marketEditOrderPriceProvider);

    final showDeleteDialogCallback = useCallback(() {
      return showDialog<bool>(
        context: context,
        builder: (context) {
          return HookBuilder(
            builder: (context) {
              final dialogNoFocusNode = useFocusNode();

              useEffect(() {
                dialogNoFocusNode.requestFocus();

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
                    style:
                        Theme.of(
                          context,
                        ).extension<SideswapYesButtonStyle>()!.style,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop(true);
                    },
                    child: Text('Yes'.tr()).tr(),
                  ),
                  TextButton(
                    focusNode: dialogNoFocusNode,
                    style:
                        Theme.of(
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

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 444),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text('Edit order'.tr()),
        onClose: () {
          closeCallback();
        },
      ),
      content: SizedBox(
        width: 450,
        height: 344,
        child: optionOrder.match(
          () => SizedBox(),
          (order) => Column(
            children: [
              order.baseAsset.match(
                () => SizedBox(),
                (baseAsset) => MarketAmountTextField(
                  caption: 'Amount'.tr(),
                  asset: baseAsset,
                  controller: editAmountController,
                  autofocus: true,
                  focusNode: amountFocusNode,
                  onEditingComplete: () {},
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 12),
              order.quoteAsset.match(
                () => SizedBox(),
                (quoteAsset) => MarketAmountTextField(
                  caption:
                      order.tradeDir == TradeDir.SELL
                          ? 'Offer price per unit'.tr()
                          : 'Bid price per unit'.tr(),
                  asset: quoteAsset,
                  controller: editPriceController,
                  autofocus: true,
                  focusNode: priceFocusNode,
                  onEditingComplete: () {},
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 12),
              MarketDeliverRow(
                deliverAsset:
                    order.tradeDir == TradeDir.SELL
                        ? order.baseAsset
                        : order.quoteAsset,
                deliverAmount:
                    order.tradeDir == TradeDir.SELL
                        ? order.amountString
                        : order.total,
              ),
              SizedBox(height: 12),
              Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.glacier.withValues(alpha: 0.4),
              ),
              SizedBox(height: 12),
              MarketReceiveRow(
                receiveAsset:
                    order.tradeDir == TradeDir.SELL
                        ? order.quoteAsset
                        : order.baseAsset,
                receiveAmount:
                    order.tradeDir == TradeDir.SELL
                        ? order.total
                        : order.amountString,
              ),
              SizedBox(height: 12),
              Divider(
                height: 1,
                thickness: 1,
                color: SideSwapColors.glacier.withValues(alpha: 0.4),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Order type'.tr(),
                    style:
                        Theme.of(
                          context,
                        ).extension<MarketAssetRowTheme>()!.labelStyle,
                  ),
                  Spacer(),
                  Text(
                    order.orderTypeDescription,
                    style:
                        Theme.of(
                          context,
                        ).extension<MarketAssetRowTheme>()!.amountStyle,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Spacer(),
              Row(
                children: [
                  DCustomButton(
                    width: 120,
                    height: 39,
                    onPressed: () {
                      closeCallback();
                      ref.invalidate(marketEditDetailsOrderNotifierProvider);
                    },
                    child: Text('Back'.tr()),
                  ),
                  Spacer(),
                  DCustomFilledBigButton(
                    width: 120,
                    height: 39,
                    onPressed:
                        acceptEnabled
                            ? () {
                              final editAmount = optionEditAmount.toNullable();
                              final editPrice = optionEditPrice.toNullable();
                              if (editAmount == null || editPrice == null) {
                                return;
                              }

                              final msg = To();
                              msg.orderEdit = To_OrderEdit(
                                orderId: order.orderId,
                                baseAmount: Int64(editAmount.asSatoshi()),
                                price: editPrice.asDouble(),
                              );
                              ref.read(walletProvider).sendMsg(msg);

                              closeCallback();
                              ref.invalidate(
                                marketEditDetailsOrderNotifierProvider,
                              );
                            }
                            : null,
                    child: Text('Accept'.tr()),
                  ),
                  Spacer(),
                  DCustomFilledBigButton(
                    width: 120,
                    height: 39,
                    onPressed: () async {
                      final ret = await showDeleteDialogCallback();

                      if (ret == true) {
                        final msg = To();
                        msg.orderCancel = To_OrderCancel(
                          orderId: order.orderId,
                        );
                        ref.read(walletProvider).sendMsg(msg);

                        closeCallback();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Symbols.delete_rounded, size: 24),
                        SizedBox(width: 4),
                        Text('Delete'.tr()),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
