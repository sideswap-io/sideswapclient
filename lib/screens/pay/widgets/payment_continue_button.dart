import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';

class PaymentContinueButton extends ConsumerWidget {
  const PaymentContinueButton({
    super.key,
    required this.enabled,
    required this.errorText,
    required this.addressController,
  });

  final bool enabled;
  final String? errorText;
  final TextEditingController addressController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomBigButton(
      width: double.infinity,
      height: 54.h,
      backgroundColor: const Color(0xFF00C5FF),
      text: 'CONTINUE'.tr(),
      enabled: enabled,
      onPressed: ((errorText != null) && (!enabled))
          ? null
          : () {
              ref.read(paymentProvider).selectPaymentAmountPage(
                    PaymentAmountPageArguments(
                      result: QrCodeResult(address: addressController.text),
                    ),
                  );
            },
    );
  }
}
