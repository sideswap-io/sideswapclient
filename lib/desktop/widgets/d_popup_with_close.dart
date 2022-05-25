import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';

class DPopupWithClose extends StatelessWidget {
  const DPopupWithClose({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.onClose,
  });

  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: const Color(0xFF1C6086),
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              child,
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: DIconButton(
                    icon: SvgPicture.asset(
                      'assets/close2.svg',
                      width: 18,
                      height: 18,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      if (onClose != null) {
                        onClose!();
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
