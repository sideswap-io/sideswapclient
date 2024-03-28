import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/theme.dart';

class DContentDialog extends ConsumerWidget {
  const DContentDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.style,
    this.constraints = const BoxConstraints(maxWidth: 368),
  });

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final DContentDialogThemeData? style;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogTheme = ref.watch(desktopAppThemeNotifierProvider).dialogTheme;
    final style = DContentDialogThemeData.standard().merge(
      dialogTheme.merge(this.style),
    );
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: constraints,
        decoration: style.decoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: style.padding ?? EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Padding(
                      padding: style.titlePadding ?? EdgeInsets.zero,
                      child: DefaultTextStyle(
                        style: style.titleStyle ?? const TextStyle(),
                        child: title!,
                      ),
                    ),
                  if (content != null)
                    Padding(
                      padding: style.bodyPadding ?? EdgeInsets.zero,
                      child: DefaultTextStyle(
                        style: style.bodyStyle ?? const TextStyle(),
                        child: content!,
                      ),
                    ),
                ],
              ),
            ),
            if (actions != null)
              Container(
                decoration: style.actionsDecoration,
                padding: style.actionsPadding,
                child: DButtonTheme.merge(
                  data: style.actionThemeData ?? const DButtonThemeData(),
                  child: () {
                    if (actions!.length == 1) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: actions!.first,
                      );
                    }
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!.map((e) {
                        final index = actions!.indexOf(e);
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(
                              end: index != (actions!.length - 1)
                                  ? style.actionsSpacing ?? 3
                                  : 0,
                            ),
                            child: e,
                          ),
                        );
                      }).toList(),
                    );
                  }(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class DContentDialogTitle extends StatelessWidget {
  const DContentDialogTitle({
    super.key,
    this.content,
    this.hideClose = false,
    required this.onClose,
    this.height,
    this.hideBack = true,
    this.onBack,
  });

  final Widget? content;
  final bool hideClose;
  final VoidCallback? onClose;
  final double? height;
  final bool hideBack;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final titleHeight = height == null
        ? content == null
            ? 36.0
            : 44.0
        : height! < 28
            ? 28.0
            : height!;
    return SizedBox(
        height: titleHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: hideBack
                  ? const SizedBox()
                  : DIconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: SideSwapColors.freshAir,
                        size: 18,
                      ),
                      onPressed: onBack,
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: hideClose
                  ? const SizedBox()
                  : DIconButton(
                      icon: const Icon(
                        Icons.close,
                        color: SideSwapColors.freshAir,
                        size: 18,
                      ),
                      onPressed: onClose,
                    ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: content ?? const SizedBox(),
            ),
          ],
        ));
  }
}
