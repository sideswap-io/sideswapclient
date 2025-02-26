import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/providers/wallet.dart';

StreamSubscription<String>? openExplorerSubscription;

Future<void> openTxidUrl(
  WidgetRef ref,
  String txid,
  bool isLiquid,
  bool unblinded,
) async {
  await openExplorerSubscription?.cancel();
  openExplorerSubscription = ref.read(walletProvider).explorerUrlSubject.listen(
    (value) async {
      await openExplorerSubscription?.cancel();
      await openUrl(value);
    },
  );

  ref.read(walletProvider).openTxUrl(txid, isLiquid, unblinded);
}
