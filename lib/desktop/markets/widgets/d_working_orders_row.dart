import 'package:flutter/material.dart';

class DWorkingOrdersRow extends StatelessWidget {
  const DWorkingOrdersRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const flexes = [115, 190, 150, 200, 60, 70, 70, 125];
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(flex: flexes[index], child: children[index]),
      ),
    );
  }
}
