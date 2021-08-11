import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/avatar_provider.dart';
import 'package:sideswap/models/config_provider.dart';
import 'package:sideswap/models/phone_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/confirm_phone.dart';
import 'package:sideswap/screens/onboarding/confirm_phone_success.dart';
import 'package:sideswap/screens/onboarding/import_avatar_resizer.dart';
import 'package:sideswap/screens/onboarding/widgets/choose_avatar_image.dart';

class SettingsUserDetails extends StatefulWidget {
  const SettingsUserDetails({Key? key}) : super(key: key);

  @override
  _SettingsUserDetailsState createState() => _SettingsUserDetailsState();
}

class _SettingsUserDetailsState extends State<SettingsUserDetails> {
  Image? avatar;
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      avatar = await context.read(avatarProvider).getUserAvatarThumbnail();
      phoneNumber = context.read(configProvider).phoneNumber;
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
                padding: EdgeInsets.only(top: 40.h),
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
                              avatar = await context
                                  .read(avatarProvider)
                                  .getUserAvatarThumbnail();
                              await context
                                  .read(walletProvider)
                                  .settingsUserDetails();
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
                child: PhoneNumberButton(
                  phoneNumber: phoneNumber,
                  onTap: () async {
                    context.read(phoneProvider).setConfirmPhoneData(
                          confirmPhoneData: ConfirmPhoneData(
                            onConfirmPhoneBack: (context) async {
                              Navigator.of(context).pop();
                            },
                            onConfirmPhoneSuccess: (context) async {
                              await Navigator.of(context, rootNavigator: true)
                                  .push<void>(
                                MaterialPageRoute(
                                  builder: (context) => ConfirmPhoneSuccess(),
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
                  padding: EdgeInsets.only(top: 32.h, left: 16.w, right: 16.w),
                  child: TextButton(
                    onPressed: () {
                      context.read(walletProvider).unregisterPhone();
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
  PhoneNumberButton({
    Key? key,
    this.onTap,
    this.phoneNumber = '',
  }) : super(key: key);

  final VoidCallback? onTap;

  final iconRadius = 40.w;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(8.w),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: phoneNumber.isNotEmpty ? null : onTap,
          borderRadius: BorderRadius.all(Radius.circular(8.w)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  width: iconRadius,
                  height: iconRadius,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C5FF),
                    borderRadius: BorderRadius.all(
                      Radius.circular(iconRadius),
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/phone.svg',
                      width: 16.w,
                      height: 20.h,
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
                      style: GoogleFonts.roboto(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF00C5FF),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        phoneNumber,
                        style: GoogleFonts.roboto(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xFF002241),
                        ),
                      ),
                    ),
                  ],
                )
              ] else ...[
                Text(
                  '+ Associate phone number'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF00C5FF),
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
  AvatarEditButton({Key? key, this.onTap, this.avatar}) : super(key: key);

  final VoidCallback? onTap;
  final Image? avatar;

  final double avatarRadius = 114.w;
  final double editRadius = 34.w;

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
              color: const Color(0xFF00C5FF),
              borderRadius: BorderRadius.all(
                Radius.circular(avatarRadius),
              ),
              border: Border.all(
                color: const Color(0xFF00C5FF),
                width: 2.w,
              ),
            ),
            child: avatar == null
                ? ClipOval(
                    child: Padding(
                      padding: EdgeInsets.only(top: 18.h),
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
                color: const Color(0xFF00C5FF),
                borderRadius: BorderRadius.all(
                  Radius.circular(editRadius),
                ),
                border: Border.all(
                  color: const Color(0xFF054160),
                  width: 2.w,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/edit.svg',
                  width: 14.w,
                  height: 14.w,
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
