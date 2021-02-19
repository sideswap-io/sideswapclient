import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/screens/settings/widgets/url_link_button.dart';

class SettingsAboutUs extends StatelessWidget {
  static const String urlWeb = 'https://sideswap.io/';
  static const String urlWebText = 'sideswap.io';
  static const String urlTwitter = 'https://twitter.com/side_swap';
  static const String urlTwitterText = 'twitter.com/side_swap';
  static const String urlGitHub =
      'https://github.com/sideswap-io/sideswapclient';
  static const String urlGithubText = 'github.com/sideswap-io/sideswapclient';
  static const String urlTelegram = 'https://t.me/SideSwap_io';
  static const String urlTelegramText = 't.me/SideSwap_io';

  @override
  Widget build(BuildContext context) {
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
              child: Text(
                'ABOUT_MESSAGE',
                style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                ),
              ).tr(),
            ),
            SizedBox(height: 30),
            Container(
              width: double.maxFinite,
              height: 248.h,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
