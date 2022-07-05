import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';

enum ContactMockupIcon {
  male1,
  male2,
  female1,
}

class EmptyLineData {
  EmptyLineData(this.width, this.height, this.color);

  final double width;
  final double height;
  final Color color;
}

class ContactMockupContainer extends StatelessWidget {
  const ContactMockupContainer({
    super.key,
    this.icon = ContactMockupIcon.male1,
    this.width,
    this.height,
    this.radius,
  });

  final ContactMockupIcon icon;
  final double? width;
  final double? height;
  final Radius? radius;

  SvgPicture getIcon() {
    SvgPicture iconPicture;
    switch (icon) {
      case ContactMockupIcon.male1:
        iconPicture = SvgPicture.asset('assets/male1.svg');
        break;
      case ContactMockupIcon.male2:
        iconPicture = SvgPicture.asset('assets/male2.svg');
        break;
      case ContactMockupIcon.female1:
        iconPicture = SvgPicture.asset('assets/female1.svg');
        break;
    }

    return iconPicture;
  }

  List<EmptyLineData> getLineData() {
    final lineData = <EmptyLineData>[];
    final lineHeight = 4.h;
    const color = Color(0xFF00C5FF);
    switch (icon) {
      case ContactMockupIcon.male1:
        lineData
          ..add(EmptyLineData(16.w, lineHeight, color))
          ..add(EmptyLineData(34, lineHeight, color))
          ..add(EmptyLineData(58.w, lineHeight, color));
        break;
      case ContactMockupIcon.male2:
        lineData
          ..add(EmptyLineData(28.w, lineHeight, color))
          ..add(EmptyLineData(22, lineHeight, color))
          ..add(EmptyLineData(51.w, lineHeight, color));
        break;
      case ContactMockupIcon.female1:
        lineData
          ..add(EmptyLineData(34.w, lineHeight, color))
          ..add(EmptyLineData(21, lineHeight, color))
          ..add(EmptyLineData(59.w, lineHeight, color));
        break;
    }

    return lineData;
  }

  @override
  Widget build(BuildContext context) {
    final internalWidth = width ?? 116.w;
    final internalHeight = height ?? 48.h;
    final internalRadius = radius ?? Radius.circular(8.r);

    final lineData = getLineData();
    return Container(
      width: internalWidth,
      height: internalHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFCAF3FF),
        borderRadius: BorderRadius.all(internalRadius),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: internalWidth * 0.2758,
              height: internalWidth * 0.2758,
              decoration: BoxDecoration(
                color: const Color(0xFF00C5FF),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2.w,
                  color: const Color(0xFF00C5FF),
                ),
              ),
              child: getIcon(),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  EmptyTextContainer(
                    width: lineData[0].width,
                    height: lineData[0].height,
                    color: lineData[0].color,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: EmptyTextContainer(
                      width: lineData[1].width,
                      height: lineData[1].height,
                      color: lineData[1].color,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: EmptyTextContainer(
                  width: lineData[2].width,
                  height: lineData[2].height,
                  color: lineData[2].color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
