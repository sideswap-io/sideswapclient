import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';

import 'package:sideswap/screens/background/background_painter.dart';
import 'package:sideswap/screens/flavor_config.dart';

class SideSwapScaffold extends ConsumerStatefulWidget {
  const SideSwapScaffold({
    super.key,
    this.canPop,
    this.onPopInvokedWithResult,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.floatingActionButtonAnimator,
    this.persistentFooterButtons,
    this.drawer,
    this.endDrawer,
    this.drawerScrimColor,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.resizeToAvoidBottomInset,
    this.primary = true,
    this.drawerDragStartBehavior = DragStartBehavior.start,
    this.drawerEdgeDragWidth,
    this.drawerEnableOpenDragGesture = true,
    this.endDrawerEnableOpenDragGesture = true,
    this.sideSwapBackground = true,
  });

  final bool sideSwapBackground;
  final bool? canPop;
  final PopInvokedWithResultCallback<dynamic>? onPopInvokedWithResult;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? drawerScrimColor;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;

  @override
  SideSwapScaffoldState createState() => SideSwapScaffoldState();
}

class SideSwapScaffoldState extends ConsumerState<SideSwapScaffold> {
  @override
  Widget build(BuildContext context) {
    if (FlavorConfig.isDesktop) {
      return DPopupWithClose(
        width: 580,
        height: 605,
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: widget.body!,
        ),
      );
    }

    final statusBarTopPadding = MediaQuery.of(context).padding.top;
    final body =
        widget.sideSwapBackground
            ? CustomPaint(
              painter: BackgroundPainter(topPadding: statusBarTopPadding),
              child: widget.body,
            )
            : widget.body;

    final scaffold = Scaffold(
      extendBody: widget.extendBody,
      extendBodyBehindAppBar:
          widget.sideSwapBackground ? true : widget.extendBodyBehindAppBar,
      appBar: widget.appBar,
      body: body,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButtonAnimator: widget.floatingActionButtonAnimator,
      persistentFooterButtons: widget.persistentFooterButtons,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      drawerScrimColor: widget.drawerScrimColor,
      backgroundColor: widget.backgroundColor,
      bottomNavigationBar: widget.bottomNavigationBar,
      bottomSheet: widget.bottomSheet,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      primary: widget.primary,
      drawerDragStartBehavior: widget.drawerDragStartBehavior,
      drawerEdgeDragWidth: widget.drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: widget.endDrawerEnableOpenDragGesture,
    );

    return PopScope(
      canPop: widget.canPop ?? false,
      onPopInvokedWithResult: widget.onPopInvokedWithResult,
      child: scaffold,
    );
  }
}
