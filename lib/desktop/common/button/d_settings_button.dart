import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/theme.dart';

enum DSettingsButtonIcon {
  recovery,
  about,
  password,
  network,
  faq,
  language,
  delete,
  apiServer,
  logs,
  export,
  currency,
}

class DSettingsButton extends ConsumerWidget {
  const DSettingsButton({
    super.key,
    this.onPressed,
    this.title = '',
    this.forward = true,
    this.icon = DSettingsButtonIcon.recovery,
    this.child,
  });

  final VoidCallback? onPressed;
  final String title;
  final bool forward;
  final DSettingsButtonIcon icon;
  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconValue = switch (icon) {
      DSettingsButtonIcon.recovery => 'assets/recovery.svg',
      DSettingsButtonIcon.about => 'assets/about.svg',
      DSettingsButtonIcon.password => 'assets/locker3.svg',
      DSettingsButtonIcon.network => 'assets/network.svg',
      DSettingsButtonIcon.faq => 'assets/faq.svg',
      DSettingsButtonIcon.delete => 'assets/delete.svg',
      DSettingsButtonIcon.language => 'assets/language.svg',
      DSettingsButtonIcon.apiServer => 'assets/recovery.svg',
      DSettingsButtonIcon.logs => 'assets/logs.svg',
      DSettingsButtonIcon.export => 'assets/settings_export.svg',
      DSettingsButtonIcon.currency => 'assets/currency.svg',
    };

    final settingsButtonStyle = DButtonStyle(
      backgroundColor: ButtonState.resolveWith((states) {
        final background =
            forward ? SideSwapColors.chathamsBlue : SideSwapColors.blumine;
        if (states.isPressing) {
          return background.lerpWith(Colors.black, 0.2);
        }
        if (states.isHovering) {
          return background.lerpWith(Colors.black, 0.1);
        }
        return background;
      }),
      border: ButtonState.resolveWith((states) {
        if (forward) {
          return BorderSide.none;
        }

        return const BorderSide(color: Color(0xFF327FA9));
      }),
    );

    final buttonStyle =
        forward
            ? ref
                .watch(desktopAppThemeNotifierProvider)
                .buttonThemeData
                .filledButtonStyle
                ?.merge(settingsButtonStyle)
            : ref
                .watch(desktopAppThemeNotifierProvider)
                .buttonThemeData
                .defaultButtonStyle
                ?.merge(settingsButtonStyle);

    return DCustomFilledBigButton(
      width: 344,
      height: 44,
      style: buttonStyle,
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: SvgPicture.asset(iconValue, width: 24, height: 24)),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
            const Spacer(),
            if (forward) ...[
              const Icon(Icons.chevron_right, size: 20, color: Colors.white),
            ],
            if (!forward && child != null) ...[child!],
          ],
        ),
      ),
    );
  }
}
