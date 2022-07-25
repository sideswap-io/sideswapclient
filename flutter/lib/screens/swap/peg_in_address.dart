import 'package:flutter/material.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';

class PegInAddress extends StatelessWidget {
  const PegInAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: 8 + MediaQuery.of(context).padding.top),
            child: const Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 215,
                height: 36,
                child: Text(
                  'Please send BTC to the following address:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF00C5FF),
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
