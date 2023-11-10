import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';

class AssetReceiveScreen extends ConsumerWidget {
  const AssetReceiveScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Generate address".tr(),
        onPressed: () {
          ref.read(walletProvider).goBack();
        },
      ),
      backgroundColor: Colors.transparent,
      body: Consumer(
        builder: (context, ref, child) {
          final isAmp = ref.watch(walletRecvAddressAccount).isAmp;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  isAmp
                      ? 'Address for AMP Securities wallet successfully generated'
                      .tr()
                      : "Address for regular wallet successfully generated"
                      .tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              AssetReceiveWidget(
                key: Key(isAmp.toString()),
              ),
            ],
          );
        },
      ),
    );
  }
}
