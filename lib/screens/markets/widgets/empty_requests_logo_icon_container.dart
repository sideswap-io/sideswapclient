import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/screens/tx/widgets/empty_tx_list_item.dart';

enum EmptyRequestLogoIcon {
  male,
  ok,
}

class EmptyRequestsLogoIconContainer extends StatelessWidget {
  const EmptyRequestsLogoIconContainer({
    super.key,
    this.icon = EmptyRequestLogoIcon.male,
    this.opacity = 1,
  });

  final EmptyRequestLogoIcon icon;
  final double opacity;

  Widget getIcon() {
    Widget internalIcon;
    switch (icon) {
      case EmptyRequestLogoIcon.male:
        internalIcon = ClipOval(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: SvgPicture.asset('assets/avatar.svg'),
          ),
        );
        break;
      case EmptyRequestLogoIcon.ok:
        internalIcon = Center(
          child: SvgPicture.asset(
            'assets/success.svg',
            width: 18,
            height: 18,
          ),
        );
        break;
    }

    return internalIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 198,
        height: 84,
        decoration: const BoxDecoration(
          color: Color(0xFF167399),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: SideSwapColors.chathamsBlue,
                  border: Border.all(
                    color: SideSwapColors.brightTurquoise,
                    width: 2,
                  ),
                ),
                child: getIcon(),
              ),
            ),
            Column(
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
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: EmptyTextContainer(
                    width: 95,
                    height: 6,
                    color: SideSwapColors.chathamsBlue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 11),
                  child: Row(
                    children: [
                      EmptyTextContainer(
                        width: 50,
                        height: 14,
                        color: Colors.transparent,
                        border: Border.all(
                            color: SideSwapColors.brightTurquoise, width: 2),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: EmptyTextContainer(
                          width: 50,
                          height: 14,
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
