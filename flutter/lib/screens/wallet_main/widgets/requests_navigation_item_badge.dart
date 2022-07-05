import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/models/payment_requests_provider.dart';

class RequestsNavigationItemBadge extends StatelessWidget {
  const RequestsNavigationItemBadge({
    super.key,
    required this.backgroundColor,
    required this.itemColor,
    required this.assetName,
  });

  final Color backgroundColor;
  final Color itemColor;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return SizedBox(
          width: 32.w,
          height: 30.h,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 5.h),
                  child: SvgPicture.asset(
                    assetName,
                    height: 23.h,
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final requests = ref.watch(
                      paymentRequestsProvider.select((p) => p.paymentRequests));
                  final length = requests.length;
                  final badgeNumber = length > 99 ? '99+' : '$length';
                  return Visibility(
                    visible: length != 0,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        width: 22.w,
                        height: 22.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: backgroundColor,
                            width: 2,
                          ),
                          color: itemColor,
                        ),
                        child: Center(
                          child: Text(
                            badgeNumber,
                            style: GoogleFonts.roboto(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: backgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
