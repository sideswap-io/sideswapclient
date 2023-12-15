import 'package:flutter/material.dart';
import 'package:sideswap/common/sideswap_colors.dart';
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
    return Scaffold(
      body: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SideSwapColors.blumine,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                child,
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: DIconButton(
                      icon: const Icon(
                        Icons.close,
                        color: SideSwapColors.freshAir,
                        size: 18,
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
      ),
    );
  }
}
