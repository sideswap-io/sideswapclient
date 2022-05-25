import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/screen_utils.dart';

class SideSwapTextField extends StatefulWidget {
  const SideSwapTextField({
    super.key,
    this.errorText,
    this.controller,
    this.focusNode,
    this.hintStyle,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
  });

  final String? errorText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextStyle? hintStyle;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  @override
  SideSwapTextFieldState createState() => SideSwapTextFieldState();
}

class SideSwapTextFieldState extends State<SideSwapTextField> {
  late TextStyle hintStyle;

  @override
  void initState() {
    super.initState();
    hintStyle = widget.hintStyle ??
        GoogleFonts.roboto(
          fontSize: 17.sp,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF84ADC6),
        );
  }

  @override
  Widget build(BuildContext context) {
    InputBorder? focusedBorder;
    if (widget.errorText != null && widget.errorText!.isNotEmpty) {
      focusedBorder = OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      );
    }
    return TextField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      showCursor: true,
      cursorColor: Colors.black,
      cursorHeight: 20.h,
      style: GoogleFonts.roboto(
        fontSize: 16.sp,
        fontWeight: FontWeight.normal,
        color: Colors.black,
      ),
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(10.w, 18.h, 10.w, 18.h),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: focusedBorder,
        suffixIcon: widget.suffixIcon,
      ),
    );
  }
}
