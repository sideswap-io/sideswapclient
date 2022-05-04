import 'dart:ui' as _ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets.dart';
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
    Key? key,
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
  }) : super(key: key);

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
  _SwapSideAmountState createState() => _SwapSideAmountState();
}

class _SwapSideAmountState extends ConsumerState<SwapSideAmount> {
  final _labelStyle = GoogleFonts.roboto(
    fontSize: 15.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF00C5FF),
  );

  final _balanceStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF709EBA),
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
    final isAmp = widget.dropdownValue.account.isAmp();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: widget.padding,
          child: SizedBox(
            height: 20.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 122.w,
                  child: Row(
                    children: [
                      Text(
                        widget.text,
                        style: _labelStyle,
                      ).tr(),
                      if (isAmp) const AmpFlag(fontSize: 10),
                    ],
                  ),
                ),
                if (widget.swapType == SwapType.pegOut &&
                    widget.labelGroupValue == SwapWallet.extern &&
                    widget.feeRates.isNotEmpty) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 24.w),
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
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFFFF7878),
                      ),
                    ),
                  ] else ...[
                    Container(),
                  ],
                  if (widget.dollarConversion2 != null &&
                      widget.dollarConversion2!.isNotEmpty)
                    Text(
                      '≈ ${widget.dollarConversion2}',
                      style: GoogleFonts.roboto(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.normal,
                        color: const Color(0xFF83B4D2),
                      ),
                    ),
                ],
                if (widget.errorDescription.isNotEmpty && !widget.readOnly) ...[
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final textStyle = GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFFFF7878),
                        );
                        final renderParagraph = RenderParagraph(
                          TextSpan(
                            text: widget.errorDescription,
                            style: textStyle,
                          ),
                          textDirection: _ui.TextDirection.ltr,
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
          padding: EdgeInsets.only(top: 10.h),
          child: Padding(
            padding: widget.padding,
            child: SizedBox(
              height: 43.h,
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
            padding: EdgeInsets.only(top: 14.h),
            child: SizedBox(
              height: 18.h,
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
          padding: EdgeInsets.only(top: 10.h),
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
                                  builder: (context) => AddressQrScanner(
                                    resultCb: (value) async {
                                      widget.addressController?.text =
                                          value.address ?? '';
                                    },
                                    expectedAddress: QrCodeAddressType.bitcoin,
                                  ),
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
                    width: 343.w,
                    height: 98.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFF226F99),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.w),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 71,
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Text(
                              widget.addressController?.text ?? '',
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
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
                              borderRadius: BorderRadius.circular(21.w),
                              onTap: widget.onAddressLabelClose,
                              child: Container(
                                width: 42.w,
                                height: 42.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(21.w),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/close.svg',
                                    width: 14.w,
                                    height: 14.w,
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
                    'PAYMENT_BALANCE',
                    style: _balanceStyle,
                  ).tr(args: [widget.balance]),
                ],
                if (widget.labelGroupValue == SwapWallet.extern &&
                    widget.swapType == SwapType.pegIn) ...[
                  Expanded(
                    child: SizedBox(
                      height: 36.h,
                      child: Text(
                        'SideSwap will generate a Peg-In address for you to deliver BTC into'
                            .tr(),
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF709EBA),
                        ),
                      ),
                    ),
                  ),
                ],
                if (widget.labelGroupValue == SwapWallet.local &&
                    widget.swapType == SwapType.pegIn) ...[
                  Expanded(
                    child: SizedBox(
                      height: 36.h,
                      child: Text(
                        'Your SideSwap wallet will auto-generate a L-BTC address with which to receive the Peg-In amount'
                            .tr(),
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF709EBA),
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
                        width: 54.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.w),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.w),
                              ),
                            ),
                          ),
                          child: Text(
                            'MAX',
                            style: GoogleFonts.roboto(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.normal,
                              color: const Color(0xFF00C5FF),
                            ),
                          ),
                        ),
                      ),
                    ],
                    if (widget.dollarConversion.isNotEmpty) ...[
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
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
