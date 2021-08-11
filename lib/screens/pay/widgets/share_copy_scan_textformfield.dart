import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/screen_utils.dart';

typedef ShareTapCallback = void Function(BuildContext context);

class ShareCopyScanTextFormField extends StatefulWidget {
  const ShareCopyScanTextFormField({
    Key? key,
    this.textFormFieldKey,
    this.focusNode,
    this.controller,
    this.textStyle,
    this.hintStyle,
    this.hintText = '',
    this.errorText = '',
    this.onCopyTap,
    this.shareEnabled = true,
    this.onShareTap,
    this.onScanTap,
    this.onPasteTap,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.onEditingCompleted,
  }) : super(key: key);

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
  final VoidCallback? onTap;
  final VoidCallback? onEditingCompleted;

  @override
  _ShareCopyScanTextFormFieldState createState() =>
      _ShareCopyScanTextFormFieldState();
}

class _ShareCopyScanTextFormFieldState
    extends State<ShareCopyScanTextFormField> {
  final _spaceBetween = 4;
  final _iconWidth = 24;

  late FocusNode _focusNode;
  bool _emptySuffix = false;
  final TextStyle _defaultStyle = GoogleFonts.roboto(
    fontSize: 17.sp,
    fontWeight: FontWeight.normal,
    color: const Color(0xFF84ADC6),
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
    var _suffixCounter = 0;
    if (widget.onCopyTap != null) {
      _suffixCounter++;
    }
    if (widget.onShareTap != null) {
      _suffixCounter++;
    }
    if (widget.onScanTap != null) {
      _suffixCounter++;
    }
    if (widget.onPasteTap != null) {
      _suffixCounter++;
    }

    final _gestureAreaWidth = _spaceBetween * 2 + _iconWidth;
    final _suffixWidth = _suffixCounter * _gestureAreaWidth;

    return TextField(
      key: widget.textFormFieldKey,
      focusNode: _focusNode,
      controller: widget.controller,
      style: widget.textStyle ?? _defaultStyle.copyWith(color: Colors.black),
      enabled: widget.enabled,
      readOnly: widget.readOnly,
      onChanged: widget.onChanged,
      toolbarOptions: const ToolbarOptions(
        copy: true,
        cut: true,
        paste: true,
        selectAll: true,
      ),
      onTap: () {
        if (_focusNode.canRequestFocus) {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        }
      },
      onEditingComplete: widget.onEditingCompleted,
      decoration: SideSwapInputDecoration(
        hintStyle: widget.hintStyle,
        hintText: widget.hintText,
        errorText: widget.errorText,
        errorStyle: GoogleFonts.roboto(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: const Color(0xFFFF7878),
        ),
        suffixIcon: _emptySuffix
            ? null
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  width: _suffixWidth.w,
                  height: 24.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (widget.onCopyTap != null) ...[
                        SizedBox(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: InkWell(
                            onTap: () {
                              onTapSuffix();
                            },
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/copy.svg',
                                width: _iconWidth.w,
                                height: _iconWidth.w,
                                color: const Color(0xFF00B4E9),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (widget.onPasteTap != null) ...[
                        SizedBox(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: InkWell(
                            onTap: () {
                              onTapSuffix(onTap: widget.onPasteTap);
                            },
                            child: Center(
                              child: Icon(
                                Icons.content_paste,
                                size: _iconWidth.h,
                                color: const Color(0xFF00B4E9),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (widget.onScanTap != null) ...[
                        SizedBox(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (widget.shareEnabled) {
                                  onTapSuffix(onTap: widget.onScanTap);
                                }
                              },
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/qr_icon.svg',
                                  width: _iconWidth.w,
                                  height: _iconWidth.w,
                                  color: const Color(0xFF00B4E9),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                      if (widget.onShareTap != null) ...[
                        SizedBox(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: Builder(
                            builder: (BuildContext context) => InkWell(
                              onTap: widget.onShareTap != null
                                  ? () {
                                      _focusNode.unfocus();
                                      _focusNode.canRequestFocus = false;
                                      if (widget.shareEnabled) {
                                        widget.onShareTap!(context);
                                      }
                                      Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () {
                                        _focusNode.canRequestFocus = true;
                                      });
                                    }
                                  : null,
                              child: Center(
                                child: Icon(
                                  Icons.share,
                                  size: _iconWidth.h,
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
    );
  }
}
