import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
  final VoidCallback? onClose;
  final VoidCallback? onEscapeKey;
  final VoidCallback? onEnterKey;
  final bool hideClose;

  const SideSwapPopupPage({
    Key? key,
    this.title,
    this.content,
    this.actions,
    this.style,
    this.constraints = const BoxConstraints(maxWidth: 368),
    this.backgroundContent,
    this.onClose,
    this.hideClose = false,
    this.onEscapeKey,
    this.onEnterKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffoldPage(
      onEnterKey: onEnterKey,
      onEscapeKey: onEscapeKey,
      content: Stack(
        children: [
          backgroundContent ??
              Container(
                color: Colors.black.withOpacity(0.5),
              ),
          DContentDialog(
            title: DContentDialogTitle(
              content: title,
              hideClose: hideClose,
              onClose: onClose,
            ),
            content: content,
            actions: actions,
            style: style ??
                const DContentDialogThemeData().merge(
                  DContentDialogThemeData(
                    padding: EdgeInsets.zero,
                    titlePadding: EdgeInsets.only(
                        top: 24,
                        bottom: title == null ? 0 : 20,
                        left: 24,
                        right: 24),
                    bodyPadding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Color(0xFF1C6086)),
                  ),
                ),
            constraints: constraints,
          ),
        ],
      ),
    );
  }
}
