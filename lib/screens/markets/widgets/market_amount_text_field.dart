import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/desktop/instant_swap/widgets/d_max_button.dart';
import 'package:sideswap/desktop/markets/widgets/enter_amount_separator.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/wallet_account_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/instant_swap/widgets/dropdown_amount_text_field.dart';
import 'package:sideswap/screens/instant_swap/widgets/max_button.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MarketAmountTextField extends HookConsumerWidget {
  const MarketAmountTextField({
    super.key,
    this.caption,
    this.asset,
    required this.controller,
    this.autofocus = false,
    this.focusNode,
    this.onEditingComplete,
    this.readonly = false,
    this.hintText = '0',
    this.onChanged,
    this.showConversion = true,
    this.error,
    this.showBalance = true,
    this.showAggregate = false,
    this.showMaxButton = false,
    this.onMaxPressed,
  });

  final String? caption;
  final Asset? asset;
  final TextEditingController controller;
  final bool showConversion;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final bool readonly;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final Widget? error;
  final bool showBalance;
  final bool showAggregate;
  final bool showMaxButton;
  final void Function()? onMaxPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controllerText = useState(controller.text);

    final icon = ref
        .watch(assetImageRepositoryProvider)
        .getSmallImage(asset?.assetId);
    final precision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: asset?.assetId);

    final defaultCurrencyConversion =
        showConversion
            ? ref.watch(
              defaultCurrencyConversionFromStringProvider(
                asset?.assetId,
                controllerText.value,
              ),
            )
            : null;

    useEffect(() {
      controller.addListener(() {
        controllerText.value = controller.text;
      });

      return;
    }, const []);

    final accountAsset = ref.watch(accountAssetFromAssetProvider(asset));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  caption ?? '',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
                  ),
                ),
              ],
            ),
            if (showConversion && defaultCurrencyConversion!.isNotEmpty)
              Text(
                '≈ $defaultCurrencyConversion',
                style: const TextStyle(
                  fontSize: 13,
                  color: SideSwapColors.halfBaked,
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            icon,
            const SizedBox(width: 8),
            Text(asset?.ticker ?? '', style: const TextStyle(fontSize: 18)),
            switch (asset) {
              Asset(:final ampMarket) when ampMarket == true => const AmpFlag(),
              _ => const SizedBox(),
            },
            const SizedBox(width: 8),
            Flexible(
              child: TextField(
                textAlign: TextAlign.end,
                controller: controller,
                style: TextStyle(
                  fontSize: 22,
                  color: readonly ? const Color(0x7FFFFFFF) : Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  isDense: true,
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: hintText,
                  hintStyle: WidgetStateTextStyle.resolveWith((states) {
                    return TextStyle(
                      color:
                          states.contains(WidgetState.focused) && !readonly
                              ? Colors.transparent
                              : const Color(0x7FFFFFFF),
                    );
                  }),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  CommaTextInputFormatter(),
                  if (precision == 0) ...[
                    FilteringTextInputFormatter.deny(RegExp('[\\-|,\\ .]')),
                  ] else ...[
                    FilteringTextInputFormatter.deny(RegExp('[\\-|,\\ ]')),
                  ],
                  DecimalTextInputFormatter(decimalRange: precision),
                ],
                autofocus: autofocus,
                onEditingComplete: onEditingComplete,
                onChanged: onChanged,
                focusNode: focusNode,
                readOnly: readonly,
              ),
            ),
            if (showMaxButton) ...[
              SizedBox(width: 16),
              ...switch (FlavorConfig.isDesktop) {
                true => [
                  DMaxButton(width: 51, height: 21, onPressed: onMaxPressed),
                ],
                _ => [
                  MaxButton(width: 54, height: 24, onPressed: onMaxPressed),
                ],
              },
            ],
          ],
        ),
        const SizedBox(height: 8),
        const EnterAmountSeparator(),
        switch (showBalance) {
          true => Align(
            alignment: Alignment.centerRight,
            child: DropdownAmountBalanceLine(
              accountAsset: accountAsset,
              balanceAlignment: MainAxisAlignment.spaceBetween,
            ),
          ),
          _ => const SizedBox(),
        },
        switch (showAggregate) {
          true => LimitPanelAggregate(asset: asset),
          _ => const SizedBox(),
        },
        error ?? SizedBox(),
      ],
    );
  }
}

