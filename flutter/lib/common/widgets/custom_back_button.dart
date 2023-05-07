import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/providers/wallet.dart';

enum CustomBackButtonType {
  backArrow,
  close,
}

class CustomBackButton extends ConsumerStatefulWidget {
  const CustomBackButton({
    super.key,
    this.onPressed,
    this.buttonType = CustomBackButtonType.backArrow,
    this.width,
    this.height,
    this.color = SideSwapColors.freshAir,
  });

  final void Function()? onPressed;
  final CustomBackButtonType buttonType;
  final double? width;
  final double? height;
  final Color color;

  @override
  CustomBackButtonState createState() => CustomBackButtonState();
}

class CustomBackButtonState extends ConsumerState<CustomBackButton> {
  double _width = 0;
  double _height = 0;
  final double _padding = 16;

  @override
  void initState() {
    super.initState();

    _width = widget.width ?? 28;
    _height = widget.height ?? 28;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: widget.buttonType == CustomBackButtonType.backArrow ? 5 : 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(_width + _padding / 2),
          onTap: widget.onPressed ??
              () {
                FocusManager.instance.primaryFocus?.unfocus();
                ref.read(walletProvider).goBack();
              },
          child: Container(
            width: _width + _padding,
            height: _height + _padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_width + _padding / 2),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.buttonType == CustomBackButtonType.backArrow) ...[
                    SvgPicture.asset(
                      'assets/back_arrow.svg',
                      width: (_width * 42.85) / 100,
                      height: (_height * 71.42) / 100,
                      colorFilter:
                          ColorFilter.mode(widget.color, BlendMode.srcIn),
                    ),
                  ],
                  if (widget.buttonType == CustomBackButtonType.close) ...[
                    SvgPicture.asset(
                      'assets/close.svg',
                      width: _width,
                      height: _height,
                      colorFilter:
                          ColorFilter.mode(widget.color, BlendMode.srcIn),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
