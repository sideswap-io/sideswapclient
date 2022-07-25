import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_popup.dart';
import 'package:sideswap/models/avatar_provider.dart';
import 'package:sideswap/models/wallet.dart';

class ImportAvatarSuccess extends ConsumerStatefulWidget {
  const ImportAvatarSuccess({super.key});

  @override
  ImportAvatarSuccessState createState() => ImportAvatarSuccessState();
}

class ImportAvatarSuccessState extends ConsumerState<ImportAvatarSuccess> {
  Image? avatar;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      avatar = await ref.read(avatarProvider).getUserAvatarThumbnail();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapPopup(
      hideCloseButton: true,
      onWillPop: () async {
        ref.read(walletProvider).setImportAvatar();
        return false;
      },
      child: Center(
        child: Column(
          children: [
            if (avatar != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Container(
                  width: 166,
                  height: 166,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF00C5FF),
                      width: 6,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: avatar?.image,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  'Success!'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  'Your photo has been successfully added'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: CustomBigButton(
                  width: double.maxFinite,
                  height: 54,
                  text: 'CONTINUE'.tr(),
                  backgroundColor: const Color(0xFF00C5FF),
                  onPressed: () {
                    ref.read(walletProvider).setAssociatePhoneWelcome();
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
