import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/providers/friends_provider.dart';
import 'package:sideswap/providers/payment_provider.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/widgets/friend_widget.dart';
import 'package:sideswap/screens/pay/widgets/friends_panel_header.dart';

class FriendsPanel extends StatefulWidget {
  const FriendsPanel({super.key, this.searchString});

  final String? searchString;

  @override
  FriendsPanelState createState() => FriendsPanelState();
}

class FriendsPanelState extends State<FriendsPanel> {
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
                      const EdgeInsets.only(bottom: 8, left: 16, right: 16),
                  child: FriendWidget(
                    friend: friends[index],
                    highlightName: widget.searchString,
                    onPressed: () {
                      ref
                          .read(paymentAmountPageArgumentsNotifierProvider
                              .notifier)
                          .setPaymentAmountPageArguments(
                              PaymentAmountPageArguments(
                            friend: friends[index],
                          ));
                      ref
                          .read(pageStatusStateProvider.notifier)
                          .setStatus(Status.paymentAmountPage);
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
