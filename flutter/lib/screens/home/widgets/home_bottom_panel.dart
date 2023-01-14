import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common_platform.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

class HomeBottomPanel extends ConsumerWidget {
  const HomeBottomPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(qrcodeResultModelProvider);
    result.maybeWhen(
      data: (result) {
        Future.microtask(() {
          ref.read(paymentProvider).selectPaymentAmountPage(
                PaymentAmountPageArguments(
                  result: result,
                ),
              );
        });
      },
      orElse: () {},
    );

    return Container(
      height: 180,
      decoration: const BoxDecoration(
        color: Color(0xFF0F4766),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Center(
        child: SizedBox(
          width: 268,
          height: 109,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButtonWithLabel(
                onTap: () {
                  ref.read(walletProvider).selectAssetReceiveFromWalletMain();
                },
                label: 'Receive'.tr(),
                buttonBackground: Colors.white,
                child: SvgPicture.asset(
                  'assets/bottom_left_arrow.svg',
                  width: 28,
                  height: 28,
                ),
              ),
              RoundedButtonWithLabel(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push<void>(
                    MaterialPageRoute(
                      builder: (context) => commonPlatform.getAddressQrScanner(
                          bitcoinAddress: false),
                    ),
                  );
                },
                label: 'QR'.tr(),
                buttonBackground: Colors.white,
                child: SvgPicture.asset(
                  'assets/qr_code_scan.svg',
                  width: 28,
                  height: 28,
                ),
              ),
              RoundedButtonWithLabel(
                onTap: () {
                  ref.read(walletProvider).selectPaymentPage();
                },
                label: 'Pay'.tr(),
                buttonBackground: Colors.white,
                child: SvgPicture.asset(
                  'assets/top_right_arrow.svg',
                  width: 28,
                  height: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
