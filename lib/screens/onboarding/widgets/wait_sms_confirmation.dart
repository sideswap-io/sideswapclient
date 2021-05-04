import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';

class WaitSmsConfirmation extends ImplicitlyAnimatedWidget {
  const WaitSmsConfirmation({
    Key key,
    @required Duration duration,
    VoidCallback onEnd,
    @required this.counter,
  }) : super(duration: duration, onEnd: onEnd, key: key);

  final int counter;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _WaitSmsConfirmationState();
}

class _WaitSmsConfirmationState
    extends AnimatedWidgetBaseState<WaitSmsConfirmation> {
  IntTween _intTween;

  @override
  void forEachTween(TweenVisitor visitor) {
    _intTween = visitor(_intTween, widget.counter,
        (dynamic value) => IntTween(begin: widget.counter)) as IntTween;
  }

  @override
  Widget build(BuildContext context) {
    final seconds = widget.counter - _intTween?.evaluate(animation) ?? 0;
    final duration = Duration(seconds: seconds);
    final percent = widget.counter == 0 ? 0 : seconds * 100 ~/ widget.counter;
    return Container(
      height: 24.h,
      child: Visibility(
        visible: controller.isAnimating,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideSwapProgressBar(
              percent: percent,
              displayText: false,
              duration: Duration(seconds: 1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Text(
                'WAIT_FOR_SMS_CONFIRMATION'.tr(args: [
                  '${duration.inMinutes}',
                  '${(duration.inSeconds % 60).toString().padLeft(2, '0')}'
                ]),
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF00C5FF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
