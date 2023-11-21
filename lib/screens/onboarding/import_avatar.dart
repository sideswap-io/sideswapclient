import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/choose_avatar_image.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class ImportAvatar extends ConsumerWidget {
  const ImportAvatar({super.key});

  static const avatarRadius = 200.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 56),
                child: Container(
                  width: avatarRadius,
                  height: avatarRadius,
                  decoration: BoxDecoration(
                    color: SideSwapColors.chathamsBlue,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(avatarRadius),
                    ),
                    border: Border.all(
                      color: SideSwapColors.brightTurquoise,
                      width: 6,
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 18),
                      child: SvgPicture.asset('assets/avatar.svg'),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Want to add an avatar?'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: PageDots(
                  maxSelectedDots: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomBigButton(
                  height: 54,
                  width: double.maxFinite,
                  text: 'YES'.tr(),
                  textColor: Colors.white,
                  backgroundColor: SideSwapColors.brightTurquoise,
                  onPressed: () async {
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const ChooseAvatarImage();
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CustomBigButton(
                    height: 54,
                    width: double.maxFinite,
                    text: 'NOT NOW'.tr(),
                    textColor: SideSwapColors.brightTurquoise,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      ref.read(walletProvider).setAssociatePhoneWelcome();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
