import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:marquee/marquee.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common_platform.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap/screens/pay/widgets/share_copy_scan_textformfield.dart';
import 'package:sideswap/screens/pay/widgets/ticker_amount_textfield.dart';
import 'package:sideswap/screens/swap/widgets/labeled_radio.dart';

class SwapSideAmount extends ConsumerStatefulWidget {
  const SwapSideAmount({
    super.key,
    required this.text,
    this.controller,
    this.addressController,
    this.onDropdownChanged,
    this.onChanged,
    this.onMaxPressed,
    required this.dropdownValue,
    required this.availableAssets,
    this.disabledAssets = const <AccountAsset>[],
    this.labelGroupValue = SwapWallet.local,
    this.localLabelOnChanged,
    this.externalLabelOnChanged,
    this.isMaxVisible = false,
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
    this.dollarConversion = '',
    this.dollarConversion2,
    this.textInputAction,
    this.showAccountsInPopup = false,
  });

  final String text;
  final TextEditingController? controller;
  final TextEditingController? addressController;
  final ValueChanged<AccountAsset>? onDropdownChanged;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onMaxPressed;
  final AccountAsset dropdownValue;
  final List<AccountAsset> availableAssets;
  final List<AccountAsset> disabledAssets;
  final SwapWallet labelGroupValue;
  final ValueChanged<SwapWallet>? localLabelOnChanged;
  final ValueChanged<SwapWallet>? externalLabelOnChanged;
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
  final String dollarConversion;
  final String? dollarConversion2;
  final TextInputAction? textInputAction;
  final bool showAccountsInPopup;

  @override
  SwapSideAmountState createState() => SwapSideAmountState();
}

