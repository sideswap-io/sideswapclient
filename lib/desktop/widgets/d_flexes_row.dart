import 'package:flutter/material.dart';

class DFlexesRow extends StatelessWidget {
  const DFlexesRow({
    super.key,
    required this.children,
    this.flexes = const [183, 117, 210, 210, 102, 46],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final List<int> flexes;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    // final flexSum = flexes.fold<int>(0, (p, c) => p + c);
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: List.generate(flexes.length, (index) {
        // final flex = flexes[index];
        // final maxFlexWidth =
        //     (flex / flexSum * MediaQuery.of(context).size.width).toInt();
        // final child = children.length > index
        //     ? SizedBox(width: maxFlexWidth.toDouble(), child: children[index])
        //     : Container();

        final flex = flexes[index];
        final child = children.length > index ? children[index] : Container();
        return Expanded(
          flex: flex,
          child: Row(children: [Flexible(child: child)]),
        );
      }),
    );
  }
}
