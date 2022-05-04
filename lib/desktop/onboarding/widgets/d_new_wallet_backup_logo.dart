import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DNewWalletBackupLogo extends StatelessWidget {
  const DNewWalletBackupLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 376,
      height: 202,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          SvgPicture.asset(
            'assets/shield_big.svg',
            width: 182,
            height: 202,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 57),
            child: SvgPicture.asset(
              'assets/locker.svg',
              width: 54,
              height: 73,
            ),
          ),
        ],
      ),
    );
  }
}
