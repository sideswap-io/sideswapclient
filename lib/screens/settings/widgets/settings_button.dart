import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

enum SettingsButtonType {
  recovery,
  shield,
  about,
  delete,
  userDetails,
  network,
  language,
  logs,
  export,
  currency,
}

class SettingsButton extends HookConsumerWidget {
  const SettingsButton({
    super.key,
    this.transparent = false,
    this.type = SettingsButtonType.recovery,
    required this.text,
    this.onPressed,
  });

  final bool transparent;
  final SettingsButtonType type;
  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = useMemoized(() {
      return switch (type) {
        SettingsButtonType.recovery => SvgPicture.asset(
          'assets/recovery.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.shield => SvgPicture.asset(
          'assets/shield.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.about => SvgPicture.asset(
          'assets/about.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.delete => SvgPicture.asset(
          'assets/delete.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.userDetails => SvgPicture.asset(
          'assets/user_details.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.network => SvgPicture.asset(
          'assets/network.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.language => SvgPicture.asset(
          'assets/language.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.logs => SvgPicture.asset(
          'assets/logs.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.export => SvgPicture.asset(
          'assets/settings_export.svg',
          width: 24,
          height: 24,
        ),
        SettingsButtonType.currency => SvgPicture.asset(
          'assets/currency.svg',
          width: 24,
          height: 24,
        ),
      };
    }, [type]);

    return SizedBox(
      height: 60,
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              transparent ? Colors.transparent : SideSwapColors.chathamsBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          side: const BorderSide(
            color: SideSwapColors.chathamsBlue,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(left: 16), child: icon),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
