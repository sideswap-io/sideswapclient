import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/tx_provider.dart';

import 'package:sideswap/screens/tx/widgets/tx_circle_image.dart';

class EmptyTxListItem extends StatelessWidget {
  const EmptyTxListItem({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final imageType = TxCircleImageType.values[random.nextInt(4)];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Opacity(
          opacity: 0.2,
          child: Container(
            width: double.infinity,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFF167399),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: TxCircleImage(
                      txCircleImageType: imageType,
                      fake: true,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 19),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EmptyTextContainer(
                          width: 116,
                        ),
                        Spacer(),
                        Row(
                          children: [
                            EmptyTextContainer(width: 26),
                            SizedBox(width: 4),
                            EmptyTextContainer(width: 60)
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 19),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        EmptyTextContainer(width: 116),
                        Spacer(),
                        EmptyTextContainer(width: 65),
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
    super.key,
    this.color = SideSwapColors.chathamsBlue,
    this.width = 26.0,
    this.height,
    this.radius,
    this.border,
  });

  final Color color;
  final double width;
  final double? height;
  final double? radius;
  final BoxBorder? border;

  @override
  EmptyTextContainerState createState() => EmptyTextContainerState();
}

class EmptyTextContainerState extends State<EmptyTextContainer> {
  double height = 0.0;
  double radius = 0.0;

  @override
  void initState() {
    super.initState();
    height = widget.height ?? 10;
    radius = widget.radius ?? 8;
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
