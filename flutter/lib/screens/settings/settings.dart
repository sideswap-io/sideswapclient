import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/custom_scrollable_container.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/biometric_available_provider.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/settings_about_us.dart';
import 'package:sideswap/screens/settings/settings_languages.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';
import 'package:sideswap/screens/settings/widgets/settings_delete_wallet_dialog.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends ConsumerState<Settings> {
  bool isBiometricAvailable = false;

  @override
  void initState() {
    Future.microtask(() async {
      isBiometricAvailable =
          await ref.read(walletProvider).isBiometricAvailable();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'Settings'.tr(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomScrollableContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: SettingsLogoWithAppVersion(),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final ampId = ref.watch(ampIdProvider);
                    final textTheme = Theme.of(context).textTheme;

                    return AmpIdPanel(
                      width: double.infinity,
                      height: 60,
                      ampId: ampId,
                      backgroundColor: SideSwapColors.chathamsBlue,
                      prefixTextStyle: textTheme.titleSmall?.merge(
                        const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: SideSwapColors.brightTurquoise),
                      ),
                      onTap: () {
                        ref
                            .read(pageStatusStateProvider.notifier)
                            .setStatus(Status.ampRegister);
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SettingsButton(
                    type: SettingsButtonType.recovery,
                    text: 'View my recovery phrase'.tr(),
                    onPressed: () {
                      ref.read(walletProvider).settingsViewBackup();
                    },
                  ),
                ),
                if (FlavorConfig.isProduction &&
                    FlavorConfig.enableOnboardingUserFeatures) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SettingsButton(
                      type: SettingsButtonType.userDetails,
                      text: 'User details'.tr(),
                      onPressed: () {
                        ref.read(walletProvider).settingsUserDetails();
                      },
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SettingsButton(
                    type: SettingsButtonType.about,
                    text: 'About us'.tr(),
                    onPressed: () {
                      ref.read(walletProvider).settingsViewAboutUs();
                    },
                  ),
                ),
                Consumer(
                  builder: (context, ref, _) {
                    ref
                        .watch(walletProvider)
                        .isBiometricAvailable()
                        .then((value) {
                      setState(() {
                        isBiometricAvailable = value;
                      });
                    });

                    final isBiometricEnabled =
                        ref.watch(biometricAvailableProvider);
                    final isPinEnabled = ref.watch(pinAvailableProvider);

                    return Column(
                      children: [
                        Visibility(
                          visible: isBiometricAvailable,
                          child: SettingsSecurity(
                            icon: Icons.fingerprint,
                            description: 'Biometric protection'.tr(),
                            value: isBiometricEnabled,
                            onTap: () async {
                              if (isBiometricEnabled) {
                                await ref
                                    .read(walletProvider)
                                    .settingsDisableBiometric();
                              } else {
                                // disable pin to be sure!
                                // pin could be enabled when biometric is unavailable
                                // but in the mean time biometric could be enabled in device settings
                                // then we need to display in settings both options
                                if (await ref
                                    .read(walletProvider)
                                    .disablePinProtection()) {
                                  await ref
                                      .read(walletProvider)
                                      .settingsEnableBiometric();
                                }
                              }
                            },
                          ),
                        ),
                        SettingsSecurity(
                          icon: Icons.fiber_pin_outlined,
                          description: 'PIN protection'.tr(),
                          value: isPinEnabled,
                          onTap: () async {
                            if (isPinEnabled) {
                              await ref
                                  .read(walletProvider)
                                  .disablePinProtection();
                            } else {
                              ref.read(pinSetupProvider).initPinSetupSettings();
                            }
                          },
                        ),
                      ],
                    );
                  },
                ),
                if (FlavorConfig.enableNetworkSettings) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SettingsButton(
                      type: SettingsButtonType.network,
                      text: 'Network access'.tr(),
                      onPressed: () {
                        ref.read(walletProvider).settingsNetwork();
                      },
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SettingsButton(
                    type: SettingsButtonType.language,
                    text: 'Language'.tr(),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push<void>(
                          DialogRoute(
                              builder: ((context) => const Languages()),
                              context: context));
                    },
                  ),
                ),
                const Spacer(),
                const SizedBox(height: 16),
                SettingsButton(
                  type: SettingsButtonType.delete,
                  text: 'Delete wallet'.tr(),
                  transparent: true,
                  onPressed: () {
                    showDeleteWalletDialog(context);
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingsLogoWithAppVersion extends StatelessWidget {
  const SettingsLogoWithAppVersion({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: SideSwapColors.blumine,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              width: 32,
              height: 32,
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'VERSION'.tr(args: [appVersion]),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: SideSwapColors.brightTurquoise,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await openUrl(SettingsAboutUsData.urlWeb);
                    },
                    child: const Text(
                      SettingsAboutUsData.urlWebText,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: SideSwapColors.brightTurquoise,
                          decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
