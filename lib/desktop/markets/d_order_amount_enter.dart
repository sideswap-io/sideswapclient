import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/desktop/markets/widgets/enter_amount_separator.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class DOrderAmountEnter extends ConsumerWidget {
  const DOrderAmountEnter({
    super.key,
    required this.caption,
    required this.accountAsset,
    required this.controller,
    this.isPriceField = false,
    this.autofocus = false,
    this.focusNode,
    this.onEditingComplete,
    this.readonly = false,
    this.hintText = '0',
    this.onChanged,
  });

  final String caption;
  final AccountAsset? accountAsset;
  final TextEditingController controller;
  final bool isPriceField;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final bool readonly;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetsStateProvider)[accountAsset?.assetId];
    final icon =
        ref.watch(assetImageProvider).getSmallImage(accountAsset?.assetId);
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: accountAsset?.assetId);
    final precision =
        (isPriceField && asset?.swapMarket == true) ? 2 : assetPrecision;
    final liquidAssetId = ref.watch(liquidAssetIdStateProvider);
    final showConversion =
        isPriceField && accountAsset?.assetId == liquidAssetId;
    final defaultCurrencyConversion = showConversion
        ? ref.watch(defaultCurrencyConversionFromStringProvider(
            accountAsset?.assetId, controller.text))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  caption,
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
            Text(
              asset?.ticker ?? '',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            switch (accountAsset) {
              AccountAsset(:final account) when account.isAmp =>
                const AmpFlag(),
              _ => const SizedBox(),
            },
            const SizedBox(width: 8),
            Expanded(
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
                  // filled: true,
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: hintText,
                  hintStyle: MaterialStateTextStyle.resolveWith((states) {
                    return TextStyle(
                        color:
                            states.contains(MaterialState.focused) && !readonly
                                ? Colors.transparent
                                : const Color(0x7FFFFFFF));
                  }),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
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
          ],
        ),
        const SizedBox(height: 8),
        const EnterAmountSeparator(),
      ],
    );
  }
}
