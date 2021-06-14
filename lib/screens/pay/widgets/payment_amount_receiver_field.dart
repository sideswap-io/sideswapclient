import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class PaymentAmountReceiverField extends StatelessWidget {
  PaymentAmountReceiverField({
    Key? key,
    required this.labelStyle,
    this.text = '',
  }) : super(key: key);

  final TextStyle labelStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 26.h),
          child: Text(
            'Receiver',
            style: labelStyle,
          ).tr(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: TextField(
            controller: TextEditingController()..text = text,
            maxLines: null,
            readOnly: true,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.w),
                ),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xFF1D6389),
            ),
          ),
        ),
      ],
    );
  }
}
