import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/payment_amount_page.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController? _addressController;
  String? errorText;
  AddrType addrType = AddrType.elements;
  bool enabled = false;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController()..addListener(onAddressChanged);
  }

  void onAddressChanged() {
    if (_addressController?.text == null || _addressController!.text.isEmpty) {
      setState(() {
        errorText = null;
        enabled = false;
      });
    }
  }

  bool validate() {
    final newErrorText = context
        .read(walletProvider)
        .commonAddrErrorStr(_addressController?.text ?? '', addrType);
    if (newErrorText.isNotEmpty) {
      setState(() {
        errorText = newErrorText;
        enabled = false;
      });
    } else if (_addressController != null &&
        _addressController!.text.isNotEmpty) {
      setState(() {
        errorText = null;
        enabled = true;
      });
      return true;
    }

    if (newErrorText.isEmpty) {
      setState(() {
        errorText = null;
      });
      return false;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Whom to pay'.tr(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: Container(
                  height: 74.h,
                  child: ShareCopyScanTextFormField(
                    errorText: errorText,
                    controller: _addressController,
                    onChanged: (addr) {
                      validate();
                    },
                    onTap: () async {
                      final value =
                          await Clipboard.getData(Clipboard.kTextPlain);
                      if (value?.text != null) {
                        var text = value?.text?.replaceAll('\n', '') ?? '';
                        text = text.replaceAll(' ', '');
                        final wallet = context.read(walletProvider);
                        if (wallet.isAddrValid(text, AddrType.bitcoin) ||
                            wallet.isAddrValid(text, AddrType.elements)) {
                          // paste only valid address
                          if (context
                              .read(walletProvider)
                              .commonAddrErrorStr(text, addrType)
                              .isEmpty) {
                            await pasteFromClipboard(_addressController);
                            validate();
                          }
                        }
                      }
                    },
                    onScanTap: () {
                      Navigator.of(context, rootNavigator: true).push<void>(
                        MaterialPageRoute(
                          builder: (context) => AddressQrScanner(
                            resultCb: (value) {
                              _addressController?.text = value.address ?? '';
                              if (validate()) {
                                context
                                    .read(paymentProvider)
                                    .selectPaymentAmountPage(
                                      PaymentAmountPageArguments(
                                        result: QrCodeResult(
                                            address: _addressController?.text),
                                      ),
                                    );
                                return;
                              }

                              if (value.orderId != null) {
                                context
                                    .read(walletProvider)
                                    .linkOrder(value.orderId);
                                return;
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: CustomBigButton(
                  width: double.infinity,
                  height: 54.h,
                  backgroundColor: Color(0xFF00C5FF),
                  text: 'CONTINUE'.tr(),
                  enabled: enabled,
                  onPressed: ((errorText != null) && (!enabled))
                      ? null
                      : () {
                          context.read(paymentProvider).selectPaymentAmountPage(
                                PaymentAmountPageArguments(
                                  result: QrCodeResult(
                                      address: _addressController?.text),
                                ),
                              );
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
