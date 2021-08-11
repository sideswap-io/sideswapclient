import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';

class PegInAddress extends StatelessWidget {
  const PegInAddress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: 8.h + MediaQuery.of(context).padding.top),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 215.w,
                height: 36.h,
                child: Text(
                  'Please send BTC to the following address:',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF00C5FF),
                  ),
                ),
              ),
            ),
          ),
          const SafeArea(
            child: AssetReceiveWidget(
              isPegIn: true,
            ),
          ),
        ],
      ),
    );
  }
}
