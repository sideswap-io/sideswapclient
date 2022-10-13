import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/main/d_asset_info.dart';
import 'package:sideswap/desktop/main/d_jade_import.dart';
import 'package:sideswap/desktop/main/d_open_url.dart';
import 'package:sideswap/desktop/main/d_order_review.dart';
import 'package:sideswap/desktop/main/d_recv_popup.dart';
import 'package:sideswap/desktop/main/d_send_popup.dart';
import 'package:sideswap/desktop/main/d_tx_popup.dart';
import 'package:sideswap/desktop/main/d_wait_pegin.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/payment_provider.dart';
import 'package:sideswap/models/wallet.dart';

const _popupRouteName = '/desktopPopup';

void desktopShowRecvAddress(BuildContext context, WidgetRef ref) {
  ref.read(walletProvider).startAssetReceiveAddr();
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DReceivePopup();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopShowSendTx(BuildContext context, WidgetRef ref) {
  ref.read(paymentProvider).createdTx = null;
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DSendPopup();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopShowTx(BuildContext context, String id, {required bool isPeg}) {
  desktopClosePopups(context);
  showDialog<void>(
    context: context,
    builder: (context) {
      return isPeg ? DPegPopup(id: id) : DTxPopup(id: id);
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopWaitPegin(BuildContext context) {
  desktopClosePopups(context);
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DWaitPegin();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopOrderReview(BuildContext context, ReviewScreen screen) {
  desktopClosePopups(context);
  showDialog<void>(
    context: context,
    builder: (context) {
      return DOrderReview(
        screen: screen,
      );
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopOpenUrl(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DOpenUrl();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopOpenAccount(BuildContext context, AccountAsset account) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return DAssetInfo(account: account);
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopImportJade(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DJadeImport();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopClosePopups(BuildContext context) {
  Navigator.of(context, rootNavigator: true).popUntil((route) {
    return route.settings.name != _popupRouteName;
  });
}

StreamSubscription? openExplorerSubscription;

Future<void> openTxidUrl(
    WidgetRef ref, String txid, bool isLiquid, bool unblinded) async {
  await openExplorerSubscription?.cancel();
  openExplorerSubscription =
      ref.read(walletProvider).explorerUrlSubject.listen((value) async {
    await openExplorerSubscription?.cancel();
    await openUrl(value);
  });

  ref.read(walletProvider).openTxUrl(txid, isLiquid, unblinded);
}
