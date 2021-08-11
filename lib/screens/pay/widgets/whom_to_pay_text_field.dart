import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
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
      height: 74.h,
      child: ShareCopyScanTextFormField(
        errorText: widget.errorText,
        controller: widget.addressController,
        onChanged: (addr) {
          widget.validator();
        },
        onTap: () async {
          final value = await Clipboard.getData(Clipboard.kTextPlain);
          if (value?.text != null) {
            var text = value?.text?.replaceAll('\n', '') ?? '';
            text = text.replaceAll(' ', '');
            final wallet = context.read(walletProvider);
            if (wallet.isAddrValid(text, AddrType.bitcoin) ||
                wallet.isAddrValid(text, AddrType.elements)) {
              // paste only valid address
              if (context
                  .read(walletProvider)
                  .commonAddrErrorStr(text, widget.addrType)
                  .isEmpty) {
                await pasteFromClipboard(widget.addressController);
                widget.validator();
              }
            }
          }
        },
        onScanTap: () {
          Navigator.of(context, rootNavigator: true).push<void>(
            MaterialPageRoute(
              builder: (context) => AddressQrScanner(
                resultCb: (value) {
                  widget.addressController.text = value.address ?? '';
                  if (widget.validator() && value.orderId == null) {
                    context.read(paymentProvider).selectPaymentAmountPage(
                          PaymentAmountPageArguments(
                            result: value,
                          ),
                        );
                    return;
                  }

                  if (value.orderId != null) {
                    context.read(walletProvider).linkOrder(value.orderId);
                    return;
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
