import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DWorkingOrderAmount extends HookConsumerWidget {
  const DWorkingOrderAmount({
    super.key,
    required this.text,
    required this.icon,
  });

  final String text;
  final Widget icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(children: [icon, const SizedBox(width: 4), Text(text)]);
  }
}
