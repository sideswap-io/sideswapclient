import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class TxDetailsRow extends StatelessWidget {
  TxDetailsRow({
    Key? key,
    required this.description,
    required this.details,
    this.detailsColor = Colors.white,
  }) : super(key: key);

  final String description;
  final String details;
  final Color detailsColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
          style: GoogleFonts.roboto(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF00C5FF),
          ),
        ),
        Text(
          details,
          style: GoogleFonts.roboto(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: detailsColor,
          ),
        ),
      ],
    );
  }
}
