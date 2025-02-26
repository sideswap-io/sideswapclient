import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/widgets/sideswap_scaffold_page.dart';

class SideSwapPopupPage extends ConsumerWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final DContentDialogThemeData? style;
  final BoxConstraints constraints;
  final Widget? backgroundContent;
  final Widget? foregroundContent;
  final VoidCallback? onClose;
  final VoidCallback? onEscapeKey;
  final VoidCallback? onEnterKey;
  final bool hideClose;
  final bool hideBack;
  final VoidCallback? onBack;

  const SideSwapPopupPage({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.style,
    this.constraints = const BoxConstraints(maxWidth: 368),
    this.backgroundContent,
    this.foregroundContent,
    this.onClose,
    this.hideClose = false,
    this.onEscapeKey,
    this.onEnterKey,
    this.hideBack = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffoldPage(
      onEnterKey: onEnterKey,
      onEscapeKey: onEscapeKey,
      content: Stack(
        children: [
          backgroundContent ??
              Container(color: Colors.black.withValues(alpha: 0.5)),
          DContentDialog(
            title: DContentDialogTitle(
              content: title,
              hideClose: hideClose,
              onClose: onClose,
              hideBack: hideBack,
              onBack: onBack,
            ),
            content: content,
            actions: actions,
            style:
                style ??
                const DContentDialogThemeData().merge(
                  DContentDialogThemeData(
                    padding: EdgeInsets.zero,
                    titlePadding: EdgeInsets.only(
                      top: 24,
                      bottom: title == null ? 0 : 20,
                      left: 24,
                      right: 24,
                    ),
                    bodyPadding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: SideSwapColors.blumine,
                    ),
                  ),
                ),
            constraints: constraints,
          ),
          if (foregroundContent != null) ...[foregroundContent!],
        ],
      ),
    );
  }
}
