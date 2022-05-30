import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';
import 'package:sideswap/screens/qr_scanner/address_qr_scanner.dart';

class WhomToPayTextField extends StatefulHookConsumerWidget {
  const WhomToPayTextField({
    super.key,
    required this.addressController,
    required this.validator,
    this.errorText,
    this.addrType = AddrType.elements,
  });

  final TextEditingController addressController;
  final String? errorText;
  final bool Function() validator;
  final AddrType addrType;

  @override
  ConsumerState<WhomToPayTextField> createState() => WhomToPayTextFieldState();
}

class WhomToPayTextFieldState extends ConsumerState<WhomToPayTextField> {
  @override
  Widget build(BuildContext context) {
    final result = ref.watch(qrcodeResultModelProvider);
    result.maybeWhen(
      data: (result) {
        widget.addressController.text = result?.address ?? '';
        if (widget.validator()) {
          ref.read(paymentProvider).selectPaymentAmountPage(
                PaymentAmountPageArguments(
                  result: result,
                ),
              );
          return;
        }
      },
      orElse: () {},
    );

    return SizedBox(
      child: ShareCopyScanTextFormField(
        errorText: widget.errorText,
        controller: widget.addressController,
        onChanged: (addr) {
          widget.validator();
        },
        onScanTap: () {
          Navigator.of(context, rootNavigator: true).push<void>(
            MaterialPageRoute(builder: (context) {
              return Consumer(
                builder: (context, ref, _) {
                  return const AddressQrScanner();
                },
              );
            }),
          );
        },
      ),
    );
  }
}
