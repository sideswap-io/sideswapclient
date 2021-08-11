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
    Key? key,
    this.icon = ContactMockupIcon.male1,
    this.width,
    this.height,
    this.radius,
  }) : super(key: key);

  final ContactMockupIcon icon;
  final double? width;
  final double? height;
  final Radius? radius;

  SvgPicture getIcon() {
    SvgPicture _icon;
    switch (icon) {
      case ContactMockupIcon.male1:
        _icon = SvgPicture.asset('assets/male1.svg');
        break;
      case ContactMockupIcon.male2:
        _icon = SvgPicture.asset('assets/male2.svg');
        break;
      case ContactMockupIcon.female1:
        _icon = SvgPicture.asset('assets/female1.svg');
        break;
    }

    return _icon;
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
    final _width = width ?? 116.w;
    final _height = height ?? 48.h;
    final _radius = radius ?? Radius.circular(8.r);

    final lineData = getLineData();
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        color: const Color(0xFFCAF3FF),
        borderRadius: BorderRadius.all(_radius),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: _width * 0.2758,
              height: _width * 0.2758,
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
