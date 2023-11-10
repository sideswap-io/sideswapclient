import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

enum DColoredCircularIconType {
  delete,
  success,
}

class DColoredCircularIcon extends StatelessWidget {
  const DColoredCircularIcon({
    super.key,
    this.type = DColoredCircularIconType.delete,
  });

  final DColoredCircularIconType type;

  @override
  Widget build(BuildContext context) {
    var color = SideSwapColors.bitterSweet;
    var icon = 'assets/delete.svg';
    switch (type) {
      case DColoredCircularIconType.delete:
        break;
      case DColoredCircularIconType.success:
        color = SideSwapColors.brightTurquoise;
        icon = 'assets/success.svg';
        break;
    }

    return Container(
      width: 102,
      height: 102,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 8),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          width: 27,
          height: 27,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }
}
