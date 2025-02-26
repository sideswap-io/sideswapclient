import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';

class DWaitPegin extends ConsumerWidget {
  const DWaitPegin({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DPopupWithClose(
      width: 580,
      height: 740,
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text('Peg-In'.tr(), style: Theme.of(context).textTheme.displaySmall),
          const SizedBox(height: 8),
          Text(
            'Please send BTC to the following address:'.tr(),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: Color(0xFF00B4E9),
            ),
          ),
          const Flexible(
            child: AssetReceiveWidget(isPegIn: true, showShare: false),
          ),
        ],
      ),
    );
  }
}
