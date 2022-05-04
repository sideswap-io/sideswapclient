import 'package:flutter/material.dart';

class DesktopPageRoute<T> extends PageRoute<T> {
  late final WidgetBuilder _builder;
  // ignore: prefer_final_fields
  bool _maintainState = true;
  final String? _barrierLabel;

  DesktopPageRoute({
    bool maintainState = true,
    String? barrierLabel,
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _barrierLabel = barrierLabel,
        _maintainState = maintainState,
        _builder = builder,
        super(fullscreenDialog: fullscreenDialog, settings: settings);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => _barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final Widget result = Material(child: _builder(context));
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.linear,
        ),
        child: ScaleTransition(
          child: result,
          scale: Tween<double>(begin: 0.88, end: 1.0).animate(animation),
        ),
      ),
    );
  }

  @override
  bool get maintainState => _maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}
