import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@Deprecated('Use TxImageSmall')
String getPegImageAssetName(bool isPegIn) {
  if (isPegIn) {
    return 'assets/tx_icons/pegin.svg';
  } else {
    return 'assets/tx_icons/pegout.svg';
  }
}

class TxImageSmall extends StatelessWidget {
  const TxImageSmall({super.key, required this.assetName});

  final String assetName;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(assetName, width: 24, height: 24);
  }
}

@Deprecated('Use TxImageSmall')
class PegImageSmall extends StatelessWidget {
  const PegImageSmall({super.key, required this.isPegIn});

  final bool isPegIn;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      getPegImageAssetName(isPegIn),
      width: 24,
      height: 24,
    );
  }
}
