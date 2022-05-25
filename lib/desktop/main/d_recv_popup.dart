import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';
import 'package:sideswap/screens/receive/widgets/top_recv_buttons.dart';

class DReceivePopup extends ConsumerWidget {
  const DReceivePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAmp = ref.watch(walletProvider).recvAddressAccount.isAmp();
    return DPopupWithClose(
      width: 580,
      height: 690,
      child: Column(
        children: [
          const SizedBox(height: 32),
          Text(
            'Receive'.tr(),
            style: Theme.of(context).textTheme.headline3,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 343,
            height: 36,
            child: TopRecvButtons(
              onRegularPressed: () {
                ref
                    .read(walletProvider)
                    .toggleRecvAddrType(AccountType.regular);
              },
              onAmpPressed: () {
                ref.read(walletProvider).toggleRecvAddrType(AccountType.amp);
              },
            ),
          ),
          AssetReceiveWidget(
            key: Key(isAmp.toString()),
            isAmp: isAmp,
            showShare: false,
          ),
        ],
      ),
    );
  }
}
