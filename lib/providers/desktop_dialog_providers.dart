import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/desktop/main/d_asset_info.dart';
import 'package:sideswap/desktop/main/d_generate_address_popup.dart';
import 'package:sideswap/desktop/main/d_open_url.dart';
import 'package:sideswap/desktop/main/d_order_review.dart';
import 'package:sideswap/desktop/main/d_recv_popup.dart';
import 'package:sideswap/desktop/main/d_send_popup.dart';
import 'package:sideswap/desktop/main/d_tx_popup.dart';
import 'package:sideswap/desktop/main/d_wait_pegin.dart';
import 'package:sideswap/desktop/settings/d_need_restart_dialog.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';

part 'desktop_dialog_providers.g.dart';

@riverpod
DesktopDialog desktopDialog(DesktopDialogRef ref) {
  final context = ref.read(navigatorKeyProvider).currentContext!;
  return DesktopDialog(context: context);
}

class DesktopDialog {
  final BuildContext _context;

  DesktopDialog({required BuildContext context}) : _context = context;

  static const _popupRouteName = '/desktopPopup';

  void showRecvAddress() {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DReceivePopup();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void showNeedRestartDialog() {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DNeedRestartPopupDialog();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void showGenerateAddress() {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DGenerateAddressPopup();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void showSendTx() {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DSendPopup();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
      // Non-root navigator used so Jade status popup is visible
      useRootNavigator: false,
    );
  }

  void showTx(String id, {required bool isPeg}) {
    closePopups();
    showDialog<void>(
      context: _context,
      builder: (context) {
        return isPeg ? DPegPopup(id: id) : DTxPopup(id: id);
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void waitPegin() {
    closePopups();
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DWaitPegin();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void orderReview(ReviewScreen screen) {
    closePopups();
    showDialog<void>(
      context: _context,
      builder: (context) {
        return DOrderReview(
          screen: screen,
        );
      },
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void openUrl() {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DOpenUrl();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void openAccount(AccountAsset account) {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return DAssetInfo(account: account);
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void closePopups({String? popupRouteName}) {
    Navigator.of(_context, rootNavigator: true).popUntil((route) {
      return route.settings.name != (popupRouteName ?? _popupRouteName);
    });
    Navigator.of(_context, rootNavigator: false).popUntil((route) {
      return route.settings.name != (popupRouteName ?? _popupRouteName);
    });
  }
}
