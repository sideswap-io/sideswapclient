import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';

class PageDots extends StatelessWidget {
  const PageDots({
    Key? key,
    this.maxSelectedDots = 0,
  }) : super(key: key);

  final int maxSelectedDots;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66.w,
      height: 10.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List<Widget>.generate(
            4,
            (i) => Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: i < maxSelectedDots
                    ? i < maxSelectedDots - 1
                        ? const Color(0xFF167399)
                        : const Color(0xFF00C5FF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5.w),
                border: Border.all(
                  color: const Color(0xFF00C5FF),
                  width: 1,
                  style: BorderStyle.solid,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
