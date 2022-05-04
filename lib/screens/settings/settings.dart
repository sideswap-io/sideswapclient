import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sideswap/common/helpers.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/biometric_available_provider.dart';
import 'package:sideswap/models/pin_available_provider.dart';
import 'package:sideswap/models/pin_setup_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/flavor_config.dart';
import 'package:sideswap/screens/settings/settings_security.dart';
import 'package:sideswap/screens/settings/widgets/settings_button.dart';
import 'package:sideswap/screens/settings/widgets/settings_delete_wallet_dialog.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
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
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Text('AMP ID:',
                    style: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    )),
              ),
              SizedBox(
                height: 8.w,
              ),
              Consumer(builder: (context, ref, _) {
                final ampId = ref.watch(walletProvider.select((p) => p.ampId));

                return Container(
                  height: 60.w,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF19668F), width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(8.w)),
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
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
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
                                width: 24.w,
                                height: 24.w,
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
                padding: EdgeInsets.only(top: 24.h),
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
                  padding: EdgeInsets.only(top: 8.h),
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
                padding: EdgeInsets.only(top: 8.h),
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
                      Visibility(
                        visible: !isBiometricAvailable || isPinEnabled,
                        child: SettingsSecurity(
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
                      ),
                    ],
                  );
                },
              ),
              if (FlavorConfig.enableNetworkSettings) ...[
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: SettingsButton(
                    type: SettingsButtonType.network,
                    text: 'Network access'.tr(),
                    onPressed: () {
                      ref.read(walletProvider).settingsNetwork();
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
