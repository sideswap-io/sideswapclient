import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/custom_scrollable_container.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/screens/settings/settings_licenses.dart';
import 'package:sideswap/screens/settings/widgets/url_link_button.dart';

class SettingsAboutUsData {
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
  static const String urlFaq = 'https://sideswap.io/faq/';
}

class SettingsAboutUs extends StatelessWidget {
  const SettingsAboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'About us'.tr(),
      ),
      body: SafeArea(
        child: CustomScrollableContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'VERSION: {}'.tr(args: [appVersion]),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UrlLinkButton(
                        url: SettingsAboutUsData.urlWeb,
                        text: SettingsAboutUsData.urlWebText,
                        icon: SvgPicture.asset(
                          'assets/web_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      UrlLinkButton(
                        url: SettingsAboutUsData.urlGitHub,
                        text: SettingsAboutUsData.urlGithubText,
                        icon: SvgPicture.asset(
                          'assets/github_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      UrlLinkButton(
                        url: SettingsAboutUsData.urlTwitter,
                        text: SettingsAboutUsData.urlTwitterText,
                        icon: SvgPicture.asset(
                          'assets/twitter_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      UrlLinkButton(
                        url: SettingsAboutUsData.urlTelegram,
                        text: SettingsAboutUsData.urlTelegramText,
                        icon: SvgPicture.asset(
                          'assets/telegram_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                      UrlLinkButton(
                        text: 'Licenses',
                        icon: const Icon(
                          Icons.copyright,
                          size: 24,
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
                        url: SettingsAboutUsData.urlPrivacyPolicy,
                        text: 'Privacy Policy'.tr(),
                        icon: SvgPicture.asset(
                          'assets/web_icon.svg',
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
