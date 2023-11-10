import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/desktop/common/button/d_icon_button.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/receive/widgets/asset_receive_widget.dart';

class DReceivePopup extends ConsumerWidget {
  const DReceivePopup({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAmp = ref.watch(walletRecvAddressAccount).isAmp;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 580,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: SideSwapColors.blumine,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 40,bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Generate address'.tr(),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          isAmp
                              ? 'Address for AMP Securities wallet successfully generated'
                              .tr()
                              : "Address for regular wallet successfully generated"
                              .tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          )),
                      Flexible(
                        child: AssetReceiveWidget(
                          key: Key(isAmp.toString()),
                          showShare: false,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: DIconButton(
                      icon: SvgPicture.asset(
                        'assets/close2.svg',
                        width: 18,
                        height: 18,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ))
      ],
    );
  }
}
