import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum DColoredCircularIconType {
  delete,
  success,
}

class DColoredCircularIcon extends StatelessWidget {
  const DColoredCircularIcon({
    Key? key,
    this.type = DColoredCircularIconType.delete,
  }) : super(key: key);

  final DColoredCircularIconType type;

  @override
  Widget build(BuildContext context) {
    var color = const Color(0xFFFF7878);
    var icon = 'assets/delete.svg';
    switch (type) {
      case DColoredCircularIconType.delete:
        break;
      case DColoredCircularIconType.success:
        color = const Color(0xFF00C5FF);
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
          color: Colors.white,
        ),
      ),
    );
  }
}
