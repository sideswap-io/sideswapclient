import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';

class TxDetailsColumn extends StatelessWidget {
  TxDetailsColumn({
    Key key,
    @required this.description,
    @required this.details,
    this.isCopyVisible = false,
    TextStyle descriptionStyle,
    TextStyle detailsStyle,
  })  : _descriptionStyle = descriptionStyle ??
            GoogleFonts.roboto(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF00C5FF),
            ),
        _detailsStyle = detailsStyle ??
            GoogleFonts.roboto(
              fontSize: 14.sp,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
        super(key: key);

  final String description;
  final String details;
  final bool isCopyVisible;
  final TextStyle _descriptionStyle;
  final TextStyle _detailsStyle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: _descriptionStyle,
        ),
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: Text(
                  details,
                  style: _detailsStyle,
                ),
              ),
              if (isCopyVisible) ...[
                Padding(
                  padding: EdgeInsets.only(left: 13.w),
                  child: Container(
                    width: 26.w,
                    height: 26.w,
                    child: FlatButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await copyToClipboard(context, details);
                      },
                      child: SvgPicture.asset(
                        'assets/copy.svg',
                        width: 26.w,
                        height: 26.w,
                        color: const Color(0xFF00C5FF),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
