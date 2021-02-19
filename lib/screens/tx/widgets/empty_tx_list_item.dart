import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';

class EmptyTxListItem extends StatelessWidget {
  EmptyTxListItem({Key key}) : super(key: key);

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
              color: Color(0xFF167399),
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
                        Spacer(),
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
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 19.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        EmptyTextContainer(
                          width: 116.w,
                        ),
                        Spacer(),
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

class EmptyTextContainer extends StatelessWidget {
  const EmptyTextContainer({Key key, this.width = 26}) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: 10.h,
        decoration: BoxDecoration(
          color: Color(0xFF135579),
          borderRadius: BorderRadius.all(
            Radius.circular(8.w),
          ),
        ));
  }
}
