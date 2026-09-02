import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/desktop/widgets/d_scroll_when_short.dart';

part 'd_popup_with_close.freezed.dart';

@freezed
sealed class DialogReturnValue with _$DialogReturnValue {
  const factory DialogReturnValue.cancelled() = DialogReturnValueCancelled;
  const factory DialogReturnValue.accepted() = DialogReturnValueAccepted;
}

class DPopupWithClose extends StatelessWidget {
  const DPopupWithClose({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.onClose,
    this.alignment = AlignmentDirectional.topStart,
  });

  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onClose;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final barrierDismissible =
        ModalRoute.of(context)?.barrierDismissible ?? false;

    return switch (barrierDismissible) {
      true => DPopupWithCloseContent(
        width: width,
        height: height,
        onClose: onClose,
        alignment: alignment,
        child: child,
      ),
      _ => Scaffold(
        body: DPopupWithCloseContent(
          width: width,
          height: height,
          onClose: onClose,
          alignment: alignment,
          child: child,
        ),
      ),
    };
  }
}

class DPopupWithCloseContent extends StatelessWidget {
  const DPopupWithCloseContent({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.onClose,
    this.alignment = AlignmentDirectional.topStart,
  });

  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onClose;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    final closeButton = DIconButton(
      icon: const Icon(Icons.close, color: SideSwapColors.freshAir, size: 18),
      onPressed: switch (onClose) {
        final onClose? => onClose,
        _ => () {
          Navigator.pop(context);
        },
      },
    );

    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: SideSwapColors.blumine,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: switch (height) {
              // A popup with a design height is laid out at that height and
              // scrolls when the window is shorter, instead of clipping its
              // bottom. The close button stays in the popup's corner.
              final height? => Stack(
                alignment: alignment,
                children: [
                  DScrollWhenShort(height: height, child: child),
                  Positioned(top: 20, right: 20, child: closeButton),
                ],
              ),
              _ => Stack(
                alignment: alignment,
                children: [
                  child,
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: closeButton,
                    ),
                  ),
                ],
              ),
            },
          ),
        ),
      ),
    );
  }
}
