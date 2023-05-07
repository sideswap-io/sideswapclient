import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/prompt_allow_tx_chaining.dart';

class AllowTxChainingButton extends StatelessWidget {
  const AllowTxChainingButton({
    Key? key,
    required this.text,
    required this.value,
  }) : super(key: key);

  final String text;
  final AllowTxChaining value;

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      width: 295,
      height: 54,
      text: text,
      backgroundColor: SideSwapColors.brightTurquoise,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(value);
      },
    );
  }
}
