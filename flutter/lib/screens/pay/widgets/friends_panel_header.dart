import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/friends_provider.dart';
import 'package:sideswap/screens/pay/widgets/friends_panel_import_button.dart';

import 'friends_panel_invite_button.dart';

class FriendsPanelHeader extends StatelessWidget {
  const FriendsPanelHeader({
    super.key,
    this.onPressed,
    this.panelPosition = .0,
  });

  final VoidCallback? onPressed;
  final double panelPosition;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final friendsCounter =
                    ref.watch(friendsProvider).friends.length;
                return Text(
                  'SIDESWAP_FRIENDS'.tr(args: ['$friendsCounter']),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const Spacer(),
            FriendsPanelImportButton(
              width: 63,
              height: 28,
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: FriendsPanelInviteButton(
                width: 63,
                height: 28,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
