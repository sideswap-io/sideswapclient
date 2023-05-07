import 'package:flutter/material.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/amount_to_string_model.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/request_order_provider.dart';
import 'package:sideswap/providers/wallet_assets_provider.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum OrderTableRowType {
  normal,
  small,
}

class OrderTableRow extends StatefulWidget {
  const OrderTableRow({
    super.key,
    required this.description,
    this.value,
    this.icon,
    this.displayDivider = true,
    this.topPadding,
    this.dollarConversion,
    this.orderTableRowType = OrderTableRowType.normal,
    this.enabled = true,
    this.style,
    this.customValue,
    this.showAmpFlag = false,
  });

  final String description;
  final String? value;
  final Widget? icon;
  final bool displayDivider;
  final double? topPadding;
  final String? dollarConversion;
  final OrderTableRowType orderTableRowType;
  final bool enabled;
  final TextStyle? style;
  final Widget? customValue;
  final bool showAmpFlag;

  @override
  OrderTableRowState createState() => OrderTableRowState();

  static Widget assetAmount({
    required String description,
    required String? assetId,
    required int amount,
    required OrderTableRowType orderTableRowType,
    bool enabled = true,
    bool displayDivider = true,
    bool showDollarConversion = true,
  }) {
    return Builder(builder: (context) {
      return Consumer(
        builder: ((context, ref, _) {
          final icon = ref.watch(assetImageProvider).getSmallImage(assetId);
          final asset =
              ref.watch(assetsStateProvider.select((value) => value[assetId]));

          final ticker = asset?.ticker;
          final amountProvider = ref.watch(amountToStringProvider);
          final liquidAssetId = ref.watch(liquidAssetIdProvider);
          final amountStr = amountProvider.amountToStringNamed(
              AmountToStringNamedParameters(
                  amount: amount,
                  ticker: ticker ?? '',
                  precision: asset?.precision ?? 8));
          final dollarConversion = liquidAssetId == assetId &&
                  showDollarConversion
              ? ref.watch(requestOrderProvider).dollarConversion(
                  assetId, toFloat(amount, precision: asset?.precision ?? 8))
              : null;

          return OrderTableRow(
            description: description,
            value: amountStr,
            dollarConversion: dollarConversion,
            icon: icon,
            orderTableRowType: orderTableRowType,
            displayDivider: displayDivider,
            enabled: enabled,
          );
        }),
      );
    });
  }
}

class OrderTableRowState extends State<OrderTableRow> {
  late TextStyle defaultFontStyle = TextStyle(
    fontSize: widget.orderTableRowType == OrderTableRowType.normal ? 16 : 14,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.orderTableRowType == OrderTableRowType.normal
              ? widget.topPadding ?? 15
              : widget.topPadding ?? 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    widget.description,
                    style: widget.style ?? defaultFontStyle,
                  ),
                  if (widget.showAmpFlag) const AmpFlag(),
                  const SizedBox(width: 5),
                ],
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: widget.customValue ??
                            Text(
                              widget.value ?? '',
                              style: widget.style ?? defaultFontStyle,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                            ),
                      ),
                    ),
                    if (widget.icon != null) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: widget.icon,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (widget.dollarConversion != null &&
              widget.dollarConversion!.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '≈ ${widget.dollarConversion}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF709EBA),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),
          ],
          if (widget.displayDivider) ...[
            Padding(
              padding: EdgeInsets.only(
                  top: widget.orderTableRowType == OrderTableRowType.normal
                      ? 12
                      : 10),
              child: const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFF337BA3),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
