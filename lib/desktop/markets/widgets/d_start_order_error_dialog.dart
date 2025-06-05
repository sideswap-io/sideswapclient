import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/styles/theme_extensions.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/markets/widgets/market_order_panel.dart';
import 'package:sideswap/desktop/onboarding/widgets/d_error_icon.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/quote_event_providers.dart';

class DStartOrderErrorDialog extends ConsumerWidget {
  const DStartOrderErrorDialog({super.key, required this.onClose});

  final void Function() onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionStartOrderError = ref.watch(
      marketStartOrderErrorNotifierProvider,
    );

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

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 360),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text(
          'Order error'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onClose: onClose,
      ),
      content: SizedBox(
        width: 450,
        height: 260,
        child: optionStartOrderError.match(
          () => () {
            return SizedBox();
          },
          (startOrderError) => () {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DErrorIcon(),
                SizedBox(height: 24),
                Text(startOrderError.error),
                Spacer(),
                DCustomFilledBigButton(
                  onPressed: onClose,
                  child: Text('Close'.tr()),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        )(),
      ),
    );
  }
}

class DStartOrderQuoteErrorDialog extends ConsumerWidget {
  const DStartOrderQuoteErrorDialog({
    super.key,
    required this.onClose,
    required this.optionStartOrderQuoteError,
  });

  final void Function() onClose;
  final Option<QuoteError> optionStartOrderQuoteError;

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

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 360),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text(
          'Order quote error'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),

        onClose: onClose,
      ),
      content: SizedBox(
        width: 450,
        height: 260,
        child: optionStartOrderQuoteError.match(
          () => () {
            return SizedBox();
          },
          (quoteError) => () {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DErrorIcon(),
                SizedBox(height: 24),
                Text(quoteError.error),
                Spacer(),
                DCustomFilledBigButton(
                  onPressed: onClose,
                  child: Text('Close'.tr()),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        )(),
      ),
    );
  }
}

class DStartOrderUnregisteredGaidDialog extends ConsumerWidget {
  const DStartOrderUnregisteredGaidDialog({
    required this.optionStartOrderUnregisteredGaid,
    required this.onClose,
    super.key,
  });

  final void Function() onClose;
  final Option<QuoteUnregisteredGaid> optionStartOrderUnregisteredGaid;

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

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 360),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text(
          'Unregistered AMP ID'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onClose: onClose,
      ),
      content: SizedBox(
        width: 450,
        height: 260,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DErrorIcon(),
            SizedBox(height: 24),
            Text('Please register your AMP ID at'.tr()),
            const SizedBox(height: 8),
            optionStartOrderUnregisteredGaid.match(
              () => const SizedBox(),
              (unregisteredGaid) =>
                  DUrlLink(text: 'https://${unregisteredGaid.domainAgent}'),
            ),

            const SizedBox(height: 20),
            Spacer(),
            DCustomFilledBigButton(
              onPressed: onClose,
              child: Text('Close'.tr()),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class DStartOrderLowBalanceErrorDialog extends ConsumerWidget {
  const DStartOrderLowBalanceErrorDialog({
    super.key,
    required this.onClose,
    required this.optionStartOrderQuoteLowBalance,
  });

  final void Function() onClose;
  final Option<QuoteLowBalance> optionStartOrderQuoteLowBalance;

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

    final rowTheme = Theme.of(context)
        .extension<MarketAssetRowStyle>()!
        .copyWith(
          errorLabelStyle: Theme.of(context).textTheme.titleSmall!,
          errorAmountStyle: Theme.of(context).textTheme.titleSmall!,
          errorTickerStyle: Theme.of(context).textTheme.titleSmall!,
        );

    return DContentDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 400),
      style: defaultDialogTheme,
      title: DContentDialogTitle(
        content: Text(
          'Order low balance error'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onClose: onClose,
      ),
      content: SizedBox(
        width: 450,
        height: 300,
        child: optionStartOrderQuoteLowBalance.match(
          () => () {
            return SizedBox();
          },
          (lowBalance) => () {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DErrorIcon(),
                SizedBox(height: 24),
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleSmall!,
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: SideSwapColors.darkCerulean,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              MarketDeliverRow(
                                deliverAsset: lowBalance.deliverAsset,
                                deliverAmount: lowBalance.deliverAmount,
                                isError: true,
                                theme: rowTheme,
                              ),
                              SizedBox(height: 4),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: SideSwapColors.glacier.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              SizedBox(height: 4),
                              MarketReceiveRow(
                                receiveAsset: lowBalance.receiveAsset,
                                receiveAmount: lowBalance.receiveAmount,
                                isError: true,
                                theme: rowTheme,
                              ),
                              SizedBox(height: 4),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: SideSwapColors.glacier.withValues(
                                  alpha: 0.4,
                                ),
                              ),
                              SizedBox(height: 4),
                              MarketAssetRow(
                                asset: lowBalance.deliverAsset,
                                amount: lowBalance.availableAmount,
                                isError: true,
                                label: 'Available'.tr(),
                                theme: rowTheme,
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                DCustomFilledBigButton(
                  onPressed: onClose,
                  child: Text('Close'.tr()),
                ),
                SizedBox(height: 16),
              ],
            );
          },
        )(),
      ),
    );
  }
}
