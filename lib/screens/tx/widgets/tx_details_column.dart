import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/screens/pay/widgets/friend_widget.dart';

class TxDetailsColumn extends StatelessWidget {
  TxDetailsColumn({
    super.key,
    required this.description,
    required this.details,
    this.isCopyVisible = false,
    TextStyle? descriptionStyle,
    TextStyle? detailsStyle,
    this.friend,
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
            );

  final String description;
  final String details;
  final bool isCopyVisible;
  final TextStyle _descriptionStyle;
  final TextStyle _detailsStyle;
  final Friend? friend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          description,
          style: _descriptionStyle,
        ),
        if (friend != null) ...[
          Padding(
            padding: EdgeInsets.only(top: 0.h),
            child: FriendWidget(
              friend: friend!,
              backgroundColor: const Color(0xFF135579),
              showTrailingIcon: false,
              contentPadding: EdgeInsets.only(left: 0, right: 12.w),
            ),
          ),
        ] else ...[
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: SelectableText(
                    details,
                    style: _detailsStyle,
                  ),
                ),
                if (isCopyVisible) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 13.w),
                    child: SizedBox(
                      width: 26.w,
                      height: 26.w,
                      child: TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
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
      ],
    );
  }
}
