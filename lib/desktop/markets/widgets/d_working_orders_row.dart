import 'package:flutter/material.dart';

class DWorkingOrdersRow extends StatelessWidget {
  const DWorkingOrdersRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const flexes = [115, 180, 150, 180, 60, 105, 80, 110];
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(flex: flexes[index], child: children[index]),
      ),
    );
  }
}
