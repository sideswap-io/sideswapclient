import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:marquee_plus/marquee.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/widgets/middle_elipsis_text.dart';

import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/swap_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/pay/widgets/fee_rates_dropdown.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';
import 'package:sideswap/screens/pay/widgets/ticker_amount_textfield.dart';
import 'package:sideswap/screens/swap/widgets/labeled_radio.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class SwapSideAmount extends HookConsumerWidget {
  const SwapSideAmount({
    super.key,
    required this.text,
    this.controller,
    this.addressController,
    this.onDropdownChanged,
    this.onChanged,
    this.onMaxPressed,
    this.onSelectInputs,
    required this.dropdownValue,
    required this.availableAssets,
    this.disabledAssets = const <AccountAsset>[],
    this.labelGroupValue = const SwapWallet.local(),
    this.localLabelOnChanged,
    this.externalLabelOnChanged,
    this.isMaxVisible = false,
    this.isInputsVisible = false,
    this.readOnly = false,
    this.dropdownReadOnly = false,
    this.padding = EdgeInsets.zero,
    this.balance = '0.00',
    this.focusNode,
    this.receiveAddressFocusNode,
    this.visibleToggles = false,
    this.onAddressEditingCompleted,
    this.addressErrorText,
    this.onAddressChanged,
    this.isAddressLabelVisible = false,
    this.onAddressLabelClose,
    this.hintText = '',
    this.showHintText = false,
    this.feeRates = const <FeeRate>[],
    required this.swapType,
    this.showInsufficientFunds = false,
    this.errorDescription = '',
    this.onSubmitted,
    this.onEditingCompleted,
    this.defaultCurrencyConversion = '',
    this.defaultCurrencyConversion2,
    this.textInputAction,
    this.showAccountsInPopup = false,
  });

  final String text;
  final TextEditingController? controller;
  final TextEditingController? addressController;
  final ValueChanged<AccountAsset>? onDropdownChanged;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onMaxPressed;
  final VoidCallback? onSelectInputs;
  final AccountAsset dropdownValue;
  final List<AccountAsset> availableAssets;
  final List<AccountAsset> disabledAssets;
  final SwapWallet labelGroupValue;
  final ValueChanged<SwapWallet>? localLabelOnChanged;
  final ValueChanged<SwapWallet>? externalLabelOnChanged;
  final bool isInputsVisible;
  final bool isMaxVisible;
  final bool readOnly;
  final bool dropdownReadOnly;
  final EdgeInsetsGeometry padding;
  final String balance;
  final FocusNode? focusNode;
  final FocusNode? receiveAddressFocusNode;
  final bool visibleToggles;
  final VoidCallback? onAddressEditingCompleted;
  final String? addressErrorText;
  final ValueChanged<String>? onAddressChanged;
  final bool isAddressLabelVisible;
  final VoidCallback? onAddressLabelClose;
  final String hintText;
  final bool showHintText;
  final List<FeeRate> feeRates;
  final SwapType swapType;
  final bool showInsufficientFunds;
  final String errorDescription;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingCompleted;
  final String defaultCurrencyConversion;
  final String? defaultCurrencyConversion2;
  final TextInputAction? textInputAction;
  final bool showAccountsInPopup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const labelStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.brightTurquoise,
    );

    const balanceStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: SideSwapColors.airSuperiorityBlue,
    );

    final result = ref.watch(qrCodeResultModelNotifierProvider);

    useEffect(() {
      (switch (result) {
        QrCodeResultModelData() => () {
          addressController?.text = result.result?.address ?? '';
          Future.microtask(() {
            onAddressChanged?.call(addressController?.text ?? '');
            ref
                .read(qrCodeResultModelNotifierProvider.notifier)
                .setModel(const QrCodeResultModel.empty());
          });
        },
        _ => () {},
      }());

      return;
    }, [result]);

    final isAmp = dropdownValue.account.isAmp;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding,
          child: SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 122,
                  child: Row(
                    children: [
                      Text(text, style: labelStyle),
                      if (isAmp)
                        const AmpFlag(
                          textStyle: TextStyle(
                            color: Color(0xFF73A6C5),
                            fontSize: 10,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showInsufficientFunds && !readOnly) ...[
                  Text(
                    'Insufficient funds'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: SideSwapColors.bitterSweet,
                    ),
                  ),
                ] else ...[
                  const SizedBox(),
                ],
                if (defaultCurrencyConversion2 != null &&
                    defaultCurrencyConversion2!.isNotEmpty)
                  Text(
                    '≈ $defaultCurrencyConversion2',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      color: SideSwapColors.halfBaked,
                    ),
                  ),
                if (errorDescription.isNotEmpty && !readOnly) ...[
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const textStyle = TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: SideSwapColors.bitterSweet,
                        );
                        final renderParagraph = RenderParagraph(
                          TextSpan(text: errorDescription, style: textStyle),
                          textDirection: ui.TextDirection.ltr,
                          softWrap: false,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        );
                        renderParagraph.layout(constraints);
                        var textWidth = renderParagraph.textSize.width;
                        var constraintsWidth =
                            renderParagraph.constraints.maxWidth;
                        return textWidth > constraintsWidth
                            ? Marquee(
                              text: errorDescription,
                              style: textStyle,
                              scrollAxis: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              blankSpace: 200.0,
                              velocity: 30.0,
                              pauseAfterRound: const Duration(seconds: 3),
                              showFadingOnlyWhenScrolling: true,
                              fadingEdgeStartFraction: 0.1,
                              fadingEdgeEndFraction: 0.1,
                              startPadding: 100.0,
                              accelerationDuration: const Duration(seconds: 3),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: const Duration(
                                milliseconds: 500,
                              ),
                              decelerationCurve: Curves.easeOut,
                            )
                            : Align(
                              alignment: Alignment.centerRight,
                              child: Text(errorDescription, style: textStyle),
                            );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Padding(
            padding: padding,
            child: SizedBox(
              height: 43,
              child: TickerAmountTextField(
                readOnly: readOnly,
                dropdownReadOnly: dropdownReadOnly,
                showError: showInsufficientFunds || errorDescription.isNotEmpty,
                controller: controller,
                focusNode: focusNode ?? FocusNode(),
                dropdownValue: dropdownValue,
                availableAssets: availableAssets,
                disabledAssets: disabledAssets,
                onDropdownChanged: onDropdownChanged,
                onChanged: onChanged,
                hintText: hintText,
                showHintText: showHintText,
                onSubmitted: onSubmitted,
                onEditingComplete: onEditingCompleted,
                textInputAction: textInputAction,
                showAccountsInPopup: showAccountsInPopup,
              ),
            ),
          ),
        ),
        if (swapType != const SwapType.atomic() && visibleToggles) ...[
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SizedBox(
              height: 18,
              child: Row(
                children: [
                  LabeledRadio<SwapWallet>(
                    label: 'Local wallet'.tr(),
                    value: const SwapWallet.local(),
                    groupValue: labelGroupValue,
                    onChanged: localLabelOnChanged,
                  ),
                  LabeledRadio<SwapWallet>(
                    label: 'External wallet'.tr(),
                    value: const SwapWallet.extern(),
                    groupValue: labelGroupValue,
                    onChanged: externalLabelOnChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (swapType != const SwapType.atomic() &&
                    !isMaxVisible &&
                    !isAddressLabelVisible &&
                    labelGroupValue == const SwapWallet.extern()) ...[
                  Flexible(
                    child: ShareCopyScanTextFormField(
                      focusNode: receiveAddressFocusNode ?? FocusNode(),
                      errorText: addressErrorText,
                      controller: addressController ?? TextEditingController(),
                      onChanged: onAddressChanged,
                      onPasteTap:
                          FlavorConfig.isDesktop && addressController != null
                              ? () async {
                                await handlePasteSingleLine(addressController!);
                                onAddressChanged?.call(addressController!.text);
                              }
                              : null,
                      onScanTap:
                          FlavorConfig.isDesktop
                              ? null
                              : () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                await Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).push<void>(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => getAddressQrScanner(
                                          bitcoinAddress: true,
                                        ),
                                  ),
                                );
                                logger.d('Scanner Done');
                              },
                      onEditingCompleted: onAddressEditingCompleted,
                      addrType: AddrType.bitcoin,
                    ),
                  ),
                ],
                if (swapType == const SwapType.pegOut() &&
                    labelGroupValue == const SwapWallet.extern() &&
                    isAddressLabelVisible) ...[
                  Flexible(
                    child: SwapSideAmountPegOutAddressLabel(
                      addressController: addressController,
                      onAddressLabelClose: onAddressLabelClose,
                    ),
                  ),
                ],
                if (labelGroupValue == const SwapWallet.extern() &&
                    swapType == const SwapType.atomic()) ...[
                  Text('Balance: unknown'.tr(), style: balanceStyle).tr(),
                ],
                if (labelGroupValue == const SwapWallet.local() &&
                    (swapType == const SwapType.atomic() ||
                        swapType == const SwapType.pegOut())) ...[
                  Text('Balance: {}'.tr(args: [balance]), style: balanceStyle),
                ],
                if (labelGroupValue == const SwapWallet.extern() &&
                    swapType == const SwapType.pegIn()) ...[
                  const Flexible(child: SwapSideAmountExternPegInDescription()),
                ],
                if (labelGroupValue == const SwapWallet.local() &&
                    swapType == const SwapType.pegIn()) ...[
                  const Flexible(child: SwapSideAmountLocalPegInDescription()),
                ],
                Column(
                  children: [
                    Row(
                      children: [
                        if (isInputsVisible &&
                            labelGroupValue != const SwapWallet.extern()) ...[
                          SwapSideAmountSelectInputsButton(
                            onInputsSelected: onSelectInputs,
                          ),
                        ],
                        if (isMaxVisible &&
                            labelGroupValue != const SwapWallet.extern()) ...[
                          SwapSideAmountMaxButton(onMaxPressed: onMaxPressed),
                        ],
                      ],
                    ),
                    if (defaultCurrencyConversion.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '≈ $defaultCurrencyConversion',
                          style: balanceStyle,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
        if (swapType == const SwapType.pegOut() &&
            labelGroupValue == const SwapWallet.extern())
          SwapSideAmountFeeSuggestionsDropdown(padding: padding),
      ],
    );
  }
}

class SwapSideAmountPegOutAddressLabel extends StatelessWidget {
  const SwapSideAmountPegOutAddressLabel({
    super.key,
    required this.addressController,
    required this.onAddressLabelClose,
  });

  final TextEditingController? addressController;
  final ui.VoidCallback? onAddressLabelClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      decoration: const BoxDecoration(
        color: Color(0xFF226F99),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: MiddleEllipsisText(
                text: addressController?.text ?? '',
                maxLines: 2,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: onAddressLabelClose,
            icon: SvgPicture.asset('assets/close.svg', width: 14, height: 14),
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}

class SwapSideAmountLocalPegInDescription extends StatelessWidget {
  const SwapSideAmountLocalPegInDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Text(
        'Your SideSwap wallet will auto-generate a L-BTC address with which to receive the Peg-In amount'
            .tr(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: SideSwapColors.airSuperiorityBlue,
        ),
      ),
    );
  }
}

class SwapSideAmountExternPegInDescription extends StatelessWidget {
  const SwapSideAmountExternPegInDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Text(
        'SideSwap will generate a Peg-In address for you to deliver BTC into'
            .tr(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: SideSwapColors.airSuperiorityBlue,
        ),
      ),
    );
  }
}

