import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/screens/flavor_config.dart';

class AmpIdPanel extends StatelessWidget {
  const AmpIdPanel({
    super.key,
    required this.ampId,
    this.backgroundColor = SideSwapColors.blumine,
    this.icon,
    this.border,
    this.prefixTextStyle,
    this.ampIdTextStyle,
    this.width = 360,
    this.height = 36,
    this.onTap,
    this.copyIconWidth = 20,
    this.copyIconHeight = 20,
  });

  final double? width;
  final double? height;
  final String ampId;
  final Color backgroundColor;
  final Widget? icon;
  final BoxBorder? border;
  final TextStyle? prefixTextStyle;
  final TextStyle? ampIdTextStyle;
  final VoidCallback? onTap;
  final double copyIconWidth;
  final double copyIconHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: border,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          MouseRegion(
            cursor:
                onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                'AMP ID:',
                style: prefixTextStyle ??
                    Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: SideSwapColors.brightTurquoise,
                        ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          MouseRegion(
            cursor:
                onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                ampId,
                style: ampIdTextStyle ??
                    Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
              ),
            ),
          ),
          const Spacer(),
          ...switch (icon) {
            final icon? => [icon],
            _ => [
                const Spacer(),
                SizedBox(
                  width: 32,
                  height: 32,
                  child: FlavorConfig.isDesktop
                      ? Consumer(builder: (context, ref, _) {
                          final buttonStyle = ref
                              .watch(desktopAppThemeNotifierProvider)
                              .mainBottomNavigationBarButtonStyle;

                          return DButton(
                            style: buttonStyle,
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/copy2.svg',
                                width: copyIconWidth,
                                height: copyIconHeight,
                              ),
                            ),
                            onPressed: () async {
                              await copyToClipboard(
                                context,
                                ampId,
                              );
                            },
                          );
                        })
                      : IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            await copyToClipboard(
                              context,
                              ampId,
                            );
                          },
                          icon: SvgPicture.asset(
                            'assets/copy2.svg',
                            width: copyIconWidth,
                            height: copyIconHeight,
                          ),
                        ),
                ),
                const SizedBox(width: 6),
              ]
          },
        ],
      ),
    );
  }
}
