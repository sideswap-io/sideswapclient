import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

class AmpFlag extends StatelessWidget {
  final double fontSize;
  const AmpFlag({Key? key, this.fontSize = 12}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.w),
        ),
        color: const Color(0x664994BC),
      ),
      margin: EdgeInsets.only(left: 8.w),
      padding: EdgeInsets.symmetric(
        vertical: 4.w,
        horizontal: 6.w,
      ),
      child: Text('AMP',
          style: GoogleFonts.roboto(
            fontSize: fontSize.sp,
            fontWeight: FontWeight.normal,
            color: const Color(0xFF73A7C6),
          )),
    );
  }
}
