import 'package:flutter/material.dart';

class DTxHistoryHeader extends StatelessWidget {
  const DTxHistoryHeader({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF87C1E1),
        fontSize: 12,
      ),
    );
  }
}
