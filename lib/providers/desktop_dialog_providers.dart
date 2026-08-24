import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sideswap/desktop/desktop_dialog_presenter.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

part 'desktop_dialog_providers.g.dart';

@riverpod
DesktopDialog desktopDialog(Ref ref) {
  final context = ref.watch(navigatorKeyProvider).currentContext!;
  final currentTxPopupItemNotifier = ref.watch(
    currentTxPopupItemProvider.notifier,
  );
  return DesktopDialog(currentTxPopupItemNotifier, context: context);
}

class DesktopDialog {
  final CurrentTxPopupItemNotifier currentTxPopupItemNotifier;
  final BuildContext _context;
  final DesktopDialogPresenter _presenter;

  DesktopDialog(
    this.currentTxPopupItemNotifier, {
    required this._context,
    DesktopDialogPresenter? presenter,
  }) : _presenter = presenter ?? FlutterDesktopDialogPresenter();

  void showRecvAddress() {
    _presenter.showRecvAddress(_context);
  }

  Future<void> showNeedRestartDialog() async {
    await _presenter.showNeedRestartDialog(_context);
  }

  void showGenerateAddress() {
    _presenter.showGenerateAddress(_context);
  }

  void showSendTx() {
    _presenter.showSendTx(_context);
  }

  Future<T?> showExportCsv<T>() {
    return _presenter.showExportCsv<T>(_context);
  }

  void showSelectInputs() {
    _presenter.showSelectInputs(_context);
  }

  Future<void> showTx(TransItem transItem, {required bool isPeg}) async {
    closePopups();

    currentTxPopupItemNotifier.setCurrentTxId(
      transItem.hasPeg()
          ? transItem.peg.isPegIn
                ? transItem.peg.txidRecv
                : transItem.peg.txidSend
          : transItem.tx.txid,
    );

    await _presenter.showTxDialog(_context, isPeg: isPeg);
  }

  Future<void> showAcceptQuoteErrorDialog() async {
    await _presenter.showAcceptQuoteErrorDialog(_context);
  }

  void openTxImport() {
    _presenter.openTxImport(_context);
  }

  Future<DialogReturnValue> openViewTx() async {
    final result = await _presenter.openViewTx(_context);

    return switch (result) {
      final result? => result,
      _ => const DialogReturnValueCancelled(),
    };
  }

  Future<void> openExportTxSuccess() async {
    await _presenter.openExportTxSuccess(_context);
  }

  void showAssetInfoDialog(Asset asset) {
    _presenter.showAssetInfoDialog(_context, asset);
  }

  void closePopups({String? popupRouteName}) {
    _presenter.closePopups(_context, popupRouteName: popupRouteName);
  }
}
