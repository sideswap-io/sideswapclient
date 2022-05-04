import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sideswap/common/widgets.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';

class WhomToPayTextField extends StatefulWidget {
  const WhomToPayTextField({
    Key? key,
    required this.addressController,
    required this.validator,
    this.errorText,
    this.addrType = AddrType.elements,
  }) : super(key: key);

  final TextEditingController addressController;
  final String? errorText;
  final bool Function() validator;
  final AddrType addrType;

  @override
  _WhomToPayTextFieldState createState() => _WhomToPayTextFieldState();
}

class _WhomToPayTextFieldState extends State<WhomToPayTextField> {
  @override
  Widget build(BuildContext context) {
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
                  return AddressQrScanner(
                    resultCb: (value) {
                      widget.addressController.text = value.address ?? '';
                      if (widget.validator()) {
                        ref.read(paymentProvider).selectPaymentAmountPage(
                              PaymentAmountPageArguments(
                                result: value,
                              ),
                            );
                        return;
                      }
                    },
                  );
                },
              );
            }),
          );
        },
      ),
    );
  }
}
