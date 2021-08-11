import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:easy_localization/easy_localization.dart';

class TimeToLive extends StatefulWidget {
  const TimeToLive({
    Key? key,
    this.backgroundColor = const Color(0xFF014767),
    required this.dropdownValue,
    required this.dropdownItems,
    this.onChanged,
    this.locked = false,
  }) : super(key: key);

  final Color backgroundColor;
  final int dropdownValue;
  final List<int> dropdownItems;
  final void Function(int?)? onChanged;
  final bool locked;

  @override
  _TimeToLiveState createState() => _TimeToLiveState();
}

class _TimeToLiveState extends State<TimeToLive> {
  final _dropdownButtonKey = GlobalKey();

  String getTtlDescription(int seconds) {
    final sec = Duration(seconds: seconds);
    if (sec.inHours >= 1) {
      return '${sec.inHours}h';
    }

    return '${sec.inMinutes}m';
  }

  void openDropdown() {
    GestureDetector? detector;

    void searchForGestureDetector(BuildContext? element) {
      if (element == null) {
        return;
      }

      element.visitChildElements((element) {
        if (element.widget is GestureDetector) {
          detector = element.widget as GestureDetector;
          return;
        } else {
          searchForGestureDetector(element);
        }
      });
    }

    searchForGestureDetector(_dropdownButtonKey.currentContext);
    if (detector != null && detector!.onTap != null) {
      detector!.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openDropdown,
      child: Container(
        height: 51.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(8.r)),
          color: widget.backgroundColor,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 12.w, right: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Time-to-live:'.tr(),
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
              if (widget.locked) ...[
                Row(
                  children: [
                    Text(
                      getTtlDescription(widget.dropdownValue),
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF78AECC),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 7.w),
                      child: SvgPicture.asset(
                        'assets/lock.svg',
                        color: const Color(0xFF78AECC),
                        width: 10.w,
                        height: 13.h,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    key: _dropdownButtonKey,
                    value: widget.dropdownValue,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                    items: widget.dropdownItems
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e,
                            child: Text(getTtlDescription(e)),
                          ),
                        )
                        .toList(),
                    dropdownColor: const Color(0xFF2B6F95),
                    onChanged: widget.onChanged,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
