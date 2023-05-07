import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';

import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/avatar_provider.dart';
import 'package:sideswap/providers/config_provider.dart';
import 'package:sideswap/providers/phone_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/confirm_phone.dart';
import 'package:sideswap/screens/onboarding/confirm_phone_success.dart';
import 'package:sideswap/screens/onboarding/import_avatar_resizer.dart';
import 'package:sideswap/screens/onboarding/widgets/choose_avatar_image.dart';

class SettingsUserDetails extends ConsumerStatefulWidget {
  const SettingsUserDetails({super.key});

  @override
  SettingsUserDetailsState createState() => SettingsUserDetailsState();
}

class SettingsUserDetailsState extends ConsumerState<SettingsUserDetails> {
  Image? avatar;
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      avatar = await ref.read(avatarProvider).getUserAvatarThumbnail();
      phoneNumber = ref.read(configProvider).phoneNumber;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      appBar: CustomAppBar(
        title: 'User details'.tr(),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: AvatarEditButton(
                  avatar: avatar,
                  onTap: () async {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return ChooseAvatarImage(
                          resizerData: ImportAvatarResizerData(
                            onBack: (context) async {
                              Navigator.of(context).pop();
                            },
                            onSave: (context) async {
                              Navigator.of(context).pop();
                              // refresh avatar
                              avatar = await ref
                                  .read(avatarProvider)
                                  .getUserAvatarThumbnail();
                              ref.read(walletProvider).settingsUserDetails();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                child: PhoneNumberButton(
                  phoneNumber: phoneNumber,
                  onTap: () async {
                    ref.read(phoneProvider).setConfirmPhoneData(
                          confirmPhoneData: ConfirmPhoneData(
                            onConfirmPhoneBack: (context) async {
                              Navigator.of(context).pop();
                            },
                            onConfirmPhoneSuccess: (context) async {
                              await Navigator.of(context, rootNavigator: true)
                                  .push<void>(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ConfirmPhoneSuccess(),
                                ),
                              );
                            },
                            onConfirmPhoneDone: (context) async {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                          ),
                        );

                    await Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (context) => const ConfirmPhone(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                  child: TextButton(
                    onPressed: () {
                      ref.read(walletProvider).unregisterPhone();
                    },
                    child: const Text('Logout'),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberButton extends StatelessWidget {
  const PhoneNumberButton({
    super.key,
    this.onTap,
    this.phoneNumber = '',
  });

  final VoidCallback? onTap;

  final iconRadius = 40.0;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: phoneNumber.isNotEmpty ? null : onTap,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  width: iconRadius,
                  height: iconRadius,
                  decoration: BoxDecoration(
                    color: SideSwapColors.brightTurquoise,
                    borderRadius: BorderRadius.all(
                      Radius.circular(iconRadius),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/phone.svg',
                      width: 16,
                      height: 20,
                    ),
                  ),
                ),
              ),
              if (phoneNumber.isNotEmpty) ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Phone number'.tr(),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: SideSwapColors.brightTurquoise,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        phoneNumber,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF002241),
                        ),
                      ),
                    ),
                  ],
                )
              ] else ...[
                Text(
                  '+ Associate phone number'.tr(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: SideSwapColors.brightTurquoise,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AvatarEditButton extends StatelessWidget {
  const AvatarEditButton({super.key, this.onTap, this.avatar});

  final VoidCallback? onTap;
  final Image? avatar;

  final double avatarRadius = 114.0;
  final double editRadius = 34.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: avatarRadius,
      height: avatarRadius,
      child: Stack(
        children: [
          Container(
            width: avatarRadius,
            height: avatarRadius,
            decoration: BoxDecoration(
              color: SideSwapColors.brightTurquoise,
              borderRadius: BorderRadius.all(
                Radius.circular(avatarRadius),
              ),
              border: Border.all(
                color: SideSwapColors.brightTurquoise,
                width: 2,
              ),
            ),
            child: avatar == null
                ? ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: SvgPicture.asset('assets/avatar.svg'),
                    ),
                  )
                : CircleAvatar(
                    backgroundImage: avatar?.image,
                  ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: editRadius,
              height: editRadius,
              decoration: BoxDecoration(
                color: SideSwapColors.brightTurquoise,
                borderRadius: BorderRadius.all(
                  Radius.circular(editRadius),
                ),
                border: Border.all(
                  color: const Color(0xFF054160),
                  width: 2,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/edit.svg',
                  width: 14,
                  height: 14,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(avatarRadius),
              onTap: onTap,
            ),
          )
        ],
      ),
    );
  }
}
