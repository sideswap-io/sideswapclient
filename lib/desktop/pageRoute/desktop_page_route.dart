import 'package:flutter/material.dart';

class DesktopPageRoute<T> extends PageRoute<T> {
  late final WidgetBuilder _builder;
  final bool _maintainState;
  final String? _barrierLabel;

  DesktopPageRoute({
    this._maintainState = true,
    this._barrierLabel,
    required this._builder,
    super.settings,
    super.fullscreenDialog,
  });

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => _barrierLabel;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = Material(child: _builder(context));
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(animation),
          child: result,
        ),
      ),
    );
  }

  @override
  bool get maintainState => _maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
