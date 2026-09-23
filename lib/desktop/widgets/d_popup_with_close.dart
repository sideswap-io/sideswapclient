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
    this.actions,
    this.scrollOwner = ScrollOwner.wrapper,
  });

  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onClose;
  final AlignmentGeometry alignment;

  /// The popup's action, laid out below [child] and outside the scroll region.
  ///
  /// It is *pinned* -- visible however short the window is -- because [child]
  /// carries the `Flexible` that yields the shortfall.
  ///
  /// The body is laid out in a column, so [alignment] places that column
  /// rather than the body itself; a surface that needs a non-default
  /// horizontal placement aligns inside its own [child].
  final Widget? actions;

  /// Which widget owns this surface's scrollable. Under [ScrollOwner.wrapper]
  /// and [ScrollOwner.child] the [child] becomes flexible while [actions]
  /// stays unflexed.
  final ScrollOwner scrollOwner;

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
        actions: actions,
        scrollOwner: scrollOwner,
        child: child,
      ),
      _ => Scaffold(
        body: DPopupWithCloseContent(
          width: width,
          height: height,
          onClose: onClose,
          alignment: alignment,
          actions: actions,
          scrollOwner: scrollOwner,
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
    this.actions,
    this.scrollOwner = ScrollOwner.wrapper,
  });

  final Widget child;
  final double? width;
  final double? height;
  final VoidCallback? onClose;
  final AlignmentGeometry alignment;

  /// The popup's action, laid out below [child] and outside the scroll region.
  ///
  /// It is *pinned* -- visible however short the window is -- because [child]
  /// carries the `Flexible` that yields the shortfall.
  ///
  /// The body is laid out in a column, so [alignment] places that column
  /// rather than the body itself; a surface that needs a non-default
  /// horizontal placement aligns inside its own [child].
  final Widget? actions;

  /// Which widget owns this surface's scrollable.
  final ScrollOwner scrollOwner;

  @override
  Widget build(BuildContext context) {
    final closeButton = DIconButton(
      icon: const Icon(Icons.close, color: SideSwapColors.freshAir, size: 18),
      onPressed:
          onClose ??
          () {
            Navigator.pop(context);
          },
    );

    // The body as it sits in the column: `wrapper` adds both halves of the
    // contract, `child` supplies the `Flexible` only and leaves the scrollable
    // to the content.
    final columnBody = Flexible(
      fit: FlexFit.loose,
      child: switch (scrollOwner) {
        ScrollOwner.wrapper => SingleChildScrollView(
          primary: false,
          child: child,
        ),
        ScrollOwner.child => child,
      },
    );

    final stackBody = Column(
      mainAxisSize: MainAxisSize.min,
      children: [columnBody, ?actions],
    );

    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(8),
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
              alignment: alignment,
              children: [
                stackBody,
                // Positioned rather than an Align that expands to fill the
                // popup, so the close button cannot claim the popup's size.
                Positioned(top: 20, right: 20, child: closeButton),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
