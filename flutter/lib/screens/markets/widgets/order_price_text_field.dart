import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/models/request_order_provider.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

class OrderPriceTextField extends ConsumerWidget {
  const OrderPriceTextField({
    super.key,
    this.icon,
    this.asset,
    required this.controller,
    this.focusNode,
    this.onEditingComplete,
    this.precision = 8,
  });

  final Image? icon;
  final Asset? asset;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final int precision;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dollarConversion = ref.read(requestOrderProvider).dollarConversion(
        asset?.assetId ?? '', double.tryParse(controller.text) ?? 0);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        focusNode?.requestFocus();
      },
      child: Container(
        height: 84.h,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.r),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price'.tr(),
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF00C5FF),
                      ),
                    ),
                    Text(
                      dollarConversion.isEmpty ? '' : '≈ $dollarConversion',
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF709EBA),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 17.h),
                child: SizedBox(
                  height: 29.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24.w,
                            height: 24.w,
                            child: icon,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: Text(
                              asset?.ticker ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF84ADC6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 190.w,
                        child: Padding(
                          padding: EdgeInsets.only(left: 14.w),
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            textAlign: TextAlign.end,
                            style: GoogleFonts.roboto(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            onEditingComplete: onEditingComplete,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              CommaTextInputFormatter(),
                              if (precision == 0) ...[
                                FilteringTextInputFormatter.deny(
                                    RegExp('[\\-|,\\ .]')),
                              ] else ...[
                                FilteringTextInputFormatter.deny(
                                    RegExp('[\\-|,\\ ]')),
                              ],
                              DecimalTextInputFormatter(
                                decimalRange: precision,
                              ),
                            ],
                            decoration: InputDecoration(
                              isCollapsed: true,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: '0.0',
                              hintStyle: GoogleFonts.roboto(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF84ADC6),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
