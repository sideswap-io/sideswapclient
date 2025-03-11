import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/widgets/d_transparent_button.dart';

class DSideSwapPasteIconInputDecoration extends InputDecoration {
  DSideSwapPasteIconInputDecoration({
    super.hintText,
    super.errorText,
    VoidCallback? onPastePressed,
  }) : super(
         hintStyle: const TextStyle(
           fontSize: 16,
           fontWeight: FontWeight.normal,
           color: SideSwapColors.glacier,
         ),
         errorStyle: const TextStyle(
           fontSize: 14,
           color: SideSwapColors.bitterSweet,
         ),
         border: const OutlineInputBorder(
           borderRadius: BorderRadius.all(Radius.circular(8)),
           borderSide: BorderSide(color: Colors.transparent),
         ),
         focusedBorder: const OutlineInputBorder(
           borderRadius: BorderRadius.all(Radius.circular(8)),
           borderSide: BorderSide(color: Colors.transparent),
         ),
         contentPadding: EdgeInsets.fromLTRB(
           16,
           16,
           onPastePressed == null ? 16 : 0,
           16,
         ),
         fillColor: Colors.white,
         errorBorder: const OutlineInputBorder(
           borderSide: BorderSide(color: SideSwapColors.bitterSweet),
         ),
         filled: true,
         suffixIcon: switch (onPastePressed) {
           final onPastePressed? => Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               MouseRegion(
                 cursor: SystemMouseCursors.basic,
                 child: DTransparentButton(
                   onPressed: onPastePressed,
                   child: SvgPicture.asset(
                     'assets/paste.svg',
                     width: 20,
                     height: 20,
                     colorFilter: const ColorFilter.mode(
                       SideSwapColors.chathamsBlue,
                       BlendMode.srcIn,
                     ),
                   ),
                 ),
               ),
             ],
           ),
           _ => null,
         },
       );
}
