import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/providers/app_releases_provider.dart';

class DownloadNewReleaseButton extends ConsumerWidget {
  const DownloadNewReleaseButton({
    super.key,
    required this.yes,
  });

  final bool yes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DHoverButton(
      builder: (context, states) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 13),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            border: Border.all(
              color: SideSwapColors.brightTurquoise,
            ),
            color: states.isFocused ? const Color(0xFF007CA1) : null,
          ),
          child: Text(
            yes ? 'Yes'.tr() : 'No'.tr(),
            style: const TextStyle(
              color: SideSwapColors.brightTurquoise,
              fontSize: 12,
            ),
          ),
        );
      },
      onPressed: () {
        ref.read(appReleasesProvider).ackNewDesktopRelease();
        if (yes) {
          openUrl('https://sideswap.io/downloads/');
        }
      },
    );
  }
}
