import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF00C5FF),
                      ),
                    ),
                    Text(
                      dollarConversion.isEmpty ? '' : '≈ $dollarConversion',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF709EBA),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 17),
                child: SizedBox(
                  height: 29,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: icon,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              asset?.ticker ?? '',
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF84ADC6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 190,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 14),
                          child: TextField(
                            controller: controller,
                            focusNode: focusNode,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 24,
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
                            decoration: const InputDecoration(
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
                              hintStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF84ADC6),
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
