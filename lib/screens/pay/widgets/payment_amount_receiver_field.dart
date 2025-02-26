import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class PaymentAmountReceiverField extends StatelessWidget {
  const PaymentAmountReceiverField({
    super.key,
    required this.labelStyle,
    this.text = '',
  });

  final TextStyle labelStyle;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 26),
          child: Text('Receiver', style: labelStyle).tr(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextField(
            controller: TextEditingController()..text = text,
            maxLines: null,
            readOnly: true,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: SideSwapColors.blueSapphire,
            ),
          ),
        ),
      ],
    );
  }
}
