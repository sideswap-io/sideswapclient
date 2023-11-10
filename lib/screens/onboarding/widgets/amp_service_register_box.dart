import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/desktop/common/button/d_button_theme.dart';
import 'package:sideswap/desktop/common/button/d_custom_filled_big_button.dart';
import 'package:sideswap/desktop/common/button/d_hover_button.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/onboarding/widgets/amp_securities_list.dart';
import 'package:sideswap/screens/onboarding/widgets/success_icon.dart';

class AmpServiceRegisterBox extends HookConsumerWidget {
  const AmpServiceRegisterBox({
    super.key,
    this.onPressed,
    required this.items,
    required this.boxLogo,
    required this.registered,
    this.width = 285,
    this.height = 333,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    this.loading = false,
  });

  final VoidCallback? onPressed;
  final List<SecuritiesItem> items;
  final String boxLogo;
  final bool registered;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;
  final bool loading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: SideSwapColors.smaltBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              boxLogo,
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: AmpSecuritiesList(
                items: items,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 17),
              child: FlavorConfig.isDesktop
                  ? AmpDesktopRegisterButton(
                      registered: registered,
                      onPressed: loading ? null : onPressed,
                      child: AmpRegisterButtonBody(
                        registered: registered,
                        loading: loading,
                      ),
                    )
                  : AmpMobileRegisterButton(
                      registered: registered,
                      onPressed: loading ? null : onPressed,
                      child: AmpRegisterButtonBody(
                        registered: registered,
                        loading: loading,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}

class AmpRegisterButtonBody extends StatelessWidget {
  const AmpRegisterButtonBody({
    super.key,
    required this.registered,
    this.loading = false,
  });

  final bool registered;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Text(
            'CHECKING...'.tr(),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          )
        : registered
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (FlavorConfig.isDesktop) ...[
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: SuccessIcon(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: SideSwapColors.turquoise,
                        ),
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    'REGISTERED'.tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )
                ],
              )
            : Text(
                'REGISTER'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              );
  }
}

class AmpDesktopRegisterButton extends HookConsumerWidget {
  const AmpDesktopRegisterButton({
    super.key,
    this.onPressed,
    required this.registered,
    required this.child,
  });

  final VoidCallback? onPressed;
  final bool registered;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonThemes = ref.watch(desktopAppThemeProvider).buttonThemeData;

    return DCustomFilledBigButton(
      width: 253,
      height: 44,
      onPressed: onPressed,
      style: registered
          ? buttonThemes.filledButtonStyle?.merge(
              DButtonStyle(
                backgroundColor: ButtonState.all<Color>(
                  SideSwapColors.tarawera,
                ),
                border: ButtonState.all<BorderSide>(
                  const BorderSide(
                    color: SideSwapColors.turquoise,
                  ),
                ),
              ),
            )
          : buttonThemes.filledButtonStyle,
      child: child,
    );
  }
}

class AmpMobileRegisterButton extends StatelessWidget {
  const AmpMobileRegisterButton({
    super.key,
    this.onPressed,
    required this.registered,
    required this.child,
  });

  final VoidCallback? onPressed;
  final bool registered;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomBigButton(
      width: 146,
      height: 44,
      onPressed: onPressed,
      backgroundColor:
          registered ? SideSwapColors.tarawera : SideSwapColors.brightTurquoise,
      side: const BorderSide(color: SideSwapColors.turquoise, width: 1),
      child: child,
    );
  }
}