class LimitPanelAggregate extends ConsumerWidget {
  const LimitPanelAggregate({this.asset, super.key});

  final Asset? asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tradeDirState = ref.watch(tradeDirStateNotifierProvider);
    final aggregateVolume = ref.watch(marketLimitOrderAggregateVolumeProvider);
    final aggregateTooHigh = ref.watch(
      makeLimitOrderAggregateVolumeTooHighProvider,
    );
    final optionQuoteAsset = ref.watch(marketSubscribedQuoteAssetProvider);
    final optionBaseAsset = ref.watch(marketSubscribedBaseAssetProvider);

    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 13,
      color: SideSwapColors.airSuperiorityBlue,
    );

    final aggregateBidAmountStyle = textStyle?.copyWith(
      color:
          tradeDirState == TradeDir.BUY && aggregateTooHigh
              ? SideSwapColors.bitterSweet
              : SideSwapColors.airSuperiorityBlue,
    );

    final aggregateDescription =
        tradeDirState == TradeDir.BUY
            ? 'Aggregate bid amount:'.tr()
            : 'Aggregate offer value:'.tr();

    final balance =
        tradeDirState == TradeDir.BUY
            ? ref.watch(marketLimitPriceBalanceProvider)
            : ref.watch(marketLimitAmountBalanceProvider);

    final balanceHint =
        tradeDirState == TradeDir.BUY ? 'Buying power'.tr() : 'Balance'.tr();

    return optionQuoteAsset.match(
      () => const SizedBox(),
      (quoteAsset) => optionBaseAsset.match(() => const SizedBox(), (
        baseAsset,
      ) {
        final showBalance = switch (tradeDirState) {
          TradeDir.BUY when asset == quoteAsset => true,
          TradeDir.SELL when asset == baseAsset => true,
          _ => false,
        };

        final balanceIconAsset = switch (tradeDirState) {
          TradeDir.BUY => quoteAsset,
          _ => baseAsset,
        };

        return Column(
          children: [
            const SizedBox(height: 4),
            switch (showBalance) {
              true => SizedBox(
                height: 17,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$balanceHint:', style: textStyle),
                    Row(
                      children: [
                        SelectableText(balance, style: textStyle),
                        const SizedBox(width: 4),
                        Consumer(
                          builder: (context, ref, _) {
                            final icon = ref
                                .watch(assetImageRepositoryProvider)
                                .getSmallImage(balanceIconAsset.assetId);

                            return SizedBox(width: 16, height: 16, child: icon);
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(balanceIconAsset.ticker, style: textStyle),
                      ],
                    ),
                  ],
                ),
              ),
              _ => SizedBox(),
            },
            switch (tradeDirState) {
              TradeDir.BUY when asset == baseAsset => SizedBox(height: 17),
              _ => const SizedBox(),
            },
            switch (asset) {
              Asset()? when asset == quoteAsset => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(aggregateDescription, style: aggregateBidAmountStyle),
                  Row(
                    children: [
                      SelectableText(
                        aggregateVolume.asString(),
                        style: aggregateBidAmountStyle,
                      ),
                      const SizedBox(width: 4),
                      Consumer(
                        builder: (context, ref, _) {
                          final icon = ref
                              .watch(assetImageRepositoryProvider)
                              .getSmallImage(quoteAsset.assetId);

                          return SizedBox(width: 16, height: 16, child: icon);
                        },
                      ),
                      const SizedBox(width: 4),
                      Text(quoteAsset.ticker, style: aggregateBidAmountStyle),
                    ],
                  ),
                ],
              ),
              _ => const SizedBox(),
            },
            switch (tradeDirState) {
              TradeDir.SELL when asset == quoteAsset => SizedBox(height: 17),
              _ => const SizedBox(),
            },
          ],
        );
      }),
    );
  }
}
