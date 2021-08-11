import 'package:flutter/material.dart';

import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';

class AssetReceivePopup extends StatelessWidget {
  const AssetReceivePopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SideSwapPopup(
      child: AssetReceiveWidget(),
    );
  }
}
