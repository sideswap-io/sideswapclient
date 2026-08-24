import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/widgets/dialog_presenter.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap/screens/swap/widgets/quote_expired_dialog.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

enum SettingsDialogIcon { error, restart }

const kErrorQuoteExpired = 'quote expired';

final utilsProvider = Provider<UtilsProvider>((ref) => UtilsProvider(ref));

class UtilsProvider {
  final Ref ref;
  final DialogPresenter _presenter;

  UtilsProvider(this.ref, {DialogPresenter? presenter})
    : _presenter = presenter ?? FlutterDialogPresenter();

  Future<void> settingsErrorDialog({
    required String title,
    String description = '',
    required String buttonText,
    required void Function(BuildContext context) onPressed,
    String secondButtonText = '',
    void Function(BuildContext context)? onSecondPressed,
    SettingsDialogIcon icon = SettingsDialogIcon.error,
    double? width,
  }) async {
    final context = ref.read(navigatorKeyProvider).currentContext;
    if (context == null) return;

    await _presenter.showSettingsErrorDialog(
      context,
      title: title,
      description: description,
      buttonText: buttonText,
      onPressed: onPressed,
      secondButtonText: secondButtonText,
      onSecondPressed: onSecondPressed,
      icon: icon,
      width: width,
    );
  }

  Future<void> showErrorDialog(
    String errorDescription, {
    String? buttonText,
  }) async {
    final context = ref.read(navigatorKeyProvider).currentContext;

    if (context == null) {
      return;
    }

    if (errorDescription == kErrorQuoteExpired) {
      showQuoteExpiredDialog(context);
      return;
    }

    if (errorDescription.contains('User declined to sign transaction')) {
      errorDescription = 'Transaction sign declined'.tr();
    }

    if (errorDescription.contains('jade response timeout')) {
      errorDescription = 'Please ensure your Jade is turned on'.tr();
    }

    if (errorDescription.contains('jade is not connected')) {
      errorDescription = 'Please ensure your Jade device is connected'.tr();
    }

    await _presenter.showErrorDialog(
      context,
      errorDescription,
      buttonText: buttonText,
    );
  }

  Future<void> showInsufficienFunds(From_ShowInsufficientFunds msg) async {
    final context = ref.read(navigatorKeyProvider).currentContext;

    if (context == null) {
      return;
    }

    await _presenter.showInsufficientFundsDialog(context, msg);
  }
}
