import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class AmpBottomPanelBody extends StatelessWidget {
  const AmpBottomPanelBody({
    super.key,
    this.prefix,
    required this.url,
    required this.urlText,
    this.textStyle,
  });

  final Widget? prefix;
  final String url;
  final String urlText;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefix != null) ...[prefix!, const Spacer()],
        SvgPicture.asset(
          'assets/web_icon_transparent.svg',
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(
            SideSwapColors.glacier,
            BlendMode.srcIn,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap:
                  () => openUrl(
                    url,
                    mode: LaunchMode.externalNonBrowserApplication,
                  ),
              child: Text(
                urlText,
                style: textStyle?.merge(
                  const TextStyle(
                    decoration: TextDecoration.underline,
                    color: SideSwapColors.zumthor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
