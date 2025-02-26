import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/app_version.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/desktop/widgets/amp_id_panel.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/biometric_available_provider.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/pin_available_provider.dart';
import 'package:sideswap/providers/pin_setup_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_page_status_provider.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/settings_about_us.dart';
import 'package:sideswap/screens/settings/settings_languages.dart';
import 'package:sideswap/screens/settings/settings_logs.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';
import 'package:sideswap/screens/settings/widgets/settings_delete_wallet_dialog.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      appBar: CustomAppBar(title: 'Settings'.tr()),
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          ref.read(walletProvider).goBack();
        }
      },
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 24),
                      child: SettingsLogoWithAppVersion(),
                    ),
                    Consumer(
                      builder: (context, ref, child) {
                        final ampId = ref.watch(ampIdNotifierProvider);

                        return AmpIdPanel(
                          width: double.infinity,
                          height: 60,
                          ampId: ampId,
                          backgroundColor: SideSwapColors.chathamsBlue,
                          onTap: () {
                            ref
                                .read(pageStatusNotifierProvider.notifier)
                                .setStatus(Status.ampRegister);
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Consumer(
                        builder: (context, ref, _) {
                          final isJadeWallet = ref.watch(isJadeWalletProvider);
                          return switch (isJadeWallet) {
                            false => SettingsButton(
                              type: SettingsButtonType.recovery,
                              text: 'View my recovery phrase'.tr(),
                              onPressed: () {
                                ref.read(walletProvider).settingsViewBackup();
                              },
                            ),
                            _ => const SizedBox(),
                          };
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Consumer(
                        builder: (context, ref, _) {
                          return SettingsButton(
                            type: SettingsButtonType.about,
                            text: 'About us'.tr(),
                            onPressed: () {
                              ref.read(walletProvider).settingsViewAboutUs();
                            },
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        HookConsumer(
                          builder: (context, ref, _) {
                            final isBiometricAvailable = useState(false);
                            final isBiometricEnabled = ref.watch(
                              isBiometricEnabledProvider,
                            );
                            final isBiometricAvailableAsync = ref.watch(
                              isBiometricAvailableProvider,
                            );

                            (switch (isBiometricAvailableAsync) {
                              AsyncValue(
                                hasValue: true,
                                value: bool available,
                              ) =>
                                () {
                                  isBiometricAvailable.value = available;
                                },
                              _ => () {},
                            })();

                            return switch (isBiometricAvailable.value) {
                              true => SettingsSecurity(
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
                              false => const SizedBox(),
                            };
                          },
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final isPinAvailable = ref.watch(
                              isPinAvailableProvider,
                            );
                            final isPinEnabled = ref.watch(
                              pinAvailableProvider,
                            );

                            return switch (isPinAvailable) {
                              true => SettingsSecurity(
                                icon: Icons.fiber_pin_outlined,
                                description: 'PIN protection'.tr(),
                                value: isPinEnabled,
                                onTap: () async {
                                  if (isPinEnabled) {
                                    await ref
                                        .read(walletProvider)
                                        .disablePinProtection();
                                  } else {
                                    ref
                                        .read(pinHelperProvider)
                                        .initPinSetupSettings();
                                  }
                                },
                              ),
                              _ => SizedBox(),
                            };
                          },
                        ),
                      ],
                    ),
                    if (FlavorConfig.enableNetworkSettings) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Consumer(
                          builder: (context, ref, _) {
                            return SettingsButton(
                              type: SettingsButtonType.network,
                              text: 'Network access'.tr(),
                              onPressed: () {
                                ref
                                    .read(pageStatusNotifierProvider.notifier)
                                    .setStatus(Status.settingsNetwork);
                              },
                            );
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
                              context: context,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SettingsButton(
                        type: SettingsButtonType.logs,
                        text: 'Logs'.tr(),
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).push<void>(
                            DialogRoute(
                              builder: ((context) => const SettingsLogs()),
                              context: context,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SettingsButton(
                        type: SettingsButtonType.currency,
                        text: 'Currency'.tr(),
                        onPressed: () {
                          ref
                              .read(pageStatusNotifierProvider.notifier)
                              .setStatus(Status.settingsCurrency);
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
          ],
        ),
      ),
    );
  }
}

class SettingsLogoWithAppVersion extends StatelessWidget {
  const SettingsLogoWithAppVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: SideSwapColors.blumine, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
        child: Stack(
          children: [
            SvgPicture.asset('assets/logo.svg', width: 32, height: 32),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    'VERSION: {}'.tr(args: [appVersion]),
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
                        decoration: TextDecoration.underline,
                      ),
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
