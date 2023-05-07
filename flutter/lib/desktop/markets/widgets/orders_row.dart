import 'package:flutter/material.dart';

class OrdersRow extends StatelessWidget {
  const OrdersRow({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    const flexes = [153, 210, 210, 210, 97, 143, 107, 184];
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(
          flex: flexes[index],
          child: children[index],
        ),
      ),
    );
  }
}
