import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class LabeledRadio<T> extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    required this.label,
    required this.groupValue,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final String label;
  final T groupValue;
  final T value;
  final ValueChanged<T>? onChanged;

  @override
  Widget build(BuildContext context) {
    final textColor =
        (groupValue == value) ? Colors.white : const Color(0xFF709EBA);

    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: InkWell(
        onTap: onChanged == null ? null : () => onChanged!(value),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 22.w,
              height: 22.h,
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: const Color(0xFF709EBA),
                ),
                child: Radio<T>(
                  activeColor: const Color(0xFF00C5FF),
                  groupValue: groupValue,
                  value: value,
                  onChanged: onChanged == null
                      ? null
                      : (value) {
                          if (value != null) {
                            onChanged!(value);
                          }
                        },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Text(
                label,
                style: GoogleFonts.roboto(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
