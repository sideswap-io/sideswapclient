import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/screens/balances.dart';

String getTxImageAssetName(TxType txType) {
  switch (txType) {
    case TxType.received:
      return 'assets/tx_icons/recv.svg';
    case TxType.sent:
      return 'assets/tx_icons/sent.svg';
    case TxType.swap:
      return 'assets/tx_icons/swap.svg';
    case TxType.internal:
      return 'assets/tx_icons/internal.svg';
    case TxType.unknown:
      return 'assets/tx_icons/unknown.svg';
  }
}

String getPegImageAssetName(bool isPegIn) {
  if (isPegIn) {
    return 'assets/tx_icons/pegin.svg';
  } else {
    return 'assets/tx_icons/pegout.svg';
  }
}

class TxImageSmall extends StatelessWidget {
  const TxImageSmall({
    Key? key,
    required this.txType,
  }) : super(key: key);

  final TxType txType;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      getTxImageAssetName(txType),
      width: 24,
      height: 24,
    );
  }
}

class PegImageSmall extends StatelessWidget {
  const PegImageSmall({
    Key? key,
    required this.isPegIn,
  }) : super(key: key);

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
