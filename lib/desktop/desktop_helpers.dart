import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/desktop/main/d_asset_info.dart';
import 'package:sideswap/desktop/main/d_generate_address_popup.dart';
import 'package:sideswap/desktop/main/d_open_url.dart';
import 'package:sideswap/desktop/main/d_order_review.dart';
import 'package:sideswap/desktop/main/d_recv_popup.dart';
import 'package:sideswap/desktop/main/d_send_popup.dart';
import 'package:sideswap/desktop/main/d_tx_popup.dart';
import 'package:sideswap/desktop/main/d_wait_pegin.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/wallet.dart';

const _popupRouteName = '/desktopPopup';

void desktopShowRecvAddress(BuildContext context, WidgetRef ref) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DReceivePopup();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopShowGenerateAddress(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DGenerateAddressPopup();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
  );
}

void desktopShowSendTx(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return const DSendPopup();
    },
    routeSettings: const RouteSettings(name: _popupRouteName),
    // Non-root navigator used so Jade status popup is visible
    useRootNavigator: false,
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
    useRootNavigator: true,
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

void desktopClosePopups(BuildContext context, {String? popupRouteName}) {
  Navigator.of(context, rootNavigator: true).popUntil((route) {
    return route.settings.name != (popupRouteName ?? _popupRouteName);
  });
  Navigator.of(context, rootNavigator: false).popUntil((route) {
    return route.settings.name != (popupRouteName ?? _popupRouteName);
  });
}

StreamSubscription<String>? openExplorerSubscription;

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
