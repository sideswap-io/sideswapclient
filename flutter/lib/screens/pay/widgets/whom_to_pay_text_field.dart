import 'package:flutter/material.dart';
import 'package:sideswap/common_platform.dart';

import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';

class WhomToPayTextField extends StatelessWidget {
  const WhomToPayTextField({
    Key? key,
    required this.addressController,
    this.errorText,
    this.addrType = AddrType.elements,
  }) : super(key: key);

  final TextEditingController addressController;
  final String? errorText;
  final AddrType addrType;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ShareCopyScanTextFormField(
        errorText: errorText,
        controller: addressController,
        onScanTap: () {
          Navigator.of(context, rootNavigator: true).push<void>(
            MaterialPageRoute(builder: (context) {
              return commonPlatform.getAddressQrScanner(bitcoinAddress: false);
            }),
          );
        },
      ),
    );
  }
}
