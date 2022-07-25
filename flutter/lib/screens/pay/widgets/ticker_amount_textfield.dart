import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/utils/decimal_text_input_formatter.dart';
import 'package:sideswap/models/account_asset.dart';
import 'package:sideswap/models/swap_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/protobuf/sideswap.pb.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/pay/payment_select_account.dart';
import 'package:sideswap/screens/pay/widgets/fee_rates_dropdown.dart';

class TickerAmountTextField extends StatefulWidget {
  const TickerAmountTextField({
    super.key,
    this.text,
    this.onDropdownChanged,
    required this.dropdownValue,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.availableAssets = const <AccountAsset>[],
    this.disabledAssets = const <AccountAsset>[],
    this.readOnly = false,
    this.dropdownReadOnly = false,
    this.showError = false,
    this.hintText = '',
    this.showHintText = false,
    this.feeRates = const <FeeRate>[],
    this.onSubmitted,
    this.onEditingComplete,
    this.textInputAction,
    this.showAccountsInPopup = false,
  });

  final String? text;
  final void Function(AccountAsset)? onDropdownChanged;
  final AccountAsset dropdownValue;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final List<AccountAsset> availableAssets;
  final List<AccountAsset> disabledAssets;
  final bool readOnly;
  final bool dropdownReadOnly;
  final bool showError;
  final String hintText;
  final bool showHintText;
  final List<FeeRate> feeRates;
  final void Function(String)? onSubmitted;
  final void Function()? onEditingComplete;
  final TextInputAction? textInputAction;
  final bool showAccountsInPopup;

  @override
  TickerAmountTextFieldState createState() => TickerAmountTextFieldState();
}

