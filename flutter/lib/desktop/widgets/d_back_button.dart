import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';

class DBackButton extends StatelessWidget {
  const DBackButton({
    super.key,
    this.onBackPressed,
    this.height,
  });

  final VoidCallback? onBackPressed;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return DHoverButton(
      builder: (context, states) {
        return Container(
          height: height,
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: SideSwapColors.brightTurquoise,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset('assets/arrow_back3.svg'),
              const SizedBox(width: 7),
              Text('Back'.tr()),
            ],
          ),
        );
      },
      onPressed: onBackPressed,
    );
  }
}
