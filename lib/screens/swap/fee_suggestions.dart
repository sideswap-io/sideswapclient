import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/swap_provider.dart';

class FeeRates extends StatelessWidget {
  const FeeRates({
    Key? key,
  }) : super(key: key);

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
          child: Consumer(builder: (context, ref, _) {
            final feeRates =
                ref.watch(bitcoinFeeRatesProvider.select((p) => p.feeRates));
            return ListView.builder(
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
                            ref
                                .read(bitcoinCurrentFeeRateStateNotifierProvider
                                    .notifier)
                                .setFeeRate(feeRates[index]);
                            Navigator.of(context).pop();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                ref
                                    .read(bitcoinFeeRatesProvider)
                                    .feeRateDescription(feeRates[index]),
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
            );
          }),
        ),
      ),
    );
  }
}
