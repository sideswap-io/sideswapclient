import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/markets_provider.dart';

class MarketPreviewOrderDialogCommonBody extends ConsumerWidget {
  const MarketPreviewOrderDialogCommonBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionQuoteSuccess = ref.watch(
      marketPreviewOrderQuoteNotifierProvider,
    );
    final previewOrderTtl = ref.watch(marketPreviewOrderTtlProvider);
    final assetImage = ref.watch(assetImageRepositoryProvider);

    return optionQuoteSuccess.match(
      () {
        return SizedBox();
      },
      (quoteSuccess) {
        final feeAsset = quoteSuccess.feeAsset.toNullable();
        final feeIcon = assetImage.getVerySmallImage(feeAsset?.assetId);

        return Column(
          children: [
            SizedBox(height: 12),
            DecoratedBox(
              decoration: BoxDecoration(
                color: SideSwapColors.chathamsBlue,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    MarketDeliverRow(
                      deliverAsset: quoteSuccess.deliverAsset,
                      deliverAmount: quoteSuccess.deliverAmount,
                      showConversion: true,
                    ),
                    SizedBox(height: 8),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: SideSwapColors.glacier.withValues(alpha: 0.4),
                    ),
                    SizedBox(height: 8),
                    MarketReceiveRow(
                      receiveAsset: quoteSuccess.receiveAsset,
                      receiveAmount: quoteSuccess.receiveAmount,
                      showConversion: true,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Fixed fee'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
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
                        'Server fee'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text(quoteSuccess.serverFeeString),
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
                        'Time-to-live'.tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                      Spacer(),
                      Text('$previewOrderTtl s.'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: SideSwapColors.glacier.withValues(alpha: 0.4),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
