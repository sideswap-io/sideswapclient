import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/avatar_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';

class ImportAvatarSuccess extends StatefulWidget {
  const ImportAvatarSuccess({Key key}) : super(key: key);

  @override
  _ImportAvatarSuccessState createState() => _ImportAvatarSuccessState();
}

class _ImportAvatarSuccessState extends State<ImportAvatarSuccess> {
  Image avatar;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      avatar = await context.read(avatarProvider).getUserAvatarThumbnail();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      hideCloseButton: true,
      onWillPop: () async {
        context.read(walletProvider).setImportAvatar();
        return false;
      },
      child: Center(
        child: Column(
          children: [
            if (avatar != null) ...[
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Container(
                  width: 166.w,
                  height: 166.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xFF00C5FF),
                      width: 6.w,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: avatar.image,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32.h),
                child: Text(
                  'Success!'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: Text(
                  'Your photo has been successfully added'.tr(),
                  style: GoogleFonts.roboto(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: CustomBigButton(
                  width: double.maxFinite,
                  height: 54.h,
                  text: 'CONTINUE'.tr(),
                  backgroundColor: Color(0xFF00C5FF),
                  onPressed: () {
                    context.read(walletProvider).setAssociatePhoneWelcome();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
