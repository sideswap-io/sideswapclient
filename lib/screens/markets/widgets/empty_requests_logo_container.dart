import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';

class EmptyRequestsLogoContainer extends StatelessWidget {
  const EmptyRequestsLogoContainer({super.key, this.opacity = 1});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 198,
        height: 94,
        decoration: const BoxDecoration(
          color: Color(0xFF167399),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      EmptyTextContainer(
                        width: 26,
                        height: 6,
                        color: SideSwapColors.chathamsBlue,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: EmptyTextContainer(
                          width: 60,
                          height: 6,
                          color: SideSwapColors.chathamsBlue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      EmptyTextContainer(
                        width: 82,
                        height: 6,
                        color: SideSwapColors.chathamsBlue,
                      ),
                      SizedBox(width: 13),
                      EmptyTextContainer(
                        width: 75,
                        height: 6,
                        color: SideSwapColors.chathamsBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      EmptyTextContainer(
                        width: 82,
                        height: 6,
                        color: SideSwapColors.chathamsBlue,
                      ),
                      SizedBox(width: 13),
                      EmptyTextContainer(
                        width: 75,
                        height: 6,
                        color: SideSwapColors.chathamsBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      EmptyTextContainer(
                        width: 50,
                        height: 14,
                        color: Colors.transparent,
                        border: Border.all(
                            color: SideSwapColors.brightTurquoise, width: 2),
                      ),
                      const SizedBox(width: 4),
                      const EmptyTextContainer(
                        width: 50,
                        height: 14,
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
