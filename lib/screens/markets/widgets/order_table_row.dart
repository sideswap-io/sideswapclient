import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

enum OrderTableRowType {
  normal,
  small,
}

class OrderTableRow extends StatefulWidget {
  const OrderTableRow({
    Key? key,
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
  }) : super(key: key);

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

  @override
  _OrderTableRowState createState() => _OrderTableRowState();
}

class _OrderTableRowState extends State<OrderTableRow> {
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
            children: [
              Text(
                widget.description,
                style: widget.style ?? defaultFontStyle,
              ),
              const Spacer(),
              widget.enabled
                  ? widget.customValue ??
                      Text(
                        widget.value ?? '',
                        style: widget.style ?? defaultFontStyle,
                      )
                  : SpinKitCircle(
                      color: Colors.white,
                      size: 24.w,
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
