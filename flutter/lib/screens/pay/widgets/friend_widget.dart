import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/regexp_text_highlight.dart';
import 'package:sideswap/models/friends_provider.dart';

class FriendWidget extends StatelessWidget {
  const FriendWidget({
    super.key,
    this.width,
    required this.friend,
    this.onPressed,
    this.highlightName,
    this.backgroundColor = const Color(0xFF1D6389),
    this.showTrailingIcon = true,
    this.contentPadding,
    this.customDescription,
  });

  final Friend friend;
  final VoidCallback? onPressed;
  final String? highlightName;
  final double? width;
  final Color backgroundColor;
  final bool showTrailingIcon;
  final EdgeInsets? contentPadding;
  final Widget? customDescription;

  @override
  Widget build(BuildContext context) {
    final internalContentPadding =
        contentPadding ?? EdgeInsets.only(left: 12.w, right: 12.w);
    final internalWidth = width ?? 343.w;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8.w),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8.w),
        child: SizedBox(
          width: internalWidth,
          height: 72.h,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: internalContentPadding.left),
                child: Container(
                  width: 49.w,
                  height: 49.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24.w),
                    color: const Color(0xFF8EB1C4),
                  ),
                  child: Center(
                    child: Consumer(
                      builder: (context, ref, _) {
                        final avatar =
                            ref.watch(friendsProvider).getAvatar(friend)?.image;
                        final avatarText = avatar == null
                            ? ref
                                .watch(friendsProvider)
                                .getInitials(friend.contact)
                            : '';
                        return CircleAvatar(
                            backgroundColor: avatar != null
                                ? Colors.transparent
                                : Color(friend.backgroundColor),
                            foregroundImage: avatar,
                            radius: 23.w,
                            child: Text(
                              avatarText,
                              style: GoogleFonts.roboto(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ));
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RegexTextHighlight(
                        text: friend.contact.name,
                        maxLines: 1,
                        highlightRegex:
                            RegExp('(${highlightName?.toLowerCase()})'),
                        highlightStyle: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00B4E9),
                        ),
                        nonHighlightStyle: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: customDescription ??
                            Text(
                              friend.contact.phone,
                              style: GoogleFonts.roboto(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.normal,
                                color: const Color(0xFF709EBA),
                              ),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: internalContentPadding.right),
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: showTrailingIcon
                        ? const Color(0xFF135579)
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Visibility(
                      visible: showTrailingIcon,
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        width: 14.w,
                        height: 14.w,
                      ),
                    ),
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
