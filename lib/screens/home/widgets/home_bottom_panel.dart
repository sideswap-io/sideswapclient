import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

class HomeBottomPanel extends StatelessWidget {
  HomeBottomPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180.h,
      decoration: BoxDecoration(
        color: Color(0xFF0F4766),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.w),
          topRight: Radius.circular(16.w),
        ),
      ),
      child: Center(
        child: Container(
          width: 268.w,
          height: 106.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundedButtonWithLabel(
                onTap: () {
                  context
                      .read(walletProvider)
                      .selectAssetReceiveFromWalletMain();
                },
                label: 'Receive'.tr(),
                child: SvgPicture.asset(
                  'assets/bottom_left_arrow.svg',
                  width: 28.w,
                  height: 28.w,
                ),
                buttonBackground: Colors.white,
              ),
              RoundedButtonWithLabel(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push<void>(
                    MaterialPageRoute(
                      builder: (context) => AddressQrScanner(
                        resultCb: (value) {
                          if (value.orderId != null) {
                            context
                                .read(walletProvider)
                                .linkOrder(value.orderId);
                            return;
                          }
                          context.read(paymentProvider).selectPaymentAmountPage(
                                PaymentAmountPageArguments(
                                  result: value,
                                ),
                              );
                        },
                      ),
                    ),
                  );
                },
                label: 'QR'.tr(),
                child: SvgPicture.asset(
                  'assets/qr_code_scan.svg',
                  width: 28.w,
                  height: 28.w,
                ),
                buttonBackground: Colors.white,
              ),
              RoundedButtonWithLabel(
                onTap: () {
                  final liquidAssetId =
                      context.read(walletProvider).liquidAssetId();
                  context.read(walletProvider).selectedWalletAsset =
                      liquidAssetId;
                  context.read(walletProvider).selectPaymentPage();
                },
                label: 'Pay'.tr(),
                child: SvgPicture.asset(
                  'assets/top_right_arrow.svg',
                  width: 28.w,
                  height: 28.w,
                ),
                buttonBackground: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
