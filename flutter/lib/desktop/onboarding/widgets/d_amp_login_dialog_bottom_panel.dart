import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/screens/onboarding/widgets/amp_bottom_panel_body.dart';

class DAmpLoginDialogBottomPanel extends HookConsumerWidget {
  final Widget? prefix;
  final String url;
  final String urlText;

  const DAmpLoginDialogBottomPanel({
    super.key,
    this.prefix,
    required this.url,
    required this.urlText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme =
        ref.watch(desktopAppThemeProvider.select((value) => value.textTheme));

    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: SideSwapColors.tarawera,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
        boxShadow: kElevationToShadow[6],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: AmpBottomPanelBody(
          prefix: prefix,
          url: url,
          urlText: urlText,
          textStyle: textTheme.titleSmall?.merge(
            const TextStyle(
              decoration: TextDecoration.underline,
              color: SideSwapColors.zumthor,
            ),
          ),
        ),
      ),
    );
  }
}
