import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/home/widgets/home_bottom_panel.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';
import 'package:sideswap/common/screen_utils.dart';

class Home extends StatelessWidget {
  Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 16.w),
                          child: RoundedButton(
                            onTap: () {
                              context.read(walletProvider).settingsViewPage();
                            },
                            child: SvgPicture.asset('assets/settings.svg'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 34.h),
                    child: Container(
                      width: 156.w,
                      height: 152.h,
                      child: SvgPicture.asset('assets/logo.svg'),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  // TODO: Notification test - remove after tests
                  // CustomBigButton(
                  //   onPressed: () {
                  //     context
                  //         .read(notificationsProvider)
                  //         .parsePayload("")
                  //   },
                  // ),
                  HomeBottomPanel()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
