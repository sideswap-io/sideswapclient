import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';

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
    FloatingLabelBehavior super.floatingLabelBehavior =
        FloatingLabelBehavior.auto,
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
      const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.normal,
        color: SideSwapColors.glacier,
      );

  @override
  Color get fillColor => super.fillColor ?? Colors.white;

  @override
  Color get focusColor => super.focusColor ?? Colors.white;

  @override
  Color get hoverColor => super.hoverColor ?? Colors.transparent;

  @override
  bool get filled => true;

  @override
  EdgeInsetsGeometry get contentPadding =>
      const EdgeInsets.only(left: 16, top: 18, bottom: 18);

  @override
  InputBorder get errorBorder =>
      super.border ??
      const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: SideSwapColors.bitterSweet),
      );

  @override
  InputBorder get focusedErrorBorder =>
      super.border ??
      const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: SideSwapColors.bitterSweet),
      );

  @override
  InputBorder get border =>
      super.border ??
      const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.transparent),
      );

  @override
  InputBorder get focusedBorder =>
      super.focusedBorder ??
      const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.transparent),
      );
}
