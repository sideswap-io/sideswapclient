import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';

class TickerAmountTextField extends StatefulWidget {
  TickerAmountTextField({
    Key key,
    this.onDropdownChanged,
    @required this.dropdownValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.availableAssets,
    this.readOnly = false,
    this.dropdownReadOnly = false,
    this.showError = false,
    this.hintText = '',
    this.showHintText = false,
  }) : super(key: key);

  final void Function(String) onDropdownChanged;
  final String dropdownValue;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final List<String> availableAssets;
  final bool readOnly;
  final bool dropdownReadOnly;
  final bool showError;
  final String hintText;
  final bool showHintText;

  @override
  _TickerAmountTextFieldState createState() => _TickerAmountTextFieldState();
}

class _TickerAmountTextFieldState extends State<TickerAmountTextField> {
  final _textFieldStyle = GoogleFonts.roboto(
    fontSize: 26.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  final _dropdownTextStyle = GoogleFonts.roboto(
    fontSize: 22.sp,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  FocusNode _textfieldFocusNode;
  bool _visibleHintText;

  @override
  void initState() {
    super.initState();
    _visibleHintText = widget.showHintText;

    _textfieldFocusNode = widget.focusNode ?? FocusNode();
    _textfieldFocusNode.addListener(() {
      if (!mounted) {
        return;
      }

      setState(() {
        if (_textfieldFocusNode.hasFocus && !widget.readOnly) {
          _visibleHintText = false;
        } else {
          _visibleHintText = widget.showHintText;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 43.h,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border(
          bottom: BorderSide(
            color: (widget.showError && !widget.readOnly)
                ? Color(0xFFFF7878)
                : (_textfieldFocusNode.hasFocus && !widget.readOnly)
                    ? Color(0xFF00C5FF)
                    : Color(0xFF2B6F95),
            style: BorderStyle.solid,
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 42.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer(
                  builder: (context, watch, child) {
                    final _icon = context
                        .read(walletProvider)
                        .assetImagesSmall[widget.dropdownValue];

                    return Container(
                      width: 32.h,
                      height: 32.h,
                      child: _icon,
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.w),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: widget.dropdownReadOnly
                          ? Container()
                          : Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                      dropdownColor: Color(0xFF2B6F95),
                      style: _dropdownTextStyle,
                      onChanged: widget.dropdownReadOnly
                          ? null
                          : (value) {
                              widget.onDropdownChanged(value);
                            },
                      disabledHint: widget.dropdownReadOnly
                          ? Container(
                              width: 68.w,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                  ),
                                  Text(
                                    context
                                        .read(walletProvider)
                                        .getAssetById(widget.dropdownValue)
                                        .ticker,
                                    style: _dropdownTextStyle,
                                  ),
                                ],
                              ),
                            )
                          : null,
                      value: widget.dropdownValue,
                      items: widget.availableAssets.map((value) {
                        final _asset =
                            context.read(walletProvider).assets[value];
                        return DropdownMenuItem<String>(
                          child: Row(
                            children: [
                              if (context
                                      .read(walletProvider)
                                      .assetImagesSmall[_asset?.assetId] !=
                                  null) ...[
                                context
                                    .read(walletProvider)
                                    .assetImagesSmall[_asset.assetId],
                              ],
                              Container(
                                width: 8.w,
                              ),
                              if (_asset?.ticker != null) ...[
                                Text(
                                  _asset.ticker,
                                ),
                              ],
                            ],
                          ),
                          value: value,
                        );
                      }).toList(),
                      selectedItemBuilder: (context) {
                        // if - else is needed here because this bug still exist in 1.22.6
                        // https://github.com/flutter/flutter/issues/51922
                        if (widget.dropdownReadOnly) {
                          return [Container()];
                        } else {
                          return widget.availableAssets.map((value) {
                            final _asset =
                                context.read(walletProvider).assets[value];
                            return Container(
                              width: 68.w,
                              child: Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                  ),
                                  if (_asset?.ticker != null) ...[
                                    Text(
                                      _asset.ticker,
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }).toList();
                        }
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, watch, child) {
                      if (context.read(swapProvider).swapType() ==
                              SwapType.pegIn &&
                          widget.readOnly) {
                        _visibleHintText = false;
                      }

                      return Container(
                        height: 42.h,
                        child: TextField(
                          readOnly: widget.readOnly,
                          controller: widget.controller,
                          focusNode: _textfieldFocusNode,
                          textAlign: TextAlign.end,
                          style: _textFieldStyle,
                          cursorColor: Colors.white,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            CommaTextInputFormatter(),
                            FilteringTextInputFormatter.deny(
                                RegExp('[\\-|,\\ ]')),
                            DecimalTextInputFormatter(decimalRange: 8),
                          ],
                          onChanged: widget.onChanged,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: _visibleHintText ? widget.hintText : '',
                            hintStyle: _textFieldStyle,
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
