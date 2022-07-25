import 'package:flutter/material.dart';

class PageDots extends StatelessWidget {
  const PageDots({
    super.key,
    this.maxSelectedDots = 0,
  });

  final int maxSelectedDots;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 66,
      height: 10,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...List<Widget>.generate(
            4,
            (i) => Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: i < maxSelectedDots
                    ? i < maxSelectedDots - 1
                        ? const Color(0xFF167399)
                        : const Color(0xFF00C5FF)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
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
