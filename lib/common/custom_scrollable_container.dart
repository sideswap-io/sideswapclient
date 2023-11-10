import 'package:flutter/material.dart';

// TODO (malcolmpl): this widget shouldn't exist at all. App does not support devices with a resolution smaller than the size described in start_app.dart!
class CustomScrollableContainer extends StatelessWidget {
  const CustomScrollableContainer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: child,
        ),
      ],
    );
  }
}
