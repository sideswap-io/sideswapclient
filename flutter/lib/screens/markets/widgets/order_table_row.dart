import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/models/wallet.dart';
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
  final Image? icon;
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
    required String assetId,
    required int amount,
    required OrderTableRowType orderTableRowType,
    bool enabled = true,
    bool displayDivider = true,
    bool showDollarConversion = true,
  }) {
    return Builder(builder: (context) {
      return Consumer(
        builder: ((context, ref, _) {
          final icon = ref
              .watch(walletProvider.select((p) => p.assetImagesSmall[assetId]));
          final asset =
              ref.watch(walletProvider.select((p) => p.assets[assetId]));

          final ticker = asset?.ticker;
          final amount_ = amountStr(amount, precision: asset?.precision ?? 8);
          final dollarConversion = ref.watch(walletProvider).liquidAssetId() ==
                      assetId &&
                  showDollarConversion
              ? ref.watch(requestOrderProvider).dollarConversion(
                  assetId, toFloat(amount, precision: asset?.precision ?? 8))
              : null;

          return OrderTableRow(
            description: description,
            value: '$amount_ $ticker',
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
  late TextStyle defaultFontStyle = GoogleFonts.roboto(
    fontSize:
        widget.orderTableRowType == OrderTableRowType.normal ? 16.sp : 14.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: widget.orderTableRowType == OrderTableRowType.normal
              ? widget.topPadding ?? 15.h
              : widget.topPadding ?? 12.h),
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
                  SizedBox(width: 5.w),
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
                        padding: EdgeInsets.only(left: 8.w),
                        child: SizedBox(
                          width: 24.w,
                          height: 24.w,
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
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    '≈ ${widget.dollarConversion}',
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF709EBA),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ],
            ),
          ],
          if (widget.displayDivider) ...[
            Padding(
              padding: EdgeInsets.only(
                  top: widget.orderTableRowType == OrderTableRowType.normal
                      ? 12.h
                      : 10.h),
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
