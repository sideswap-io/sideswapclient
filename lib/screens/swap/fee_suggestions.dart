import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';

String getFeeRate({FeeRate? feeRate}) {
  if (feeRate == null) {
    return '';
  }

  final blocks = feeRate.blocks;
  final value = feeRate.value;
  final duration = Duration(minutes: blocks * 10);
  if (duration.inMinutes <= 60) {
    return 'BLOCKS_MINUTES'
        .tr(args: ['$blocks', '${duration.inMinutes}', '$value']);
  } else if (duration.inHours == 1) {
    return 'BLOCKS_HOUR'.tr(args: ['$blocks', '${duration.inHours}', '$value']);
  } else {
    return 'BLOCKS_HOURS'
        .tr(args: ['$blocks', '${duration.inHours}', '$value']);
  }
}

class FeeRates extends StatelessWidget {
  const FeeRates({
    Key? key,
    this.feeRates = const <FeeRate>[],
    this.onPressed,
  }) : super(key: key);

  final List<FeeRate> feeRates;
  final void Function(FeeRate)? onPressed;

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: () async {
        return true;
      },
      appBar: CustomAppBar(
        title: 'Fee Suggestions'.tr(),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
          child: ListView.builder(
            itemCount: feeRates.length,
            itemBuilder: (context, index) {
              if (feeRates.isNotEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Container(
                    height: 50.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.w),
                      ),
                      color: const Color(0xFF135579),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.w),
                        ),
                        onTap: () {
                          if (onPressed != null) {
                            onPressed!(feeRates[index]);
                          }
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              getFeeRate(feeRate: feeRates[index]),
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
