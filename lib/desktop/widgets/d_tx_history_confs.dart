import 'package:flutter/material.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class DTxHistoryConfs extends StatelessWidget {
  const DTxHistoryConfs({
    super.key,
    required this.tx,
  });

  final TransItem tx;

  @override
  Widget build(BuildContext context) {
    final count = tx.hasConfs() ? tx.confs.count : 2;
    final total = tx.hasConfs() ? tx.confs.total : 2;
    final confirmed = count == total;
    return Align(
      alignment: Alignment.centerLeft,
      child: Text('$count/$total',
          style: TextStyle(
            color:
                confirmed ? const Color(0xFF87C0E0) : const Color(0xFFFFFFFF),
          )),
    );
  }
}
