import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';
import 'package:sideswap/screens/receive/widgets/top_recv_buttons.dart';

class AssetReceivePopup extends StatelessWidget {
  const AssetReceivePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isAmp = ref.watch(walletProvider).recvAddressAccount.isAmp();
      return SideSwapPopup(
        enableInsideTopPadding: false,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    'Receive',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                TopRecvButtons(
                  onRegularPressed: () {
                    ref
                        .read(walletProvider)
                        .toggleRecvAddrType(AccountType.reg);
                  },
                  onAmpPressed: () {
                    ref
                        .read(walletProvider)
                        .toggleRecvAddrType(AccountType.amp);
                  },
                ),
                AssetReceiveWidget(key: Key(isAmp.toString()), isAmp: isAmp),
              ],
            ),
          ),
        ),
      );
    });
  }
}
