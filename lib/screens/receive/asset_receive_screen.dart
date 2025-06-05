import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/receive/widgets/qr_receive_address.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class AssetReceiveScreen extends HookConsumerWidget {
  const AssetReceiveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);

    useEffect(() {
      ref.read(walletProvider).toggleRecvAddrType(selectedAccountType);

      return;
    }, [selectedAccountType]);

    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Generate address'.tr(),
        onPressed: () {
          ref.read(walletProvider).goBack();
        },
        showTrailingButton: true,
        trailingWidget: CustomBackButton(
          onPressed: () {
            ref
                .read(pageStatusNotifierProvider.notifier)
                .setStatus(Status.registered);
          },
        ),
      ),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Consumer(
          builder: (context, ref, child) {
            final receiveAddress = ref.watch(currentReceiveAddressProvider);
            final isAmp = receiveAddress.account == Account.AMP_;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    isAmp
                        ? 'Address for AMP Securities wallet successfully generated'
                              .tr()
                        : 'Address for regular wallet successfully generated'
                              .tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                ...switch (receiveAddress.recvAddress.isEmpty) {
                  true => [
                    const SizedBox(
                      width: 32,
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    ),
                  ],
                  false => [QrReceiveAddress()],
                },
              ],
            );
          },
        ),
      ),
    );
  }
}