class SwapSideAmountFeeSuggestionsDropdown extends StatelessWidget {
  const SwapSideAmountFeeSuggestionsDropdown({
    super.key,
    required this.padding,
  });

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: SideSwapColors.brightTurquoise,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Fee suggestions'.tr(), style: labelStyle),
            const Spacer(),
            const FeeRatesDropdown(),
          ],
        ),
      ),
    );
  }
}

class SwapSideAmountMaxButton extends StatelessWidget {
  const SwapSideAmountMaxButton({super.key, required this.onMaxPressed});

  final ui.VoidCallback? onMaxPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: SideSwapColors.brightTurquoise,
          width: 1,
          style: BorderStyle.solid,
        ),
      ),
      child: TextButton(
        onPressed: onMaxPressed,
        style: TextButton.styleFrom(
          foregroundColor: Colors.black,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        child: const Text(
          'MAX',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: SideSwapColors.brightTurquoise,
          ),
        ),
      ),
    );
  }
}

class SwapSideAmountSelectInputsButton extends ConsumerWidget {
  const SwapSideAmountSelectInputsButton({
    super.key,
    required this.onInputsSelected,
  });

  final ui.VoidCallback? onInputsSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedInputsHelper = ref.watch(selectedInputsHelperProvider);
    final utxoCount = selectedInputsHelper.count();
    final containsUtxo = utxoCount > 0;

    return Row(
      children: [
        Container(
          height: 24,
          decoration:
              containsUtxo
                  ? BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: SideSwapColors.turquoise,
                  )
                  : BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: SideSwapColors.brightTurquoise,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                  ),
          child: TextButton(
            onPressed: onInputsSelected,
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              padding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: switch (containsUtxo) {
              true => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 8),
                  const Icon(Icons.done, size: 10, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    '{} INPUTS'.plural(utxoCount, args: ['$utxoCount']),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              _ => Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    'SELECT INPUTS'.tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            },
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
