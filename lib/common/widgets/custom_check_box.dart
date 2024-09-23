import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_button.dart';
import 'package:sideswap/desktop/theme.dart';

class CustomCheckBox extends HookConsumerWidget {
  const CustomCheckBox({
    super.key,
    this.onChecked,
    this.icon,
    this.size,
    this.iconSize,
    this.radius,
    this.frameChecked = SideSwapColors.brightTurquoise,
    this.frameUnchecked = SideSwapColors.ceruleanFrost,
    this.backgroundChecked = SideSwapColors.brightTurquoise,
    this.backgroundUnchecked = SideSwapColors.blumine,
    this.value = false,
    this.enabled = true,
  });

  final ValueChanged<bool>? onChecked;
  final Widget? icon;
  final double? size;
  final double? iconSize;
  final Radius? radius;
  final Color frameChecked;
  final Color frameUnchecked;
  final Color backgroundChecked;
  final Color backgroundUnchecked;
  final bool value;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final frameColorController =
        useAnimationController(duration: const Duration(microseconds: 200));
    final frameColorCurve = useMemoized(() =>
        CurvedAnimation(parent: frameColorController, curve: Curves.easeOut));
    final frameColorAnimation = useAnimation(
        ColorTween(begin: frameUnchecked, end: frameChecked)
            .animate(frameColorCurve));

    final backgroundColorController =
        useAnimationController(duration: const Duration(milliseconds: 200));
    final backgroundColorCurve = useMemoized(() => CurvedAnimation(
        parent: backgroundColorController, curve: Curves.easeOut));
    final backgroundColorAnimation = useAnimation(
        ColorTween(begin: backgroundUnchecked, end: backgroundChecked)
            .animate(backgroundColorCurve));

    final fadeController =
        useAnimationController(duration: const Duration(milliseconds: 200));
    final fadeCurve = useMemoized(
        () => CurvedAnimation(parent: fadeController, curve: Curves.easeOut));
    final fadeAnimation =
        useAnimation(Tween(begin: 0.0, end: 1.0).animate(fadeCurve));

    useEffect(() {
      if (value) {
        frameColorController.forward();
        backgroundColorController.forward();
        fadeController.forward();
        return;
      }

      frameColorController.reverse();
      backgroundColorController.reverse();
      fadeController.reverse();

      return;
    }, [value]);

    final buttonStyle = ref
        .watch(desktopAppThemeNotifierProvider)
        .mainBottomNavigationBarButtonStyle;

    return DButton(
      style: buttonStyle,
      onPressed: enabled
          ? () {
              onChecked?.call(!value);
            }
          : null,
      child: Center(
        child: Container(
          width: size ?? 18,
          height: size ?? 18,
          decoration: BoxDecoration(
            border: Border.all(
              color: enabled
                  ? frameColorAnimation ?? Colors.transparent
                  : SideSwapColors.cornFlower,
            ),
            borderRadius: BorderRadius.all(
              radius ?? const Radius.circular(6),
            ),
            color: enabled
                ? backgroundColorAnimation ?? Colors.transparent
                : Colors.transparent,
          ),
          child: Center(
            child: Opacity(
              opacity: fadeAnimation,
              child: icon ??
                  Icon(
                    Icons.check,
                    size: iconSize ?? 13,
                    color: enabled ? Colors.white : SideSwapColors.cornFlower,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
