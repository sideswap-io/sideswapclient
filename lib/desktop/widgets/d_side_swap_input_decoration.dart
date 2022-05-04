import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/desktop/widgets/d_transparent_button.dart';

class DSideSwapInputDecoration extends InputDecoration {
  DSideSwapInputDecoration({
    String? hintText,
    String? errorText,
    VoidCallback? onPastePressed,
  }) : super(
          hintText: hintText,
          errorText: errorText,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF84ADC6),
          ),
          errorStyle: const TextStyle(
            fontSize: 14,
            color: Color(0xFFFF5555),
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          contentPadding:
              EdgeInsets.fromLTRB(16, 16, onPastePressed == null ? 16 : 0, 16),
          fillColor: Colors.white,
          focusColor: Colors.white,
          hoverColor: Colors.white,
          filled: true,
          suffixIcon: onPastePressed == null
              ? null
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.basic,
                      child: DTransparentButton(
                        child: SvgPicture.asset(
                          'assets/paste.svg',
                          width: 20,
                          height: 20,
                          color: const Color(0xFF135579),
                        ),
                        onPressed: onPastePressed,
                      ),
                    ),
                  ],
                ),
        );
}
