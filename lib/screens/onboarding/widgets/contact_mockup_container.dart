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
  const ContactMockupContainer({Key key, this.icon = ContactMockupIcon.male1})
      : super(key: key);

  final ContactMockupIcon icon;

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
    final height = 4.h;
    final color = Color(0xFF00C5FF);
    switch (icon) {
      case ContactMockupIcon.male1:
        lineData
          ..add(EmptyLineData(16.w, height, color))
          ..add(EmptyLineData(34, height, color))
          ..add(EmptyLineData(58.w, height, color));
        break;
      case ContactMockupIcon.male2:
        lineData
          ..add(EmptyLineData(28.w, height, color))
          ..add(EmptyLineData(22, height, color))
          ..add(EmptyLineData(51.w, height, color));
        break;
      case ContactMockupIcon.female1:
        lineData
          ..add(EmptyLineData(34.w, height, color))
          ..add(EmptyLineData(21, height, color))
          ..add(EmptyLineData(59.w, height, color));
        break;
    }

    return lineData;
  }

  @override
  Widget build(BuildContext context) {
    final lineData = getLineData();
    return Container(
      width: 116.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: Color(0xFFCAF3FF),
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Color(0xFF00C5FF),
                shape: BoxShape.circle,
                border: Border.all(
                  width: 2.w,
                  color: Color(0xFF00C5FF),
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
