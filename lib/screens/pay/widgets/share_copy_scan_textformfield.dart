import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/decorations/side_swap_input_decoration.dart';
import 'package:sideswap/common/screen_utils.dart';

typedef ShareTapCallback = void Function(BuildContext context);

class ShareCopyScanTextFormField extends StatefulWidget {
  ShareCopyScanTextFormField({
    Key key,
    GlobalKey<FormFieldState> textFormFieldKey,
    FocusNode focusNode,
    TextEditingController controller,
    TextStyle textStyle,
    TextStyle hintStyle,
    String hintText,
    String errorText,
    VoidCallback onCopyTap,
    bool shareEnabled = true,
    ShareTapCallback onShareTap,
    VoidCallback onScanTap,
    VoidCallback onPasteTap,
    bool enabled = true,
    bool readOnly = false,
    void Function(String) onChanged,
    VoidCallback onTap,
    VoidCallback onEditingCompleted,
  })  : _textFormFieldKey = textFormFieldKey,
        _focusNode = focusNode,
        _controller = controller,
        _textStyle = textStyle,
        _hintStyle = hintStyle,
        _hintText = hintText,
        _errorText = errorText,
        _onCopyTap = onCopyTap,
        _shareEnabled = shareEnabled,
        _onShareTap = onShareTap,
        _onScanTap = onScanTap,
        _onPasteTap = onPasteTap,
        _enabled = enabled,
        _readOnly = readOnly,
        _onChanged = onChanged,
        _onTap = onTap,
        _onEditingCompleted = onEditingCompleted,
        super(key: key);

  final GlobalKey<FormFieldState> _textFormFieldKey;
  final FocusNode _focusNode;
  final TextEditingController _controller;
  final TextStyle _textStyle;
  final TextStyle _hintStyle;
  final String _hintText;
  final String _errorText;
  final VoidCallback _onCopyTap;
  final bool _shareEnabled;
  final ShareTapCallback _onShareTap;
  final VoidCallback _onScanTap;
  final VoidCallback _onPasteTap;
  final bool _enabled;
  final bool _readOnly;
  final Function(String) _onChanged;
  final VoidCallback _onTap;
  final VoidCallback _onEditingCompleted;

  @override
  _ShareCopyScanTextFormFieldState createState() =>
      _ShareCopyScanTextFormFieldState();
}

class _ShareCopyScanTextFormFieldState
    extends State<ShareCopyScanTextFormField> {
  final _spaceBetween = 4;
  final _iconWidth = 24;

  FocusNode _focusNode;
  bool _emptySuffix = false;
  final TextStyle _defaultStyle = GoogleFonts.roboto(
    fontSize: 17.sp,
    fontWeight: FontWeight.normal,
    color: Color(0xFF84ADC6),
  );

  @override
  void initState() {
    super.initState();

    if (widget._onCopyTap == null &&
        widget._onPasteTap == null &&
        widget._onScanTap == null &&
        widget._onShareTap == null) {
      _emptySuffix = true;
    }

    _focusNode = widget._focusNode ?? FocusNode();
  }

  void onTapSuffix(VoidCallback onTap) {
    _focusNode.unfocus();
    _focusNode.canRequestFocus = false;
    widget._controller.clear();

    if (onTap != null) {
      onTap();
    }

    Future.delayed(Duration(milliseconds: 100), () {
      _focusNode.canRequestFocus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _suffixCounter = 0;
    if (widget._onCopyTap != null) {
      _suffixCounter++;
    }
    if (widget._onShareTap != null) {
      _suffixCounter++;
    }
    if (widget._onScanTap != null) {
      _suffixCounter++;
    }
    if (widget._onPasteTap != null) {
      _suffixCounter++;
    }

    final _gestureAreaWidth = _spaceBetween * 2 + _iconWidth;
    final _suffixWidth = _suffixCounter * _gestureAreaWidth;

    return TextField(
      key: widget._textFormFieldKey,
      focusNode: _focusNode,
      controller: widget._controller,
      style: widget._textStyle ?? _defaultStyle.copyWith(color: Colors.black),
      enabled: widget._enabled,
      readOnly: widget._readOnly,
      onChanged: widget._onChanged,
      toolbarOptions: ToolbarOptions(
        copy: true,
        cut: true,
        paste: true,
        selectAll: true,
      ),
      onTap: () {
        if (_focusNode.canRequestFocus) {
          widget._onTap();
        }
      },
      onEditingComplete: widget._onEditingCompleted,
      decoration: SideSwapInputDecoration(
        hintStyle: widget._hintStyle,
        hintText: widget._hintText,
        errorText: widget._errorText,
        errorStyle: GoogleFonts.roboto(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          color: Color(0xFFFF7878),
        ),
        suffixIcon: _emptySuffix
            ? null
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  width: _suffixWidth.w,
                  height: 24.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (widget._onCopyTap != null) ...[
                        Container(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: InkWell(
                            onTap: () {
                              onTapSuffix(widget._onCopyTap);
                            },
                            child: Center(
                              child: SvgPicture.asset(
                                'assets/copy.svg',
                                width: _iconWidth.w,
                                height: _iconWidth.w,
                                color: Color(0xFF00B4E9),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (widget._onPasteTap != null) ...[
                        Container(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: InkWell(
                            onTap: () {
                              onTapSuffix(widget._onPasteTap);
                            },
                            child: Center(
                              child: Icon(
                                Icons.content_paste,
                                size: _iconWidth.h,
                                color: Color(0xFF00B4E9),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (widget._onScanTap != null) ...[
                        Container(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                if (widget._shareEnabled) {
                                  onTapSuffix(widget._onScanTap);
                                }
                              },
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/qr_icon.svg',
                                  width: _iconWidth.w,
                                  height: _iconWidth.w,
                                  color: Color(0xFF00B4E9),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                      if (widget._onShareTap != null) ...[
                        Container(
                          width: _gestureAreaWidth.w,
                          height: double.maxFinite,
                          child: Builder(
                            builder: (BuildContext context) => InkWell(
                              onTap: () {
                                _focusNode.unfocus();
                                _focusNode.canRequestFocus = false;
                                if (widget._shareEnabled) {
                                  widget._onShareTap(context);
                                }
                                Future.delayed(Duration(milliseconds: 100), () {
                                  _focusNode.canRequestFocus = true;
                                });
                              },
                              child: Center(
                                child: Icon(
                                  Icons.share,
                                  size: _iconWidth.h,
                                  color: widget._shareEnabled
                                      ? Color(0xFF00B4E9)
                                      : Color(0xFFA5A9AF),
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
