import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/desktop/markets/widgets/enter_amount_separator.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/balances_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
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
          ],
        ),
        const SizedBox(height: 8),
        const EnterAmountSeparator(),
        const SizedBox(height: 8),
        error ?? SizedBox(),
      ],
    );
  }
}
