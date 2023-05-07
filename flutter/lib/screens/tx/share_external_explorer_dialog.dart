import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sideswap/common/sideswap_colors.dart';

enum ShareIconType {
  share,
  link,
}

enum BlindType {
  unblinded,
  both,
}

class ShareExternalExplorerDialog extends StatelessWidget {
  const ShareExternalExplorerDialog({
    super.key,
    required this.onBlindedPressed,
    required this.onUnblindedPressed,
    this.shareIconType = ShareIconType.share,
    this.blindType = BlindType.both,
  });

  final ShareIconType shareIconType;
  final VoidCallback onBlindedPressed;
  final VoidCallback onUnblindedPressed;
  final BlindType blindType;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Material(
            color: Colors.transparent,
            child: Container(
              height: blindType == BlindType.both ? 165 : 84,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                color: SideSwapColors.blumine,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: [
                      if (blindType == BlindType.both) ...[
                        BlindedButton(
                          onPressed: onBlindedPressed,
                          shareIconType: shareIconType,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            thickness: 1,
                            height: 1,
                            color: SideSwapColors.ceruleanFrost,
                          ),
                        ),
                      ],
                      BlindedButton(
                        type: BlindedButtonType.unblinded,
                        onPressed: onUnblindedPressed,
                        shareIconType: shareIconType,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum BlindedButtonType {
  blinded,
  unblinded,
}

class BlindedButton extends StatelessWidget {
  const BlindedButton({
    super.key,
    this.type = BlindedButtonType.blinded,
    required this.onPressed,
    required this.shareIconType,
  });

  final BlindedButtonType type;
  final VoidCallback onPressed;
  final ShareIconType shareIconType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        child: SizedBox(
          height: 44,
          child: Column(
            children: [
              const Spacer(),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: type == BlindedButtonType.blinded
                        ? SvgPicture.asset(
                            'assets/blinded.svg',
                            width: 22,
                            height: 20,
                          )
                        : SvgPicture.asset(
                            'assets/unblinded.svg',
                            width: 22,
                            height: 16,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      type == BlindedButtonType.blinded
                          ? 'Blinded data'.tr()
                          : 'Unblinded data'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: shareIconType == ShareIconType.share
                        ? SvgPicture.asset(
                            'assets/share3.svg',
                            width: 24,
                            height: 24,
                          )
                        : SvgPicture.asset(
                            'assets/link.svg',
                            width: 24,
                            height: 24,
                          ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
