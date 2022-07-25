import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/onboarding/widgets/page_dots.dart';

class AvatarClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    final rect =
        Rect.fromLTRB(0.0, 0.0, size.width, size.height - size.height / 4.1);
    return rect;
  }

  @override
  bool shouldReclip(AvatarClipper oldClipper) {
    return true;
  }
}

class AssociatePhoneWelcome extends ConsumerWidget {
  const AssociatePhoneWelcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SideSwapScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: constraints.maxWidth,
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              child: ClipRect(
                                clipper: AvatarClipper(),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 56, right: 75),
                                  child: SizedBox(
                                    width: 192,
                                    height: 267,
                                    child: SvgPicture.asset(
                                      'assets/associate_phone.svg',
                                      width: 197,
                                      height: 267,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 290),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'Want to associate an phone number with your account?'
                                      .tr(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.only(bottom: 32),
                          child: PageDots(
                            maxSelectedDots: 3,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CustomBigButton(
                            width: double.maxFinite,
                            height: 54,
                            backgroundColor: const Color(0xFF00C5FF),
                            text: 'YES'.tr(),
                            onPressed: () {
                              ref.read(walletProvider).setConfirmPhone();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16, bottom: 16),
                            child: CustomBigButton(
                              width: double.maxFinite,
                              height: 54,
                              backgroundColor: Colors.transparent,
                              text: 'NOT NOW'.tr(),
                              textColor: const Color(0xFF00C5FF),
                              onPressed: () {
                                ref.read(walletProvider).setImportContacts();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
