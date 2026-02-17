import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryConfs extends ConsumerWidget {
  const DTxHistoryConfs({super.key, required this.transItem, this.textStyle});

  final TransItem transItem;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transItemHelper = ref.watch(transItemHelperProvider(transItem));

    final txStatus = transItemHelper.txStatus();

    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        txStatus.status,
        style: textStyle?.merge(
          TextStyle(
            color: txStatus.confirmed
                ? const Color(0xFF87C0E0)
                : const Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