class TickerAmountTextFieldState extends State<TickerAmountTextField> {
  final _textFieldStyle = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  final _dropdownTextStyle = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.normal,
    color: Colors.white,
  );

  FocusNode _textfieldFocusNode = FocusNode();
  bool _visibleHintText = false;
  FeeRate? _feeRate;

  @override
  void initState() {
    super.initState();
    _visibleHintText = widget.showHintText;

    _feeRate = widget.feeRates.isNotEmpty ? widget.feeRates.first : null;

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
  void didUpdateWidget(covariant TickerAmountTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.feeRates != oldWidget.feeRates && widget.feeRates.isNotEmpty) {
      setState(() {
        final blocks = _feeRate?.blocks ?? 2;
        _feeRate = widget.feeRates.firstWhere((e) => e.blocks == blocks);
      });
    }
  }

  Widget buildDropdown() {
    return Builder(builder: (context) {
      return SizedBox(
        width: 90,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<AccountAsset>(
            isExpanded: true,
            icon: widget.dropdownReadOnly
                ? Container()
                : const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
            dropdownColor: const Color(0xFF2B6F95),
            style: _dropdownTextStyle,
            onChanged: widget.dropdownReadOnly
                ? null
                : (value) {
                    if (widget.onDropdownChanged == null || value == null) {
                      return;
                    }
                    widget.onDropdownChanged!(value);
                  },
            disabledHint: widget.dropdownReadOnly
                ? Row(
                    children: [
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final text = ref
                                    .watch(walletProvider)
                                    .getAssetById(widget.dropdownValue.asset)
                                    ?.ticker ??
                                '';
                            return Text(
                              text,
                              textAlign: TextAlign.left,
                              style: _dropdownTextStyle,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : null,
            value: widget.dropdownValue,
            items: widget.availableAssets.map((value) {
              return DropdownMenuItem<AccountAsset>(
                value: value,
                child: Row(
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        final asset = ref.watch(walletProvider
                            .select((p) => p.assets[value.asset]));
                        final image = ref.watch(walletProvider
                            .select((p) => p.assetImagesSmall[asset?.assetId]));
                        if (image != null) {
                          return image;
                        }

                        return Container();
                      },
                    ),
                    Container(width: 8),
                    Consumer(builder: (context, ref, _) {
                      final asset = ref.watch(
                          walletProvider.select((p) => p.assets[value.asset]));

                      if (asset?.ticker != null) {
                        return Expanded(
                          child: Text(
                            asset?.ticker ?? '',
                            textAlign: TextAlign.left,
                            style: _dropdownTextStyle,
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.fade,
                          ),
                        );
                      }

                      return Container();
                    }),
                  ],
                ),
              );
            }).toList(),
            selectedItemBuilder: (context) {
              return widget.availableAssets.map((value) {
                return Consumer(
                  builder: (context, ref, _) {
                    final asset = ref.watch(
                        walletProvider.select((p) => p.assets[value.asset]));

                    if (asset?.ticker != null) {
                      return Row(
                        children: [
                          Expanded(
                            child: Text(
                              asset?.ticker ?? '',
                              textAlign: TextAlign.left,
                              style: _dropdownTextStyle,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                        ],
                      );
                    }

                    return Container();
                  },
                );
              }).toList();
            },
          ),
        ),
      );
    });
  }

  void showAccountsPopup() {
    Widget builder(BuildContext context) {
      return PaymentSelectAccount(
        availableAssets: widget.availableAssets,
        disabledAssets: widget.disabledAssets,
        onSelected: (AccountAsset value) {
          widget.onDropdownChanged!(value);
        },
      );
    }

    Navigator.of(context, rootNavigator: true).push<void>(
      FlavorConfig.isDesktop
          ? DialogRoute(builder: builder, context: context)
          : MaterialPageRoute(builder: builder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final borderDecoration = BoxDecoration(
      shape: BoxShape.rectangle,
      border: Border(
        bottom: BorderSide(
          color: (widget.showError && !widget.readOnly)
              ? const Color(0xFFFF7878)
              : (_textfieldFocusNode.hasFocus && !widget.readOnly)
                  ? const Color(0xFF00C5FF)
                  : const Color(0xFF2B6F95),
          style: BorderStyle.solid,
          width: 1,
        ),
      ),
    );

    return Container(
      height: 43,
      decoration: widget.feeRates.isNotEmpty ? null : borderDecoration,
      child: Column(
        children: [
          SizedBox(
            height: 42,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration:
                      widget.feeRates.isNotEmpty ? borderDecoration : null,
                  child: Row(
                    children: [
                      Consumer(
                        builder: (context, ref, _) {
                          final icon = ref.watch(walletProvider.select((p) =>
                              p.assetImagesSmall[widget.dropdownValue.asset]));

                          return SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(child: icon),
                          );
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: (widget.showAccountsInPopup)
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: widget.dropdownReadOnly
                                      ? null
                                      : showAccountsPopup,
                                  child: IgnorePointer(child: buildDropdown()))
                              : buildDropdown()),
                    ],
                  ),
                ),
                Expanded(
                  child: Consumer(
                    builder: (context, ref, _) {
                      final swapType = ref.watch(swapProvider).swapType();
                      if (swapType == SwapType.pegIn && widget.readOnly) {
                        _visibleHintText = false;
                      }

                      if (widget.feeRates.isNotEmpty) {
                        return FeeRatesDropdown(
                            borderDecoration: borderDecoration);
                      }

                      final assetPrecision = ref.watch(walletProvider.select(
                          (p) =>
                              p.assets[widget.dropdownValue.asset]!.precision));

                      return SizedBox(
                        height: 42,
                        child: TextField(
                          autofocus: false,
                          readOnly: widget.readOnly,
                          controller: widget.controller,
                          focusNode: _textfieldFocusNode,
                          textAlign: TextAlign.end,
                          style: _textFieldStyle,
                          cursorColor: Colors.white,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            CommaTextInputFormatter(),
                            if (assetPrecision == 0) ...[
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\-|,\\ .]')),
                            ] else ...[
                              FilteringTextInputFormatter.deny(
                                  RegExp('[\\-|,\\ ]')),
                            ],
                            DecimalTextInputFormatter(
                                decimalRange: assetPrecision),
                          ],
                          onChanged: widget.onChanged,
                          onSubmitted: widget.onSubmitted,
                          textInputAction: widget.textInputAction,
                          onEditingComplete: widget.onEditingComplete,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: _visibleHintText ? widget.hintText : '',
                            hintStyle: _textFieldStyle.copyWith(),
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
