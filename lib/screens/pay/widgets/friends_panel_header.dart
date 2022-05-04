import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/screens/pay/widgets/friends_panel_import_button.dart';

import 'friends_panel_invite_button.dart';

class FriendsPanelHeader extends StatelessWidget {
  const FriendsPanelHeader({
    Key? key,
    this.onPressed,
    this.panelPosition = .0,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final double panelPosition;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final friendsCounter =
                    ref.watch(friendsProvider).friends.length;
                return Text(
                  'SIDESWAP_FRIENDS'.tr(args: ['$friendsCounter']),
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const Spacer(),
            FriendsPanelImportButton(
              width: 63.w,
              height: 28.h,
              onPressed: () {},
            ),
            Padding(
              padding: EdgeInsets.only(left: 6.w),
              child: FriendsPanelInviteButton(
                width: 63.w,
                height: 28.h,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
