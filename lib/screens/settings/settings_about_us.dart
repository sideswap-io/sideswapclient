import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/settings/settings_licenses.dart';
import 'package:sideswap/screens/settings/widgets/url_link_button.dart';

class SettingsAboutUs extends StatelessWidget {
  const SettingsAboutUs({Key? key}) : super(key: key);

  static const String urlWeb = 'https://sideswap.io/';
  static const String urlWebText = 'sideswap.io';
  static const String urlTwitter = 'https://twitter.com/side_swap';
  static const String urlTwitterText = 'twitter.com/side_swap';
  static const String urlGitHub =
      'https://github.com/sideswap-io/sideswapclient';
  static const String urlGithubText = 'github.com/sideswap-io/sideswapclient';
  static const String urlTelegram = 'https://t.me/SideSwap_io';
  static const String urlTelegramText = 't.me/SideSwap_io';
  static const String urlPrivacyPolicy = 'https://sideswap.io/privacy-policy/';
  static const String urlPrivacyPolicyText = 'Privacy Policy';

  void showExportLogMenu(BuildContext context) async {
    final result = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(0, 0, 0, 0),
      items: [
        const PopupMenuItem<int>(
          value: 1,
          child: Text('Export log'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('Export previous log'),
        ),
      ],
    );
    if (result == 1) {
      shareLogFile("sideswap.log");
    } else if (result == 2) {
      shareLogFile("sideswap_prev.log");
    }
  }

  @override
  Widget build(BuildContext context) {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'About us'.tr(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 90.h),
              child: FutureBuilder<void>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final packageInfo = snapshot.data as PackageInfo;
                    return GestureDetector(
                      onLongPress: () {
                        showExportLogMenu(context);
                      },
                      child: Text(
                        'VERSION'.tr(args: [packageInfo.version]),
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF00C5FF),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UrlLinkButton(
                    url: urlWeb,
                    text: urlWebText,
                    icon: SvgPicture.asset(
                      'assets/web_icon.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                  UrlLinkButton(
                    url: urlGitHub,
                    text: urlGithubText,
                    icon: SvgPicture.asset(
                      'assets/github_icon.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                  UrlLinkButton(
                    url: urlTwitter,
                    text: urlTwitterText,
                    icon: SvgPicture.asset(
                      'assets/twitter_icon.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                  UrlLinkButton(
                    url: urlTelegram,
                    text: urlTelegramText,
                    icon: SvgPicture.asset(
                      'assets/telegram_icon.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                  UrlLinkButton(
                    text: 'Licenses',
                    icon: Icon(
                      Icons.copyright,
                      size: 24.w,
                    ),
                    onPressed: () {
                      Navigator.of(context).push<void>(
                        MaterialPageRoute(
                          builder: (context) => const SettingsLicenses(),
                        ),
                      );
                    },
                  ),
                  UrlLinkButton(
                    url: urlPrivacyPolicy,
                    text: urlPrivacyPolicyText,
                    icon: SvgPicture.asset(
                      'assets/web_icon.svg',
                      width: 24.w,
                      height: 24.w,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
