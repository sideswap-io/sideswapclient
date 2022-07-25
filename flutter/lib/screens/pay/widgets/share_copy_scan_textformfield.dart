import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';

typedef ShareTapCallback = void Function(BuildContext context);

class ShareCopyScanTextFormField extends StatefulWidget {
  const ShareCopyScanTextFormField({
    super.key,
    this.textFormFieldKey,
    this.focusNode,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.hintText = '',
    this.errorText,
    this.onCopyTap,
    this.shareEnabled = true,
    this.onShareTap,
    this.onScanTap,
    this.onPasteTap,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onEditingCompleted,
    this.addrType = AddrType.elements,
  });

  final GlobalKey<FormFieldState>? textFormFieldKey;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final String? hintText;
  final String? errorText;
  final VoidCallback? onCopyTap;
  final bool shareEnabled;
  final ShareTapCallback? onShareTap;
  final VoidCallback? onScanTap;
  final VoidCallback? onPasteTap;
  final bool enabled;
  final bool readOnly;
  final Function(String)? onChanged;
  final VoidCallback? onEditingCompleted;
  final AddrType addrType;

  @override
  ShareCopyScanTextFormFieldState createState() =>
      ShareCopyScanTextFormFieldState();
}

class ShareCopyScanTextFormFieldState
    extends State<ShareCopyScanTextFormField> {
  final _spaceBetween = 4.0;
  final _iconWidth = 24.0;

  late FocusNode _focusNode;
  bool _emptySuffix = false;
  final TextStyle _defaultStyle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: Color(0xFF84ADC6),
  );

  @override
  void initState() {
    super.initState();

    if (widget.onCopyTap == null &&
        widget.onPasteTap == null &&
        widget.onScanTap == null &&
        widget.onShareTap == null) {
      _emptySuffix = true;
    }

    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void onTapSuffix({
    VoidCallback? onTap,
  }) {
    if (onTap == null) {
      return;
    }

    _focusNode.unfocus();
    _focusNode.canRequestFocus = false;
    widget.controller?.clear();

    onTap();

    Future.delayed(const Duration(milliseconds: 100), () {
      _focusNode.canRequestFocus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var suffixCounter = 0.0;
    if (widget.onCopyTap != null) {
      suffixCounter++;
    }
    if (widget.onShareTap != null) {
      suffixCounter++;
    }
    if (widget.onScanTap != null) {
      suffixCounter++;
    }
    if (widget.onPasteTap != null) {
      suffixCounter++;
    }

    final gestureAreaWidth = _spaceBetween * 2 + _iconWidth;
    final suffixWidth = suffixCounter * gestureAreaWidth;

    return FutureBuilder<ClipboardData?>(
        future: Clipboard.getData(Clipboard.kTextPlain),
        builder: (data, clipboardData) {
          final clipboardText = clipboardData.data?.text?.trim() ?? '';
          return Consumer(
            builder: (context, ref, _) {
              final showPasteFromClipboard = !FlavorConfig.isDesktop &&
                  ref
                      .watch(walletProvider)
                      .isAddrValid(clipboardText, widget.addrType) &&
                  widget.controller != null;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    key: widget.textFormFieldKey,
                    focusNode: _focusNode,
                    controller: widget.controller,
                    style: widget.textStyle ??
                        _defaultStyle.copyWith(color: Colors.black),
                    enabled: widget.enabled,
                    readOnly: widget.readOnly,
                    onChanged: widget.onChanged,
                    toolbarOptions: const ToolbarOptions(
                      copy: true,
                      cut: true,
                      paste: true,
                      selectAll: true,
                    ),
                    onEditingComplete: widget.onEditingCompleted,
                    decoration: SideSwapInputDecoration(
                      hintStyle: widget.hintStyle,
                      hintText: widget.hintText,
                      errorText: widget.errorText,
                      errorStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFFFF7878),
                      ),
                      suffixIcon: _emptySuffix
                          ? null
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: SizedBox(
                                width: suffixWidth,
                                height: 24,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    if (widget.onCopyTap != null) ...[
                                      SizedBox(
                                        width: gestureAreaWidth,
                                        height: double.maxFinite,
                                        child: InkWell(
                                          onTap: () {
                                            onTapSuffix();
                                          },
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/copy.svg',
                                              width: _iconWidth,
                                              height: _iconWidth,
                                              color: const Color(0xFF00B4E9),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (widget.onPasteTap != null) ...[
                                      SizedBox(
                                        width: gestureAreaWidth,
                                        height: double.maxFinite,
                                        child: InkWell(
                                          onTap: () {
                                            onTapSuffix(
                                                onTap: widget.onPasteTap);
                                          },
                                          child: Center(
                                            child: Icon(
                                              Icons.content_paste,
                                              size: _iconWidth,
                                              color: const Color(0xFF00B4E9),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (widget.onScanTap != null) ...[
                                      SizedBox(
                                        width: gestureAreaWidth,
                                        height: double.maxFinite,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () {
                                              if (widget.shareEnabled) {
                                                onTapSuffix(
                                                    onTap: widget.onScanTap);
                                              }
                                            },
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/qr_icon.svg',
                                                width: _iconWidth,
                                                height: _iconWidth,
                                                color: const Color(0xFF00B4E9),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                    if (widget.onShareTap != null) ...[
                                      SizedBox(
                                        width: gestureAreaWidth,
                                        height: double.maxFinite,
                                        child: Builder(
                                          builder: (BuildContext context) =>
                                              InkWell(
                                            onTap: widget.onShareTap != null
                                                ? () {
                                                    _focusNode.unfocus();
                                                    _focusNode.canRequestFocus =
                                                        false;
                                                    if (widget.shareEnabled) {
                                                      widget
                                                          .onShareTap!(context);
                                                    }
                                                    Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100),
                                                        () {
                                                      _focusNode
                                                              .canRequestFocus =
                                                          true;
                                                    });
                                                  }
                                                : null,
                                            child: Center(
                                              child: Icon(
                                                Icons.share,
                                                size: _iconWidth,
                                                color: widget.shareEnabled
                                                    ? const Color(0xFF00B4E9)
                                                    : const Color(0xFFA5A9AF),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  if (showPasteFromClipboard) ...[
                    const SizedBox(height: 10),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF135579),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: TextButton(
                        onPressed: () {
                          setValue(widget.controller!, clipboardText);
                          if (widget.onChanged != null) {
                            widget.onChanged!(clipboardText);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Paste from clipboard'.tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Color(0xFF00B4E9),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Text(
                                        clipboardText,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.content_paste,
                                size: _iconWidth,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                ],
              );
            },
          );
        });
  }
}
