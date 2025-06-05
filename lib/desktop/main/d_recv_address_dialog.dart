import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/main/widgets/d_qr_recv_address.dart';
import 'package:sideswap/providers/selected_account_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DReceiveAddressDialog extends HookConsumerWidget {
  const DReceiveAddressDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedAccountType = ref.watch(selectedAccountTypeNotifierProvider);
    final receiveAddress = ref.watch(currentReceiveAddressProvider);

    final isAmp = selectedAccountType == Account.AMP_;

    useEffect(() {
      ref.read(walletProvider).toggleRecvAddrType(selectedAccountType);

      return;
    }, [selectedAccountType]);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 580,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SideSwapColors.blumine,
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 40,
                  right: 40,
                  top: 40,
                  bottom: 10,
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Generate address'.tr(),
                        style: Theme.of(
                          context,
                        ).textTheme.displaySmall?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      switch (receiveAddress.recvAddress.isEmpty) {
                        true => const SizedBox(
                          width: 32,
                          height: 100,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        false => Flexible(
                          child: Column(
                            children: [
                              Text(
                                isAmp
                                    ? 'Address for AMP Securities wallet successfully generated'
                                          .tr()
                                    : "Address for regular wallet successfully generated"
                                          .tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              DQrRecvAddress(),
                            ],
                          ),
                        ),
                      },
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DIconButton(
                    icon: const Icon(
                      Icons.close,
                      color: SideSwapColors.freshAir,
                      size: 18,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
