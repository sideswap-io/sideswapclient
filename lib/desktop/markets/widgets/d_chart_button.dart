import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';

class DChartButton extends StatelessWidget {
  const DChartButton({super.key, required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return DButton(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/chart.svg', width: 14, height: 14),
            const SizedBox(width: 6),
            Text(
              'Chart'.tr(),
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