class SwapSideAmountState extends ConsumerState<SwapSideAmount> {
  final _labelStyle = const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Color(0xFF00C5FF),
  );

  final _balanceStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: Color(0xFF709EBA),
  );

  @override
  void initState() {
    super.initState();
    widget.addressController?.addListener(() {
      ref.read(swapProvider).swapRecvAddressExternal =
          widget.addressController?.text ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(qrcodeResultModelProvider);
    result.maybeWhen(
      data: (result) {
        widget.addressController?.text = result?.address ?? '';
      },
      orElse: () {},
    );

    final isAmp = widget.dropdownValue.account.isAmp();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: widget.padding,
          child: SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 122,
                  child: Row(
                    children: [
                      Text(
                        widget.text,
                        style: _labelStyle,
                      ),
                      if (isAmp) const AmpFlag(fontSize: 10),
                    ],
                  ),
                ),
                if (widget.swapType == SwapType.pegOut &&
                    widget.labelGroupValue == SwapWallet.extern &&
                    widget.feeRates.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 24),
                    child: Text(
                      'Fee suggestions'.tr(),
                      style: _labelStyle,
                    ),
                  ),
                  const Spacer(),
                ] else ...[
                  if (widget.showInsufficientFunds && !widget.readOnly) ...[
                    Text(
                      'Insufficient funds'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFF7878),
                      ),
                    ),
                  ] else ...[
                    Container(),
                  ],
                  if (widget.dollarConversion2 != null &&
                      widget.dollarConversion2!.isNotEmpty)
                    Text(
                      '≈ ${widget.dollarConversion2}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF83B4D2),
                      ),
                    ),
                ],
                if (widget.errorDescription.isNotEmpty && !widget.readOnly) ...[
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        const textStyle = TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFFFF7878),
                        );
                        final renderParagraph = RenderParagraph(
                          TextSpan(
                            text: widget.errorDescription,
                            style: textStyle,
                          ),
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
                                text: widget.errorDescription,
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
                                accelerationDuration:
                                    const Duration(seconds: 3),
                                accelerationCurve: Curves.linear,
                                decelerationDuration:
                                    const Duration(milliseconds: 500),
                                decelerationCurve: Curves.easeOut,
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  widget.errorDescription,
                                  style: textStyle,
                                ),
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
            padding: widget.padding,
            child: SizedBox(
              height: 43,
              child: TickerAmountTextField(
                readOnly: widget.readOnly,
                dropdownReadOnly: widget.dropdownReadOnly,
                showError: widget.showInsufficientFunds ||
                    widget.errorDescription.isNotEmpty,
                controller: widget.controller,
                focusNode: widget.focusNode ?? FocusNode(),
                dropdownValue: widget.dropdownValue,
                availableAssets: widget.availableAssets,
                disabledAssets: widget.disabledAssets,
                onDropdownChanged: widget.onDropdownChanged,
                onChanged: widget.onChanged,
                hintText: widget.hintText,
                showHintText: widget.showHintText,
                feeRates: widget.feeRates,
                onSubmitted: widget.onSubmitted,
                onEditingComplete: widget.onEditingCompleted,
                textInputAction: widget.textInputAction,
                showAccountsInPopup: widget.showAccountsInPopup,
              ),
            ),
          ),
        ),
        if (widget.swapType != SwapType.atomic && widget.visibleToggles) ...[
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SizedBox(
              height: 18,
              child: Row(
                children: [
                  LabeledRadio<SwapWallet>(
                    label: 'Local wallet'.tr(),
                    value: SwapWallet.local,
                    groupValue: widget.labelGroupValue,
                    onChanged: widget.localLabelOnChanged,
                  ),
                  LabeledRadio<SwapWallet>(
                    label: 'External wallet'.tr(),
                    value: SwapWallet.extern,
                    groupValue: widget.labelGroupValue,
                    onChanged: widget.externalLabelOnChanged,
                  ),
                ],
              ),
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Padding(
            padding: widget.padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.swapType != SwapType.atomic &&
                    !widget.isMaxVisible &&
                    !widget.isAddressLabelVisible &&
                    widget.labelGroupValue == SwapWallet.extern) ...[
                  Flexible(
                    child: ShareCopyScanTextFormField(
                      focusNode: widget.receiveAddressFocusNode ?? FocusNode(),
                      errorText: widget.addressErrorText,
                      controller:
                          widget.addressController ?? TextEditingController(),
                      onChanged: widget.onAddressChanged,
                      onPasteTap: FlavorConfig.isDesktop &&
                              widget.addressController != null
                          ? () async {
                              await handlePasteSingleLine(
                                  widget.addressController!);
                              setState(() {});
                            }
                          : null,
                      onScanTap: FlavorConfig.isDesktop
                          ? null
                          : () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await Navigator.of(context, rootNavigator: true)
                                  .push<void>(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      commonPlatform.getAddressQrScanner(
                                          bitcoinAddress: true),
                                ),
                              );
                              logger.d('Scanner Done');
                            },
                      onEditingCompleted: widget.onAddressEditingCompleted,
                      addrType: AddrType.bitcoin,
                    ),
                  ),
                ],
                if (widget.swapType == SwapType.pegOut &&
                    widget.labelGroupValue == SwapWallet.extern &&
                    widget.isAddressLabelVisible) ...[
                  Container(
                    width: 343,
                    height: 98,
                    decoration: const BoxDecoration(
                      color: Color(0xFF226F99),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 71,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              widget.addressController?.text ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Flexible(
                          flex: 10,
                          child: Material(
                            color: const Color(0xFF226F99),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(21),
                              onTap: widget.onAddressLabelClose,
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/close.svg',
                                    width: 14,
                                    height: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
                if (widget.labelGroupValue == SwapWallet.extern &&
                    widget.swapType == SwapType.atomic) ...[
                  Text(
                    'Balance: unknown',
                    style: _balanceStyle,
                  ).tr(),
                ],
                if (widget.labelGroupValue == SwapWallet.local &&
                    (widget.swapType == SwapType.atomic ||
                        widget.swapType == SwapType.pegOut)) ...[
                  Text(
                    'Balance: {}',
                    style: _balanceStyle,
                  ).tr(args: [widget.balance]),
                ],
                if (widget.labelGroupValue == SwapWallet.extern &&
                    widget.swapType == SwapType.pegIn) ...[
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: Text(
                        'SideSwap will generate a Peg-In address for you to deliver BTC into'
                            .tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF709EBA),
                        ),
                      ),
                    ),
                  ),
                ],
                if (widget.labelGroupValue == SwapWallet.local &&
                    widget.swapType == SwapType.pegIn) ...[
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: Text(
                        'Your SideSwap wallet will auto-generate a L-BTC address with which to receive the Peg-In amount'
                            .tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF709EBA),
                        ),
                      ),
                    ),
                  ),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (widget.isMaxVisible &&
                        widget.labelGroupValue != SwapWallet.extern) ...[
                      Container(
                        width: 54,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF00C5FF),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: TextButton(
                          onPressed: widget.onMaxPressed,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                          ),
                          child: const Text(
                            'MAX',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF00C5FF),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (widget.dollarConversion.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '≈ ${widget.dollarConversion}',
                          style: _balanceStyle,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
