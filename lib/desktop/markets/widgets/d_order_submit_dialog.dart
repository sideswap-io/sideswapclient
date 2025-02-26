import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/screens/onboarding/widgets/error_icon.dart';
import 'package:sideswap/screens/onboarding/widgets/success_icon.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class OrderSubmitSuccessDialog extends HookConsumerWidget {
  const OrderSubmitSuccessDialog({
    required this.onClose,
    this.dialogThemeData,
    super.key,
  });

  final void Function() onClose;
  final DContentDialogThemeData? dialogThemeData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionOrderSubmitSuccess = ref.watch(orderSubmitSuccessProvider);

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

    final dialogTheme = dialogThemeData ?? defaultDialogTheme;

    final okFocusNode = useFocusNode();

    useEffect(() {
      okFocusNode.requestFocus();

      return;
    }, const []);

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      style: dialogTheme,
      title: DContentDialogTitle(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuccessIcon(
              width: 32,
              height: 32,
              iconColor: Colors.white,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: SideSwapColors.brightTurquoise,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
            ),
            SizedBox(width: 10),
            Text('Order submit success'.tr()),
          ],
        ),
        onClose: () {
          onClose();
        },
      ),
      content: SizedBox(
        width: 580,
        height: 485,
        child:
            optionOrderSubmitSuccess.match(
              () => () {
                return SizedBox();
              },
              (order) => () {
                final isSell = order.tradeDir == TradeDir.SELL;
                final dirStr = isSell ? 'Sell'.tr() : 'Buy'.tr();
                final dirColor =
                    isSell
                        ? Theme.of(
                          context,
                        ).extension<MarketColorsTheme>()!.sellColor
                        : Theme.of(
                          context,
                        ).extension<MarketColorsTheme>()!.buyColor;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Text(
                            'Product'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Spacer(),
                          Text(
                            order.productName,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Amount'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Spacer(),
                          Text(
                            order.amountString,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 8),
                                order.amountIcon,
                                Spacer(),
                                Text(
                                  order.baseAsset.toNullable()?.ticker ?? '',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Price per unit'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Spacer(),
                          Text(
                            order.priceString,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 8),
                                order.priceIcon,
                                Spacer(),
                                Text(
                                  order.quoteAsset.toNullable()?.ticker ?? '',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Total'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Spacer(),
                          Text(
                            order.total,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          SizedBox(
                            width: 80,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(width: 8),
                                order.priceIcon,
                                Spacer(),
                                Text(
                                  order.quoteAsset.toNullable()?.ticker ?? '',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Side'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Spacer(),
                          Text(
                            dirStr,
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(color: dirColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Order type'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Spacer(),
                          Text(order.orderTypeDescription),
                        ],
                      ),
                      SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Two step'.tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.titleSmall?.copyWith(
                              color: SideSwapColors.brightTurquoise,
                            ),
                          ),
                          Spacer(),
                          Text(order.offlineSwapTypeDescription),
                        ],
                      ),
                      Spacer(),
                      DCustomFilledBigButton(
                        focusNode: okFocusNode,
                        onPressed: () {
                          onClose();
                        },
                        child: Text('OK'.tr()),
                      ),
                    ],
                  ),
                );
              },
            )(),
      ),
    );
  }
}

class OrderSubmitErrorDialog extends ConsumerWidget {
  const OrderSubmitErrorDialog({
    required this.onClose,
    this.dialogThemeData,
    super.key,
  });

  final void Function() onClose;
  final DContentDialogThemeData? dialogThemeData;

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

    final dialogTheme = dialogThemeData ?? defaultDialogTheme;

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 580, maxHeight: 605),
      style: dialogTheme.merge(
        DContentDialogThemeData(titlePadding: EdgeInsets.zero),
      ),
      title: DContentDialogTitle(
        onClose: () {
          onClose();
        },
      ),
      content: SizedBox(
        width: 580,
        height: 485,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ErrorIcon(
                width: 102,
                height: 102,
                iconColor: Colors.white,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: SideSwapColors.bitterSweet,
                    style: BorderStyle.solid,
                    width: 8,
                  ),
                ),
              ),
              SizedBox(height: 28),
              Text(
                'Order submit error'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final optionOrderSubmitError = ref.watch(
                    orderSubmitErrorProvider,
                  );

                  return optionOrderSubmitError.match(
                    () => SizedBox(),
                    (error) => Text(error, textAlign: TextAlign.center),
                  );
                },
              ),
              Spacer(),
              DCustomFilledBigButton(
                onPressed: () {
                  onClose();
                },
                child: Text('Close'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderSubmitUnregisteredGaid extends ConsumerWidget {
  const OrderSubmitUnregisteredGaid({
    required this.onClose,
    this.dialogThemeData,
    super.key,
  });

  final void Function() onClose;
  final DContentDialogThemeData? dialogThemeData;

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

    final dialogTheme = dialogThemeData ?? defaultDialogTheme;

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 400, maxHeight: 240),
      style: dialogTheme,
      title: DContentDialogTitle(
        content: Text('Unregistered AMP ID'.tr()),
        onClose: () {
          onClose();
        },
      ),
      content: SizedBox(
        width: 400,
        height: 140,
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final optionUnregisteredGaid = ref.watch(
                  orderSubmitUnregisteredGaidProvider,
                );
                return optionUnregisteredGaid.match(
                  () => SizedBox(),
                  (domainAgent) => Column(
                    children: [
                      Text('Please register your AMP ID at'.tr()),
                      const SizedBox(height: 8),
                      DUrlLink(text: 'https://$domainAgent'),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
            Spacer(),
            DCustomFilledBigButton(
              onPressed: () {
                onClose();
              },
              child: Text('Close'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
