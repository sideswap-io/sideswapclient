import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TxImageSmall extends StatelessWidget {
  const TxImageSmall({super.key, required this.assetName});

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetName, width: 24, height: 24);
  }
}
