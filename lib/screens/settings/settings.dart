import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';
import 'package:sideswap/screens/settings/widgets/settings_delete_wallet_dialog.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isBiometricAvailable = false;

  @override
  void initState() {
    Future.microtask(() async {
      isBiometricAvailable =
          await context.read(walletProvider).isBiometricAvailable();
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: SettingsButton(
                  type: SettingsButtonType.recovery,
                  text: 'View my recovery phrase'.tr(),
                  onPressed: () {
                    context.read(walletProvider).settingsViewBackup();
                  },
                ),
              ),
              if (FlavorConfig.isProduction() &&
                  FlavorConfig
                      .instance.values.enableOnboardingUserFeatures) ...[
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: SettingsButton(
                    type: SettingsButtonType.userDetails,
                    text: 'User details'.tr(),
                    onPressed: () {
                      context.read(walletProvider).settingsUserDetails();
                    },
                  ),
                ),
              ],
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: SettingsButton(
                  type: SettingsButtonType.about,
                  text: 'About us'.tr(),
                  onPressed: () {
                    context.read(walletProvider).settingsViewAboutUs();
                  },
                ),
              ),
              Consumer(
                builder: (context, watch, child) {
                  watch(walletProvider).isBiometricAvailable().then((value) {
                    setState(() {
                      isBiometricAvailable = value;
                    });
                  });

                  final isBiometricEnabled =
                      watch(walletProvider).isBiometricEnabled();
                  final isPinEnabled = watch(walletProvider).isPinEnabled();

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
                              await context
                                  .read(walletProvider)
                                  .settingsDisableBiometric();
                            } else {
                              // disable pin to be sure!
                              // pin could be enabled when biometric is unavailable
                              // but in the mean time biometric could be enabled in device settings
                              // then we need to display in settings both options
                              if (await context
                                  .read(walletProvider)
                                  .disablePinProtection()) {
                                await context
                                    .read(walletProvider)
                                    .settingsEnableBiometric();
                              }
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: !isBiometricAvailable || isPinEnabled,
                        child: SettingsSecurity(
                          icon: Icons.fiber_pin_outlined,
                          description: 'PIN protection'.tr(),
                          value: isPinEnabled,
                          onTap: () async {
                            if (isPinEnabled) {
                              await context
                                  .read(walletProvider)
                                  .disablePinProtection();
                            } else {
                              context.read(walletProvider).setPinSetup(
                                onSuccessCallback:
                                    (BuildContext context) async {
                                  context
                                      .read(walletProvider)
                                      .settingsViewPage();
                                },
                                onBackCallback: (BuildContext context) async {
                                  context
                                      .read(walletProvider)
                                      .settingsViewPage();
                                },
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (FlavorConfig.instance.values.enableNetworkSettings) ...[
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: SettingsButton(
                    type: SettingsButtonType.network,
                    text: 'Network access'.tr(),
                    onPressed: () {
                      context.read(walletProvider).settingsNetwork();
                    },
                  ),
                ),
              ],
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 48.w),
                child: SettingsButton(
                  type: SettingsButtonType.delete,
                  text: 'Delete wallet',
                  transparent: true,
                  onPressed: () {
                    showDeleteWalletDialog(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
