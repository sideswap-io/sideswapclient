import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

class DWorkingOrders extends StatelessWidget {
  const DWorkingOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 103),
          child: Text(
            'No working orders'.tr(),
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: SideSwapColors.glacier),
          ),
        ),
      ],
    );
  }
}
