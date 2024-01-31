import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/regexp_text_highlight.dart';
import 'package:sideswap/providers/friends_provider.dart';

class FriendWidget extends StatelessWidget {
  const FriendWidget({
    super.key,
    this.width,
    required this.friend,
    this.onPressed,
    this.highlightName,
    this.backgroundColor = SideSwapColors.blueSapphire,
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
        contentPadding ?? const EdgeInsets.only(left: 12, right: 12);
    final internalWidth = width ?? 343;

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: internalWidth,
          height: 72,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: internalContentPadding.left),
                child: Container(
                  width: 49,
                  height: 49,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
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
                            radius: 23,
                            child: Text(
                              avatarText,
                              style: const TextStyle(
                                fontSize: 17,
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
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RegexTextHighlight(
                        text: friend.contact.name,
                        maxLines: 1,
                        highlightRegex:
                            RegExp('(${highlightName?.toLowerCase()})'),
                        highlightStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00B4E9),
                        ),
                        nonHighlightStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: customDescription ??
                            Text(
                              friend.contact.phone,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: SideSwapColors.airSuperiorityBlue,
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
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: showTrailingIcon
                        ? SideSwapColors.chathamsBlue
                        : Colors.transparent,
                  ),
                  child: Center(
                    child: Visibility(
                      visible: showTrailingIcon,
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        width: 14,
                        height: 14,
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
