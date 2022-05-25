import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/models/swap_models.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/swap/fee_suggestions.dart';

class FeeRatesDropdown extends StatelessWidget {
  const FeeRatesDropdown({
    super.key,
    required this.borderDecoration,
  });

  final BoxDecoration borderDecoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 18.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Widget builder(BuildContext context) {
              return const FeeRates();
            }

            Navigator.of(context, rootNavigator: true).push<void>(
              FlavorConfig.isDesktop
                  ? DialogRoute(builder: builder, context: context)
                  : MaterialPageRoute(builder: builder),
            );
          },
          child: Container(
            height: 42.h,
            decoration: borderDecoration,
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 225.w,
                height: 42.h,
                child: Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: Consumer(
                        builder: ((context, ref, child) {
                          final currentFeeRate = ref.watch(
                              bitcoinCurrentFeeRateStateNotifierProvider);
                          if (currentFeeRate is SwapCurrentFeeRateData) {
                            return Text(
                              ref
                                  .read(bitcoinFeeRatesProvider)
                                  .feeRateDescription(currentFeeRate.feeRate),
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: GoogleFonts.roboto(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            );
                          }

                          return Container();
                        }),
                      )),
                      Padding(
                        padding: EdgeInsets.only(bottom: 3.h),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 16.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
