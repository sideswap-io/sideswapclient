import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/screens/pay/widgets/friend_widget.dart';

class PaymentAmountReceiverField extends StatelessWidget {
  const PaymentAmountReceiverField({
    super.key,
    required this.labelStyle,
    this.text = '',
    this.friend,
  });

  final TextStyle labelStyle;
  final String text;
  final Friend? friend;

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
        if (friend != null) ...[
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: FriendWidget(friend: friend!),
          ),
        ] else ...[
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
                fillColor: const Color(0xFF1D6389),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
