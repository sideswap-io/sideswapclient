import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/desktop/common/button/d_url_link.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class UnregisteredGaid extends ConsumerWidget {
  const UnregisteredGaid({
    super.key,
    required this.msg,
  });

  final From_SubmitResult_UnregisteredGaid msg;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ampId = ref.watch(ampIdNotifierProvider);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        width: 390,
        height: 378,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: SideSwapColors.blumine,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    border: Border.all(
                      color: SideSwapColors.bitterSweet,
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/error.svg',
                      width: 23,
                      height: 23,
                      colorFilter: const ColorFilter.mode(
                          SideSwapColors.bitterSweet, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.only(top: 32),
                  child: Column(
                    children: [
                      Text(
                        'Please register your AMP ID at'.tr(),
                      ),
                      const SizedBox(height: 8),
                      DUrlLink(
                        text: 'https://${msg.domainAgent}',
                      ),
                      const SizedBox(height: 20),
                      if (ampId.isNotEmpty) ...[
                        UnregisteredGaidAmpId(ampId: ampId),
                      ],
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomBigButton(
                    width: 279,
                    height: 54,
                    text: 'OK'.tr(),
                    backgroundColor: SideSwapColors.brightTurquoise,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
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

class UnregisteredGaidAmpId extends StatelessWidget {
  const UnregisteredGaidAmpId({
    super.key,
    required this.ampId,
  });

  final String ampId;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 10),
        const Text(
          'AMP ID:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            ampId,
            style: const TextStyle(
              fontSize: 14,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () async {
            await copyToClipboard(
              context,
              ampId,
            );
          },
          icon: SvgPicture.asset(
            'assets/copy2.svg',
            width: 20,
            height: 20,
          ),
        )
      ],
    );
  }
}
