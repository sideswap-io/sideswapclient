import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/screens/background/background_painter.dart';

const double kPageDefaultVerticalPadding = 24.0;

class SideSwapScaffoldPage extends StatefulWidget {
  const SideSwapScaffoldPage({
    super.key,
    this.content = const SizedBox.expand(),
    this.header,
    this.bottomBar,
    this.padding = EdgeInsets.zero,
    this.onEscapeKey,
    this.onEnterKey,
  });

  final Widget content;
  final Widget? header;
  final Widget? bottomBar;
  final EdgeInsets? padding;
  final VoidCallback? onEscapeKey;
  final VoidCallback? onEnterKey;

  SideSwapScaffoldPage.scrollable({
    super.key,
    this.header,
    this.bottomBar,
    this.padding,
    ScrollController? scrollController,
    required List<Widget> children,
    this.onEscapeKey,
    this.onEnterKey,
  }) : content = Builder(builder: (context) {
          return ListView(
            controller: scrollController,
            padding: EdgeInsets.only(
              bottom: kPageDefaultVerticalPadding,
              left: SideSwapPageHeader.horizontalPadding(context),
              right: SideSwapPageHeader.horizontalPadding(context),
            ),
            children: children,
          );
        });

  SideSwapScaffoldPage.withPadding({
    super.key,
    this.header,
    this.bottomBar,
    this.padding,
    required Widget content,
    this.onEscapeKey,
    this.onEnterKey,
  }) : content = Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: kPageDefaultVerticalPadding,
              left: SideSwapPageHeader.horizontalPadding(context),
              right: SideSwapPageHeader.horizontalPadding(context),
            ),
            child: content,
          );
        });

  @override
  State<SideSwapScaffoldPage> createState() => SideSwapScaffoldPageState();
}

class SideSwapScaffoldPageState extends State<SideSwapScaffoldPage> {
  @override
  void initState() {
    super.initState();
    RawKeyboard.instance.addListener(_onRawKey);
  }

  @override
  void dispose() {
    RawKeyboard.instance.removeListener(_onRawKey);
    super.dispose();
  }

  void _onRawKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      final logicalKey = event.logicalKey;
      if (logicalKey == LogicalKeyboardKey.escape) {
        widget.onEscapeKey?.call();
      }

      if (logicalKey == LogicalKeyboardKey.enter) {
        widget.onEnterKey?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CustomPaint(
      painter: BackgroundPainter(),
      child: Column(
        children: [
          Expanded(
            child: Container(
              color: theme.scaffoldBackgroundColor,
              padding: EdgeInsets.only(
                top: widget.padding?.top ?? kPageDefaultVerticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.header != null) widget.header!,
                  Expanded(child: widget.content),
                ],
              ),
            ),
          ),
          if (widget.bottomBar != null) ...[
            widget.bottomBar!,
          ],
        ],
      ),
    );
  }
}

class SideSwapPageHeader extends ConsumerWidget {
  const SideSwapPageHeader({
    super.key,
    this.leading,
    this.title,
    this.commandBar,
  });

  final Widget? leading;
  final Widget? title;
  final Widget? commandBar;

  static double horizontalPadding(BuildContext context) {
    assert(debugCheckHasMediaQuery(context));
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 640.0;
    final double horizontalPadding =
        isSmallScreen ? 12.0 : kPageDefaultVerticalPadding;
    return horizontalPadding;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle =
        ref.watch(desktopAppThemeNotifierProvider).typography.title;
    final leading = this.leading;
    final horizontalPadding = SideSwapPageHeader.horizontalPadding(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: 18.0,
        left: leading != null ? 0 : horizontalPadding,
        right: horizontalPadding,
      ),
      child: Row(children: [
        if (leading != null) leading,
        Expanded(
          child: DefaultTextStyle(
            style: titleStyle!,
            child: title ?? const SizedBox(),
          ),
        ),
        if (commandBar != null) commandBar!,
      ]),
    );
  }
}
