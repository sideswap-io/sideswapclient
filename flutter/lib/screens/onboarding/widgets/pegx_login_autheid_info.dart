import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PegxLoginAutheIDInfo extends StatelessWidget {
  const PegxLoginAutheIDInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: SideSwapColors.chathamsBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: SvgPicture.asset(
                  'assets/autheid_logo.svg',
                  width: 64,
                  height: 64,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 14, bottom: 24, left: 48, right: 48),
                child: Text(
                  'To register AMP ID with PEGx, you will need an Auth eID app'
                      .tr(),
                  style: textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: SideSwapColors.tarawera,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 21, left: 70, right: 70),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Don\'t have the Auth eID App? '.tr(),
                    style: textTheme.bodyMedium?.copyWith(fontSize: 14),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 21),
                child: RichText(
                  text: TextSpan(
                    text: 'Get started here'.tr(),
                    style: textTheme.bodyMedium?.merge(
                      const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => openUrl('https://autheid.com/',
                          mode: LaunchMode.externalNonBrowserApplication),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
