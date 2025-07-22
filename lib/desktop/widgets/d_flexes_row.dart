import 'package:flutter/material.dart';

class DFlexesRow extends StatelessWidget {
  const DFlexesRow({
    super.key,
    required this.children,
    this.flexes = const [183, 97, 210, 210, 122, 46],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final List<Widget> children;
  final List<int> flexes;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: List.generate(
        flexes.length,
        (index) => Expanded(
          flex: flexes[index],
          child: Row(
            children: [children.length > index ? children[index] : Container()],
          ),
        ),
      ),
    );
  }
}
