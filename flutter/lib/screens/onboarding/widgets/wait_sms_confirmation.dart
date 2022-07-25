import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:sideswap/common/widgets/side_swap_progress_bar.dart';

class WaitSmsConfirmation extends ImplicitlyAnimatedWidget {
  const WaitSmsConfirmation({
    super.key,
    required super.duration,
    super.onEnd,
    required this.counter,
  });

  final int counter;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _WaitSmsConfirmationState();
}

class _WaitSmsConfirmationState
    extends AnimatedWidgetBaseState<WaitSmsConfirmation> {
  IntTween? _intTween;

  @override
  void forEachTween(visitor) {
    _intTween = visitor(_intTween, widget.counter,
        (dynamic value) => IntTween(begin: widget.counter)) as IntTween;
  }

  @override
  Widget build(BuildContext context) {
    final seconds = _intTween == null
        ? widget.counter
        : widget.counter - _intTween!.evaluate(animation);
    final duration = Duration(seconds: seconds);
    final percent = widget.counter == 0 ? 0 : seconds * 100 ~/ widget.counter;
    return SizedBox(
      height: 24,
      child: Visibility(
        visible: controller.isAnimating,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideSwapProgressBar(
              percent: percent,
              displayText: false,
              duration: const Duration(seconds: 1),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'WAIT_FOR_SMS_CONFIRMATION'.tr(args: [
                  '${duration.inMinutes}',
                  ((duration.inSeconds % 60).toString().padLeft(2, '0'))
                ]),
                style: const TextStyle(
                  fontSize: 14,
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
