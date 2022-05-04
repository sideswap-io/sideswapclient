import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/friends_provider.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/widgets/friend_widget.dart';
import 'package:sideswap/screens/pay/widgets/friends_panel_header.dart';

class FriendsPanel extends StatefulWidget {
  const FriendsPanel({Key? key, this.searchString}) : super(key: key);

  final String? searchString;

  @override
  _FriendsPanelState createState() => _FriendsPanelState();
}

class _FriendsPanelState extends State<FriendsPanel> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FriendsPanelHeader(),
        Consumer(
          builder: (context, ref, child) {
            final friends = widget.searchString != null
                ? ref
                    .watch(friendsProvider)
                    .getFriendListByName(widget.searchString!)
                : ref.watch(friendsProvider.select((p) => p.friends));
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      EdgeInsets.only(bottom: 8.h, left: 16.w, right: 16.w),
                  child: FriendWidget(
                    friend: friends[index],
                    highlightName: widget.searchString,
                    onPressed: () {
                      ref.read(paymentProvider).selectPaymentAmountPage(
                            PaymentAmountPageArguments(
                              friend: friends[index],
                            ),
                          );
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
