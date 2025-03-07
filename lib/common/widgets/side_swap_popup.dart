import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_back_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';

class SideSwapPopup extends ConsumerWidget {
  const SideSwapPopup({
    super.key,
    required this.child,
    this.appBar,
    Color? backgroundColor,
    this.enableInsideTopPadding = true,
    this.enableInsideHorizontalPadding = true,
    this.onClose,
    this.canPop,
    this.onPopInvokedWithResult,
    this.hideCloseButton = false,
    this.padding = EdgeInsets.zero,
    this.sideSwapBackground = true,
    this.backgroundCoverColor,
    this.extendBodyBehindAppBar = false,
    this.persistentFooterButtons,
    this.bottomNavigationBar,
    this.bottomSheet,
  }) : _backgroundColor = backgroundColor ?? SideSwapColors.blumine;

  final Widget? child;
  final AppBar? appBar;
  final Color _backgroundColor;
  final bool enableInsideTopPadding;
  final bool enableInsideHorizontalPadding;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onClose;
  final bool? canPop;
  final PopInvokedWithResultCallback<dynamic>? onPopInvokedWithResult;
  final bool hideCloseButton;
  final bool sideSwapBackground;
  final Color? backgroundCoverColor;
  final bool extendBodyBehindAppBar;
  final List<Widget>? persistentFooterButtons;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SideSwapScaffold(
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      sideSwapBackground: sideSwapBackground,
      backgroundColor: backgroundCoverColor,
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      appBar: appBar,
      persistentFooterButtons: persistentFooterButtons,
      bottomNavigationBar: bottomNavigationBar,
      bottomSheet: bottomSheet,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: _backgroundColor,
              ),
              child: SizedBox(
                height: screenHeight + padding.collapsedSize.height + 10,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: enableInsideHorizontalPadding ? 16 : 0,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: enableInsideTopPadding ? 28 : 0,
                        ),
                        child: child,
                      ),
                    ),
                    if (!hideCloseButton) ...[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: enableInsideTopPadding ? 25 : 0,
                            right: 22,
                          ),
                          child: CustomBackButton(
                            onPressed: () {
                              if (onClose != null) {
                                onClose!();
                              } else {
                                ref.read(walletProvider).goBack();
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
