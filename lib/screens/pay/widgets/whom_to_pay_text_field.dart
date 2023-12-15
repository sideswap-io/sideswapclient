import 'package:flutter/material.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';

class WhomToPayTextField extends StatelessWidget {
  const WhomToPayTextField({
    super.key,
    required this.addressController,
    this.errorText,
    this.addrType = AddrType.elements,
  });

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
              return getAddressQrScanner(bitcoinAddress: false);
            }),
          );
        },
      ),
    );
  }
}
