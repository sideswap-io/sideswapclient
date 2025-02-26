import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DWorkingHistoryOrdersRow extends ConsumerWidget {
  const DWorkingHistoryOrdersRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const flexes = [184, 184, 184, 184, 184, 80];
    return Row(
      children: List.generate(
        flexes.length,
        (index) => Expanded(flex: flexes[index], child: children[index]),
      ),
    );
  }
}
