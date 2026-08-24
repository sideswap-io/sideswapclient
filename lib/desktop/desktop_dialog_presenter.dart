import 'package:flutter/material.dart';
import 'package:sideswap/desktop/home/widgets/d_export_csv_popup.dart';
import 'package:sideswap/desktop/main/d_asset_info.dart';
import 'package:sideswap/desktop/main/d_export_tx_success.dart';
import 'package:sideswap/desktop/main/d_generate_address_popup.dart';
import 'package:sideswap/desktop/main/d_open_tx_import.dart';
import 'package:sideswap/desktop/main/d_recv_address_dialog.dart';
import 'package:sideswap/desktop/main/d_select_inputs_popup.dart';
import 'package:sideswap/desktop/main/d_send_popup.dart';
import 'package:sideswap/desktop/main/d_tx_popup.dart';
import 'package:sideswap/desktop/main/d_view_tx_popup.dart';
import 'package:sideswap/desktop/markets/widgets/d_accept_quote_error_dialog.dart';
import 'package:sideswap/desktop/settings/d_need_restart_dialog.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

abstract class DesktopDialogPresenter {
  void showRecvAddress(BuildContext context, {String? routeName});
  Future<void> showNeedRestartDialog(BuildContext context, {String? routeName});
  void showGenerateAddress(BuildContext context, {String? routeName});
  void showSendTx(BuildContext context, {String? routeName});
  Future<T?> showExportCsv<T>(BuildContext context, {String? routeName});
  void showSelectInputs(BuildContext context, {String? routeName});
  Future<void> showTxDialog(
    BuildContext context, {
    required bool isPeg,
    String? routeName,
  });
  Future<void> showAcceptQuoteErrorDialog(BuildContext context);
  void openTxImport(BuildContext context, {String? routeName});
  Future<DialogReturnValue?> openViewTx(
    BuildContext context, {
    String? routeName,
  });
  Future<void> openExportTxSuccess(BuildContext context, {String? routeName});
  void showAssetInfoDialog(
    BuildContext context,
    Asset asset, {
    String? routeName,
  });
  void closePopups(BuildContext context, {String? popupRouteName});
}

class FlutterDesktopDialogPresenter implements DesktopDialogPresenter {
  static const _popupRouteName = '/desktopPopup';

  @override
  void showRecvAddress(BuildContext context, {String? routeName}) {
    showDialog<void>(
      context: context,
      builder: (context) => const DReceiveAddressDialog(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  Future<void> showNeedRestartDialog(
    BuildContext context, {
    String? routeName,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const DNeedRestartPopupDialog(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  void showGenerateAddress(BuildContext context, {String? routeName}) {
    showDialog<void>(
      context: context,
      builder: (context) => const DGenerateAddressPopup(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  void showSendTx(BuildContext context, {String? routeName}) {
    showDialog<void>(
      context: context,
      builder: (context) => const DSendPopup(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
      useRootNavigator: false,
    );
  }

  @override
  Future<T?> showExportCsv<T>(BuildContext context, {String? routeName}) {
    return showDialog<T>(
      context: context,
      builder: (context) => const DExportCsvPopup(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
      useRootNavigator: false,
    );
  }

  @override
  void showSelectInputs(BuildContext context, {String? routeName}) {
    showDialog<void>(
      context: context,
      builder: (context) => const DSelectInputsPopup(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
      useRootNavigator: false,
    );
  }

  @override
  Future<void> showTxDialog(
    BuildContext context, {
    required bool isPeg,
    String? routeName,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => isPeg ? DPegPopup() : DTxPopup(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  Future<void> showAcceptQuoteErrorDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) => DAcceptQuoteErrorDialog(),
      routeSettings: RouteSettings(name: quoteErrorRouteName),
      useRootNavigator: false,
    );
  }

  @override
  void openTxImport(BuildContext context, {String? routeName}) {
    showDialog<void>(
      context: context,
      builder: (context) => const DOpenTxImport(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  Future<DialogReturnValue?> openViewTx(
    BuildContext context, {
    String? routeName,
  }) {
    return showDialog<DialogReturnValue>(
      context: context,
      builder: (context) => const DViewTxPopup(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  Future<void> openExportTxSuccess(
    BuildContext context, {
    String? routeName,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (context) => const DExportTxSuccess(),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  void showAssetInfoDialog(
    BuildContext context,
    Asset asset, {
    String? routeName,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => DAssetInfo(asset: asset),
      routeSettings: RouteSettings(name: routeName ?? _popupRouteName),
    );
  }

  @override
  void closePopups(BuildContext context, {String? popupRouteName}) {
    final routeName = popupRouteName ?? _popupRouteName;
    Navigator.of(context, rootNavigator: true).popUntil((route) {
      return route.settings.name != routeName;
    });
    Navigator.of(context, rootNavigator: false).popUntil((route) {
      return route.settings.name != routeName;
    });
  }
}
