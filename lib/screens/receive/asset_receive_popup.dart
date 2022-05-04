import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';
import 'package:sideswap/screens/receive/widgets/top_recv_buttons.dart';

class AssetReceivePopup extends StatelessWidget {
  const AssetReceivePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final isAmp = ref.watch(walletProvider).recvAddressAccount.isAmp();
      return SideSwapPopup(
        enableInsideTopPadding: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                'Receive',
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            TopRecvButtons(
              onRegularPressed: () {
                ref
                    .read(walletProvider)
                    .toggleRecvAddrType(AccountType.regular);
              },
              onAmpPressed: () {
                ref.read(walletProvider).toggleRecvAddrType(AccountType.amp);
              },
            ),
            AssetReceiveWidget(key: Key(isAmp.toString()), isAmp: isAmp),
          ],
        ),
      );
    });
  }
}
