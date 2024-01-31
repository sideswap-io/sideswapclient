import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_custom_text_big_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link_button.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog.dart';
import 'package:sideswap/desktop/common/dialog/d_content_dialog_theme.dart';
import 'package:sideswap/desktop/settings/d_settings_licenses.dart';
import 'package:sideswap/desktop/theme.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/settings/settings_about_us.dart';

class DSettingsAboutUs extends HookConsumerWidget {
  const DSettingsAboutUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsDialogTheme =
        ref.watch(desktopAppThemeNotifierProvider).settingsDialogTheme;

    return WillPopScope(
      onWillPop: () async {
        ref.read(walletProvider).goBack();
        return false;
      },
      child: DContentDialog(
        title: DContentDialogTitle(
          content: Text('About us'.tr()),
          onClose: () {
            ref.read(walletProvider).goBack();
          },
        ),
        content: Center(
          child: SizedBox(
            height: 506,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: GestureDetector(
                      onLongPress: () {
                        // showExportLogMenu(context);
                      },
                      child: Text(
                        'VERSION'.tr(args: [appVersion]),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: SideSwapColors.brightTurquoise,
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: DUrlLinkButton(
                      url: SettingsAboutUsData.urlWeb,
                      text: SettingsAboutUsData.urlWebText,
                      icon: 'assets/web_icon.svg',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: DUrlLinkButton(
                      url: SettingsAboutUsData.urlGitHub,
                      text: SettingsAboutUsData.urlGithubText,
                      icon: 'assets/github_icon.svg',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: DUrlLinkButton(
                      url: SettingsAboutUsData.urlTwitter,
                      text: SettingsAboutUsData.urlTwitterText,
                      icon: 'assets/twitter_icon.svg',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: DUrlLinkButton(
                      url: SettingsAboutUsData.urlTelegram,
                      text: SettingsAboutUsData.urlTelegramText,
                      icon: 'assets/telegram_icon.svg',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: DUrlLinkButton(
                      text: 'Licenses'.tr(),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            RawDialogRoute<Widget>(
                              pageBuilder: (_, __, ___) =>
                                  const DSettingsLicenses(),
                            ),
                            (route) => route.isFirst);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: DUrlLinkButton(
                      url: SettingsAboutUsData.urlPrivacyPolicy,
                      text: 'Privacy Policy'.tr(),
                      icon: 'assets/web_icon.svg',
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        actions: [
          Center(
            child: DCustomTextBigButton(
              width: 266,
              onPressed: () {
                ref.read(walletProvider).goBack();
              },
              child: Text(
                'BACK'.tr(),
              ),
            ),
          ),
        ],
        style: const DContentDialogThemeData().merge(settingsDialogTheme),
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 693),
      ),
    );
  }
}
