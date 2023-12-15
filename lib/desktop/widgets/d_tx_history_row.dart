import 'package:flutter/material.dart';

class DTxHistoryRow extends StatelessWidget {
  const DTxHistoryRow({
    super.key,
    required this.children,
    this.flexes = const [183, 97, 137, 210, 210, 122, 46],
  });

  final List<Widget> children;
  final List<int> flexes;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(
          flex: flexes[index],
          child: children.length > index ? children[index] : Container(),
        ),
      ),
    );
  }
}
