import 'dart:math';

import 'package:flutter/material.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';

class EmptyTxListItem extends StatelessWidget {
  const EmptyTxListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final imageType = TxCircleImageType.values[random.nextInt(4)];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Opacity(
          opacity: 0.2,
          child: Container(
            width: double.infinity,
            height: 64.h,
            decoration: BoxDecoration(
              color: const Color(0xFF167399),
              borderRadius: BorderRadius.all(
                Radius.circular(12.w),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: TxCircleImage(
                      txCircleImageType: imageType,
                      fake: true,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 19.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmptyTextContainer(
                          width: 116.w,
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            EmptyTextContainer(
                              width: 26.w,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            EmptyTextContainer(
                              width: 60.w,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 19.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        EmptyTextContainer(
                          width: 116.w,
                        ),
                        const Spacer(),
                        EmptyTextContainer(
                          width: 65.w,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyTextContainer extends StatefulWidget {
  const EmptyTextContainer({
    Key? key,
    this.color = const Color(0xFF135579),
    this.width = 26,
    this.height,
    this.radius,
    this.border,
  }) : super(key: key);

  final Color color;
  final double width;
  final double? height;
  final double? radius;
  final BoxBorder? border;

  @override
  _EmptyTextContainerState createState() => _EmptyTextContainerState();
}

class _EmptyTextContainerState extends State<EmptyTextContainer> {
  double height = 0;
  double radius = 0;

  @override
  void initState() {
    super.initState();
    height = widget.height ?? 10.h;
    radius = widget.radius ?? 8.w;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: height,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.all(
          Radius.circular(radius),
        ),
        border: widget.border,
      ),
    );
  }
}
