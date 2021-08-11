import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class TxItemDate extends StatelessWidget {
  const TxItemDate({
    Key? key,
    required this.createdAt,
  }) : super(key: key);

  final int createdAt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 27.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat.yMMMd(context.locale.toLanguageTag()).format(
              DateTime.fromMillisecondsSinceEpoch(createdAt),
            ),
            style: GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          const Divider(
            height: 1,
            color: Color(0xFF2B6F95),
          ),
        ],
      ),
    );
  }
}
