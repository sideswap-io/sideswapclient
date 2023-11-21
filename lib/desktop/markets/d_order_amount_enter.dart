import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/desktop/markets/widgets/enter_amount_separator.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/markets_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';

class DOrderAmountEnter extends ConsumerStatefulWidget {
  const DOrderAmountEnter({
    super.key,
    required this.caption,
    required this.assetId,
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
  final String? assetId;
  final TextEditingController controller;
  final bool isPriceField;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final bool readonly;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  ConsumerState<DOrderAmountEnter> createState() => DOrderAmountEnterState();
}

class DOrderAmountEnterState extends ConsumerState<DOrderAmountEnter> {
  @override
  Widget build(BuildContext context) {
    final asset = ref.watch(assetsStateProvider)[widget.assetId];
    final icon = ref.watch(assetImageProvider).getSmallImage(widget.assetId);
    final assetPrecision = ref
        .watch(assetUtilsProvider)
        .getPrecisionForAssetId(assetId: widget.assetId);
    final precision =
        (widget.isPriceField && asset?.swapMarket == true) ? 2 : assetPrecision;
    final liquidAccountAsset = ref.watch(makeOrderLiquidAccountAssetProvider);
    final showDollarConversion =
        widget.isPriceField && widget.assetId == liquidAccountAsset?.assetId;
    final dollarConversion = showDollarConversion
        ? ref.watch(dollarConversionFromStringProvider(
            widget.assetId, widget.controller.text))
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.caption,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: SideSwapColors.brightTurquoise,
              ),
            ),
            if (showDollarConversion && dollarConversion!.isNotEmpty)
              Text(
                '≈ $dollarConversion',
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
            switch (liquidAccountAsset) {
              AccountAsset(:final account)
                  when account.isAmp &&
                      widget.assetId == liquidAccountAsset.assetId =>
                const AmpFlag(),
              _ => Container(),
            },
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                textAlign: TextAlign.end,
                controller: widget.controller,
                style: TextStyle(
                  fontSize: 22,
                  color:
                      widget.readonly ? const Color(0x7FFFFFFF) : Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  // filled: true,
                  isDense: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: widget.hintText,
                  hintStyle: MaterialStateTextStyle.resolveWith((states) {
                    return TextStyle(
                        color: states.contains(MaterialState.focused) &&
                                !widget.readonly
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
                autofocus: widget.autofocus,
                onEditingComplete: widget.onEditingComplete,
                onChanged: (value) {
                  setState(() {});
                  widget.onChanged?.call(value);
                },
                focusNode: widget.focusNode,
                readOnly: widget.readonly,
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
