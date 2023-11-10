import 'package:flutter/material.dart';

class AssetHeaderitem extends StatelessWidget {
  const AssetHeaderitem({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        color: Color(0xFF87C1E1),
      ),
    );
  }
}
