import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/custom_scrollable_container.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/biometric_available_provider.dart';
import 'package:sideswap/models/pin_available_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
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
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'AMP ID:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Consumer(builder: (context, ref, _) {
                  final ampId =
                      ref.watch(walletProvider.select((p) => p.ampId));

                  return Container(
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xFF19668F), width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              ampId ?? '',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: InkWell(
                              onTap: () async {
                                await copyToClipboard(context, ampId ?? '',
                                    displaySnackbar: true);
                              },
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/copy.svg',
                                  width: 24,
                                  height: 24,
                                  color: const Color(0xFF00B4E9),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
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
