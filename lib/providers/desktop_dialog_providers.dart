import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/desktop/main/d_asset_info.dart';
import 'package:sideswap/desktop/main/d_export_tx_success.dart';
import 'package:sideswap/desktop/main/d_generate_address_popup.dart';
import 'package:sideswap/desktop/main/d_open_tx_import.dart';
import 'package:sideswap/desktop/main/d_recv_popup.dart';
import 'package:sideswap/desktop/main/d_select_inputs_popup.dart';
import 'package:sideswap/desktop/main/d_send_popup.dart';
import 'package:sideswap/desktop/main/d_tx_popup.dart';
import 'package:sideswap/desktop/main/d_view_tx_popup.dart';
import 'package:sideswap/desktop/main/d_wait_pegin.dart';
import 'package:sideswap/desktop/markets/widgets/d_accept_quote_error_dialog.dart';
import 'package:sideswap/desktop/settings/d_need_restart_dialog.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'desktop_dialog_providers.g.dart';

@riverpod
DesktopDialog desktopDialog(Ref ref) {
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

  void showSelectInputs() {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DSelectInputsPopup();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
      // Non-root navigator used so Jade status popup is visible
      useRootNavigator: false,
    );
  }

  Future<void> showTx(TransItem transItem, {required bool isPeg}) async {
    closePopups();
    await showDialog<void>(
      context: _context,
      builder: (context) {
        return isPeg
            ? DPegPopup(transItem: transItem)
            : DTxPopup(transItem: transItem);
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  Future<void> showAcceptQuoteErrorDialog() async {
    await showDialog<void>(
      context: _context,
      builder: (context) {
        return DAcceptQuoteErrorDialog();
      },
      routeSettings: RouteSettings(name: quoteErrorRouteName),
      useRootNavigator: false,
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

  void openTxImport() {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return const DOpenTxImport();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  Future<DialogReturnValue> openViewTx() async {
    final result = await showDialog<DialogReturnValue>(
      context: _context,
      builder: (context) {
        return const DViewTxPopup();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );

    return switch (result) {
      final result? => result,
      _ => const DialogReturnValueCancelled(),
    };
  }

  Future<void> openExportTxSuccess() async {
    await showDialog<void>(
      context: _context,
      builder: (context) {
        return const DExportTxSuccess();
      },
      routeSettings: const RouteSettings(name: _popupRouteName),
    );
  }

  void openAccount(AccountAsset accountAsset) {
    showDialog<void>(
      context: _context,
      builder: (context) {
        return DAssetInfo(accountAsset: accountAsset);
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
