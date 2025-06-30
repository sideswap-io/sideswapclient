import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/preview_order_dialog_providers.dart';
import 'package:sideswap/providers/quote_event_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketPreviewOrderDialogCommonBody extends ConsumerWidget {
  const MarketPreviewOrderDialogCommonBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogModifiers = ref.watch(
      previewOrderDialogModifiersNotifierProvider,
    );

    final optionQuoteSuccess = ref.watch(
      previewOrderQuoteSuccessNotifierProvider,
    );
    final orderSignTtl = ref.watch(orderSignTtlProvider);
    final assetImage = ref.watch(assetImageRepositoryProvider);

    return optionQuoteSuccess.match(
      () {
        return SizedBox();
      },
      (quoteSuccess) {
        final feeAsset = quoteSuccess.feeAsset.toNullable();
        final feeIcon = assetImage.getVerySmallImage(feeAsset?.assetId);

        final side = quoteSuccess.tradeDir == TradeDir.SELL
            ? 'Sell'.tr()
            : 'Buy'.tr();
        final sideColor = quoteSuccess.tradeDir == TradeDir.SELL
            ? Theme.of(context).extension<MarketColorsStyle>()!.sellColor
            : Theme.of(context).extension<MarketColorsStyle>()!.buyColor;

        return Padding(
          padding: FlavorConfig.isDesktop
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 12),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: FlavorConfig.isDesktop
                      ? SideSwapColors.chathamsBlue
                      : SideSwapColors.chathamsBlue.toAccentColor().dark,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      MarketDeliverRow(
                        deliverAsset: quoteSuccess.deliverAsset,
                        deliverAmount: quoteSuccess.deliverAmount,
                        showConversion: true,
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 8),
                      MarketReceiveRow(
                        receiveAsset: quoteSuccess.receiveAsset,
                        receiveAmount: quoteSuccess.receiveAmount,
                        showConversion: true,
                      ),
                      const SizedBox(height: 8),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: SideSwapColors.glacier.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 8),
                      MarketPriceRow(
                        asset: quoteSuccess.priceAsset,
                        amount: quoteSuccess.priceString,
                        showConversion: true,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text(
                          'Side'.tr(),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: SideSwapColors.brightTurquoise),
                        ),
                        const Spacer(),
                        Text(
                          side,
                          style: Theme.of(context)
                              .extension<MarketAssetRowStyle>()!
                              .amountStyle
                              ?.copyWith(color: sideColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.glacier.withValues(alpha: 0.4),
                    ),
                    ...switch (dialogModifiers.showOrderType) {
                      true => [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Order type'.tr(),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    color: SideSwapColors.brightTurquoise,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              quoteSuccess.startOrderSuccess?.twoStep == true
                                  ? 'Offline'.tr()
                                  : 'Online'.tr(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: SideSwapColors.glacier.withValues(alpha: 0.4),
                        ),
                      ],
                      false => [],
                    },
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Fixed fee'.tr(),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: SideSwapColors.brightTurquoise),
                        ),
                        const Spacer(),
                        Text(quoteSuccess.fixedFeeString),
                        SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(width: 8),
                              feeIcon,
                              Spacer(),
                              Text(feeAsset?.ticker ?? ''),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.glacier.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Server fee'.tr(),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: SideSwapColors.brightTurquoise),
                        ),
                        const Spacer(),
                        Text(quoteSuccess.serverFeeString),
                        SizedBox(
                          width: 80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const SizedBox(width: 8),
                              feeIcon,
                              const Spacer(),
                              Text(feeAsset?.ticker ?? ''),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.glacier.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Time-to-live'.tr(),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: SideSwapColors.brightTurquoise),
                        ),
                        const Spacer(),
                        Text('$orderSignTtl s.'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.glacier.withValues(alpha: 0.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
