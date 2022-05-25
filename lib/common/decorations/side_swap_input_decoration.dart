import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sideswap/common/screen_utils.dart';

class SideSwapInputDecoration extends InputDecoration {
  const SideSwapInputDecoration({
    super.icon,
    super.labelText,
    super.labelStyle,
    super.helperText,
    super.helperStyle,
    super.helperMaxLines,
    super.hintText,
    super.hintStyle,
    super.hintMaxLines,
    super.errorText,
    super.errorStyle,
    super.errorMaxLines,
    FloatingLabelBehavior super.floatingLabelBehavior = FloatingLabelBehavior.auto,
    super.isCollapsed,
    super.isDense,
    super.contentPadding,
    super.prefixIcon,
    super.prefixIconConstraints,
    super.prefix,
    super.prefixText,
    super.prefixStyle,
    super.suffixIcon,
    super.suffix,
    super.suffixText,
    super.suffixStyle,
    super.suffixIconConstraints,
    super.counter,
    super.counterText,
    super.counterStyle,
    super.filled,
    super.fillColor,
    super.focusColor,
    super.hoverColor,
    super.errorBorder,
    super.focusedBorder,
    super.focusedErrorBorder,
    super.disabledBorder,
    super.enabledBorder,
    super.border,
    super.enabled,
    super.semanticCounterText,
    super.alignLabelWithHint,
  });

  @override
  String get hintText => super.hintText ?? 'Address'.tr();

  @override
  TextStyle get hintStyle =>
      super.hintStyle ??
      GoogleFonts.roboto(
        fontSize: 17.sp,
        fontWeight: FontWeight.normal,
        color: const Color(0xFF84ADC6),
      );

  @override
  Color get fillColor => super.fillColor ?? Colors.white;

  @override
  Color get focusColor => super.focusColor ?? Colors.white;

  @override
  Color get hoverColor => super.hoverColor ?? Colors.white;

  @override
  bool get filled => true;

  @override
  EdgeInsetsGeometry get contentPadding =>
      EdgeInsets.only(left: 16.w, top: 18.h, bottom: 18.h);

  @override
  InputBorder get border =>
      super.border ??
      OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8.w),
        ),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      );

  @override
  InputBorder get focusedBorder =>
      super.focusedBorder ??
      OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
        borderSide: const BorderSide(
          color: Colors.transparent,
        ),
      );
}
