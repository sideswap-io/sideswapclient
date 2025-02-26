import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/desktop/desktop_helpers.dart';

class DTxBlindedUrlIconButton extends ConsumerWidget {
  const DTxBlindedUrlIconButton({
    super.key,
    required this.txid,
    this.isLiquid = true,
    this.unblinded = true,
  });

  final String txid;
  final bool isLiquid;
  final bool unblinded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
        onPressed: () => openTxidUrl(ref, txid, isLiquid, unblinded),
        icon: SvgPicture.asset('assets/link2.svg', width: 14, height: 14),
      ),
    );
  }
}
