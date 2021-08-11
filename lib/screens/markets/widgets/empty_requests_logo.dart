import 'package:flutter/material.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/markets/widgets/empty_requests_logo_container.dart';

class EmptyRequestsLogo extends StatelessWidget {
  const EmptyRequestsLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 238.w,
      height: 180.h,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const EmptyRequestsLogoContainer(
                opacity: 0.2,
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: const EmptyRequestsLogoContainer(
                  opacity: 0.2,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 40.w, top: 48.h),
            child: const EmptyRequestsLogoContainer(
              icon: EmptyRequestLogoIcon.ok,
            ),
          ),
        ],
      ),
    );
  }
}
