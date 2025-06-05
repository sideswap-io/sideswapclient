import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/button_styles.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/common/utils/build_context_extension.dart';
import 'package:sideswap/common/widgets/colored_container.dart';
import 'package:sideswap/models/ui_own_order.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class WorkingOrderItem extends HookConsumerWidget {
  const WorkingOrderItem({required this.order, super.key});

  final UiOwnOrder order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coloredContainerStyle = useMemoized(() {
      return const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      );
    });

    final descriptionStyle = useMemoized(() {
      return const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: SideSwapColors.brightTurquoise,
      );
    });

    final amountStyle = useMemoized(() {
      return const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      );
    });

    final conversionTicker = ref.watch(defaultCurrencyTickerProvider);

    final maxTickerWidthCallback = useCallback(() {
      final amountTickerSize = context.calculateTextSize(
        text: order.amountTicker,
        style: amountStyle,
      );
      final priceTickerSize = context.calculateTextSize(
        text: order.priceTicker,
        style: amountStyle,
      );
      final conversionTickerSize = context.calculateTextSize(
        text: conversionTicker,
        style: amountStyle,
      );

      return max(
        conversionTickerSize.width,
        max(amountTickerSize.width, priceTickerSize.width),
      ).ceilToDouble();
    }, [order, conversionTicker, context, amountStyle]);

    final maxTickerWidth = maxTickerWidthCallback();

    final showCancelDialogCallback = useCallback(() {
      return showDialog<bool>(
        context: context,
        builder: (context) {
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
                style:
                    Theme.of(context).extension<SideswapNoButtonStyle>()!.style,
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(false);
                },
                child: Text('No'.tr()).tr(),
              ),
            ],
          );
        },
      );
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ColoredContainer(
        theme: ColoredContainerStyle(
          backgroundColor: SideSwapColors.chathamsBlue,
          borderColor: SideSwapColors.chathamsBlue,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.productName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  switch (order.isAmp) {
                    true => AmpFlag(),
                    _ => SizedBox(),
                  },
                  Spacer(),
                  ColoredContainer(
                    child: Text(
                      order.marketType == MarketType_.TOKEN
                          ? 'Token market'.tr()
                          : 'Swap market'.tr(),
                      style: coloredContainerStyle,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  thickness: 1,
                  height: 1,
                  color: SideSwapColors.jellyBean,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount'.tr(), style: descriptionStyle),
                  Row(
                    children: [
                      Text(order.amountMobileString, style: amountStyle),
                      SizedBox(width: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: maxTickerWidth,
                            child: Text(order.amountTicker, style: amountStyle),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      order.amountIcon,
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price per unit'.tr(), style: descriptionStyle),
                  Row(
                    children: [
                      Text(order.priceMobileString, style: amountStyle),
                      SizedBox(width: 8),
                      SizedBox(
                        width: maxTickerWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(order.priceTicker, style: amountStyle),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      order.priceIcon,
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total'.tr(), style: descriptionStyle),
                  Row(
                    children: [
                      Text(order.totalMobileString, style: amountStyle),
                      SizedBox(width: 8),
                      SizedBox(
                        width: maxTickerWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(order.totalTicker, style: amountStyle),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      order.totalIcon,
                    ],
                  ),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  final amountParsed = double.tryParse(order.total) ?? 0;
                  final totalConversion =
                      amountParsed == 0
                          ? ''
                          : ref.watch(
                            defaultCurrencyConversionProvider(
                              order.assetPair.quote,
                              amountParsed,
                            ),
                          );

                  return switch (totalConversion.isEmpty) {
                    true => SizedBox(),
                    _ => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(''),
                            Row(
                              children: [
                                Text(
                                  '≈ $totalConversion',
                                  style: amountStyle.copyWith(
                                    color: SideSwapColors.airSuperiorityBlue,
                                  ),
                                ),
                                SizedBox(width: 8),
                                SizedBox(
                                  width: maxTickerWidth,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        conversionTicker,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelLarge?.copyWith(
                                          color:
                                              SideSwapColors.airSuperiorityBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8),
                                SizedBox(width: 20, height: 20),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  };
                },
              ),
              switch (order.exclamationMark) {
                true => Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: SideSwapColors.bitterSweet,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Order amount become less than the minimum after partially matching or there is no UTXOs'
                                .tr(),
                            style: Theme.of(
                              context,
                            ).textTheme.labelLarge?.copyWith(
                              color: SideSwapColors.airSuperiorityBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    order.questionMark ? SizedBox(height: 8) : SizedBox(),
                  ],
                ),
                false => SizedBox(),
              },
              switch (order.questionMark) {
                true => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Not enough UTXOs to cover the requested amount'.tr(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: SideSwapColors.airSuperiorityBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                false => SizedBox(),
              },
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  thickness: 1,
                  height: 1,
                  color: SideSwapColors.jellyBean,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ColoredContainer(
                    theme: ColoredContainerStyle(
                      backgroundColor: SideSwapColors.blueSapphire,
                      borderColor: SideSwapColors.blueSapphire,
                    ),
                    child: Text(
                      order.offlineSwapType == OfflineSwapTypeTwoStep()
                          ? 'Offline'.tr()
                          : 'Online'.tr(),
                      style: coloredContainerStyle,
                    ),
                  ),
                  SizedBox(width: 8),
                  ColoredContainer(
                    theme: ColoredContainerStyle(
                      backgroundColor: SideSwapColors.blueSapphire,
                      borderColor: SideSwapColors.blueSapphire,
                    ),
                    child: Text(
                      order.orderType == OrderTypePrivate()
                          ? 'Private'.tr()
                          : 'Public'.tr(),
                      style: coloredContainerStyle,
                    ),
                  ),
                  Spacer(),
                  ColoredContainer(
                    theme: ColoredContainerStyle(
                      backgroundColor: SideSwapColors.bitterSweet.withValues(
                        alpha: 0.14,
                      ),
                      borderColor:
                          order.tradeDir == TradeDir.SELL
                              ? SideSwapColors.bitterSweet
                              : SideSwapColors.turquoise,
                    ),
                    child: Text(
                      order.tradeDir == TradeDir.SELL
                          ? 'Sell'.tr()
                          : 'Buy'.tr(),
                      style: coloredContainerStyle,
                    ),
                  ),
                  SizedBox(width: 8),
                  ColoredContainer(
                    theme: ColoredContainerStyle(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: SvgPicture.asset(
                            'assets/clock.svg',
                            width: 14,
                            height: 14,
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final expire = ref.watch(
                              orderExpireDescriptionProvider(Option.of(order)),
                            );
                            return Text(expire, style: coloredContainerStyle);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  thickness: 1,
                  height: 1,
                  color: SideSwapColors.jellyBean,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (order.orderType == OrderType.private()) ...[
                    IconButton(
                      onPressed: () {
                        final shareUrl = ref.read(
                          addressToShareByOrderProvider(order),
                        );
                        copyToClipboard(context, shareUrl);
                      },
                      icon: SvgPicture.asset(
                        'assets/copy3.svg',
                        width: 18,
                        height: 18,
                      ),
                      style:
                          Theme.of(context)
                              .extension<WorkingOrderItemCancelButtonStyle>()!
                              .style,
                    ),
                    SizedBox(width: 6),
                  ],
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/delete.svg',
                      width: 20,
                      height: 20,
                    ),
                    onPressed: () async {
                      final ret = await showCancelDialogCallback();

                      if (ret == true) {
                        final msg = To();
                        msg.orderCancel = To_OrderCancel(
                          orderId: order.orderId,
                        );
                        ref.read(walletProvider).sendMsg(msg);
                      }
                    },
                    style:
                        Theme.of(
                          context,
                        ).extension<WorkingOrderItemCancelButtonStyle>()!.style,
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
