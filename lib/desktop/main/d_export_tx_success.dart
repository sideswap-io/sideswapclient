import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/settings/widgets/d_colored_circular_icon.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';

class DExportTxSuccess extends ConsumerWidget {
  const DExportTxSuccess({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DPopupWithClose(
      width: 580,
      height: 360,
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Transaction export'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const DColoredCircularIcon(type: DColoredCircularIconType.success),
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Text(
              'Transaction successfully exported'.tr(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: DCustomFilledBigButton(
              width: 500,
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'.tr()),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
