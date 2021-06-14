import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/pin_keyboard_provider.dart';

class PinKeyboard extends StatefulWidget {
  PinKeyboard({
    Key? key,
    this.onlyAccept = false,
    this.showUnlock = false,
  }) : super(key: key);

  final bool onlyAccept;
  final bool showUnlock;

  @override
  _PinKeyboardState createState() => _PinKeyboardState();
}

class _PinKeyboardState extends State<PinKeyboard> {
  final _buttonStyle = GoogleFonts.roboto(
    fontSize: 26.sp,
    fontWeight: FontWeight.w500,
    color: Color(0xFF00C5FF),
  );

  final _saveStyle = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final _itemWidth = 96.w;
    final _itemHeight = 57.h;

    return Container(
      width: 319.w,
      height: 278.h,
      child: GridView.count(
        crossAxisCount: 3,
        addRepaintBoundaries: false,
        shrinkWrap: false,
        padding: EdgeInsets.zero,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: _itemWidth / _itemHeight,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(12, (index) {
          Widget child;
          if (index == 9) {
            child = Icon(
              Icons.backspace_outlined,
              color: Color(0xFF00C5FF),
              size: 28.w,
            );
          } else if (index == 10) {
            child = Text(
              '0',
              style: _buttonStyle,
            );
          } else if (index == 11) {
            if (widget.showUnlock) {
              child = Text(
                'UNLOCK'.tr(),
                style: _saveStyle,
              );
            } else if (widget.onlyAccept) {
              child = Text(
                'SAVE'.tr(),
                style: _saveStyle,
              );
            } else {
              child = Icon(
                Icons.keyboard_return,
                color: Colors.white,
                size: 28.w,
              );
            }
          } else {
            child = Text(
              '${index + 1}',
              style: _buttonStyle,
            );
          }

          return Material(
            color: Color(0xFF135579),
            // elevation: 1,
            borderRadius: BorderRadius.all(Radius.circular(8.w)),
            child: InkWell(
              onTap: () {
                HapticFeedback.mediumImpact();
                context.read(pinKeyboardProvider).keyPressed(index);
              },
              borderRadius: BorderRadius.all(Radius.circular(8.w)),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.w)),
                  border: Border.all(
                    color: Color(0xFF23729D),
                  ),
                  color: index == 11 ? Color(0xFF00C5FF) : Colors.transparent,
                ),
                child: Center(
                  child: child,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
