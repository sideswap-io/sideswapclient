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
    final selectedAccountType = ref.watch(selectedAccountTypeProvider);
    final receiveAddress = ref.watch(currentReceiveAddressProvider);

    final isAmp = selectedAccountType == Account.AMP_;

    useEffect(() {
      ref.read(walletProvider).toggleRecvAddrType(selectedAccountType);

      return;
    }, [selectedAccountType]);

    // `Center` rather than a `MainAxisSize.min` column: the column let the card
    // keep its natural 683 px whatever the window was, so at the supported
    // floor of 620 px it overflowed. Under `Center` the card is bounded by the
    // window, and the body below scrolls the shortfall. ADR-0014 decision 8.
    return Center(
      child: Container(
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
                      style: Theme.of(context).textTheme.displaySmall
                          ?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 8),
                    switch (receiveAddress.recvAddress.isEmpty) {
                      true => const SizedBox(
                        width: 32,
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                      // `Flexible` alone squeezed this column and clipped
                      // the address silently; both halves are required, so
                      // the body scrolls what the card cannot show. The
                      // title above and the close button stay outside it.
                      // ADR-0014 decisions 8 and 9.
                      false => Flexible(
                        child: SingleChildScrollView(
                          primary: false,
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
    );
  }
}
