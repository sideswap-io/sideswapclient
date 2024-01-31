import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';

class DStokrLoginDialog extends HookConsumerWidget {
  final Widget? content;
  final VoidCallback? onClose;

  const DStokrLoginDialog({
    super.key,
    this.content,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).settingsDialogTheme;

    return DContentDialog(
      title: Padding(
        padding: const EdgeInsets.all(20),
        child: DContentDialogTitle(
          content: SvgPicture.asset(
            'assets/stokr_logo.svg',
            width: 104,
            height: 24,
          ),
          onClose: onClose,
        ),
      ),
      style: const DContentDialogThemeData().merge(
        settingsDialogTheme.merge(
          const DContentDialogThemeData(
            titlePadding: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      constraints: const BoxConstraints(maxWidth: 628),
      content: content,
    );
  }
}
