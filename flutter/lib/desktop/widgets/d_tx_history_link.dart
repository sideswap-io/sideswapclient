import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';

class DTxHistoryLink extends ConsumerWidget {
  const DTxHistoryLink({
    super.key,
    required this.txid,
  });

  final String txid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => openTxidUrl(ref, txid, true, true),
        icon: SvgPicture.asset(
          'assets/link2.svg',
          width: 14,
          height: 14,
        ),
      ),
    );
  }
}
