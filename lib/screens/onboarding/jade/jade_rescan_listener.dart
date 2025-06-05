import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/jade_provider.dart';

class JadeRescanListener extends ConsumerWidget {
  const JadeRescanListener({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(jadeRescanProvider, (_, _) {});
    return Container();
  }
}
