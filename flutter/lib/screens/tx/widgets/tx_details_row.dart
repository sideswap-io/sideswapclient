import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class TxDetailsRow extends StatelessWidget {
  const TxDetailsRow({
    super.key,
    required this.description,
    required this.details,
    this.detailsColor = Colors.white,
  });

  final String description;
  final String details;
  final Color detailsColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          description,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
        Text(
          details,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: detailsColor,
          ),
        ),
      ],
    );
  }
}
