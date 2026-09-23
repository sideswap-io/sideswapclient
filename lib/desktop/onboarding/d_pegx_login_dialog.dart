import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';

class DPegxLoginDialog extends HookConsumerWidget {
  final Widget? content;
  final VoidCallback? onClose;

  const DPegxLoginDialog({super.key, this.content, this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultDialogTheme = ref
        .watch(desktopAppThemeProvider)
        .defaultDialogTheme;

    return DContentDialog(
      title: Padding(
        padding: const EdgeInsets.all(20),
        child: DContentDialogTitle(
          content: SvgPicture.asset(
            'assets/pegx_logo.svg',
            width: 104,
            height: 24,
          ),
          onClose: onClose,
        ),
      ),
      style: const DContentDialogThemeData().merge(
        defaultDialogTheme.merge(
          const DContentDialogThemeData(
            titlePadding: EdgeInsets.zero,
            bodyPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      // 484 is this dialog's measured natural height: the 44 px
      // `DContentDialogTitle` inside `EdgeInsets.all(20)` over the 400 px body
      // every call site passes. Below the 620 px floor already, so the bound
      // changes nothing today -- it is what makes a taller body scroll instead
      // of overflowing in silence. See ADR-0014 decision 8.
      constraints: const BoxConstraints(maxWidth: 628, maxHeight: 484),
      scrollOwner: ScrollOwner.wrapper,
      content: content,
    );
  }
}
