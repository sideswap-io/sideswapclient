import 'package:flutter/material.dart';

class DTxHistoryRow extends StatelessWidget {
  const DTxHistoryRow({
    super.key,
    required this.list,
  });

  final List<Widget> list;

  @override
  Widget build(BuildContext context) {
    const flexes = [183, 97, 137, 210, 210, 122, 46];
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(
          flex: flexes[index],
          child: list[index],
        ),
      ),
    );
  }
}
