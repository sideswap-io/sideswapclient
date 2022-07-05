import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/common/d_color.dart';
import 'package:sideswap/desktop/theme.dart';

class DUrlLinkButton extends ConsumerWidget {
  const DUrlLinkButton({
    super.key,
    this.url = '',
    required this.text,
    this.icon,
    this.onPressed,
  });

  final String url;
  final String text;
  final String? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsButtonStyle = DButtonStyle(
      backgroundColor: ButtonState.resolveWith((states) {
        const background = Color(0xFF135579);
        if (states.isPressing) {
          return background.lerpWith(Colors.black, 0.2);
        }
        if (states.isHovering) {
          return background.lerpWith(Colors.black, 0.1);
        }
        return background;
      }),
      border: ButtonState.all(BorderSide.none),
    );

    final buttonStyle = ref
        .watch(desktopAppThemeProvider)
        .buttonThemeData
        .filledButtonStyle
        ?.merge(settingsButtonStyle);

    return FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      child: DCustomFilledBigButton(
        width: double.infinity,
        height: 44,
        style: buttonStyle,
        onPressed: () async {
          if (url.isNotEmpty) {
            await openUrl(url);
            return;
          }
          if (onPressed != null) {
            onPressed!();
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 17, right: 17),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: icon == null
                    ? const Icon(Icons.copyright, size: 24)
                    : SvgPicture.asset(
                        icon!,
                        width: 24,
                        height: 24,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  text,
                  style: GoogleFonts.roboto(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: const Color(0xFF00C5FF),
                    textStyle: TextStyle(
                      decoration: url.isNotEmpty
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
