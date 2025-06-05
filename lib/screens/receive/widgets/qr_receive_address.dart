import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/use_timeout_fn.dart';
import 'package:sideswap/providers/jade_provider.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/screens/home/widgets/rounded_button.dart';
import 'package:sideswap/screens/home/widgets/rounded_button_with_label.dart';
import 'package:sideswap/screens/receive/widgets/wrapped_address_receive.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class QrReceiveAddress extends HookConsumerWidget {
  const QrReceiveAddress({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const qrWidgetSize = 263.0;

    final jadeVerifyAddressState = ref.watch(
      jadeVerifyAddressStateNotifierProvider,
    );
    final receiveAddress = ref.watch(currentReceiveAddressProvider);
    final isJadeWallet = ref.watch(isJadeWalletProvider);

    final wrapText = useState(true);
    final copyInfoState = useState(false);
    final copyTimeoutCallback = useTimeoutFn(() {
      copyInfoState.value = false;
    }, Duration(milliseconds: 1500));

    final showCopyInfo = useCallback(() {
      copyInfoState.value = true;
      copyTimeoutCallback.reset();
    });

    final defaultButtonStyle = Theme.of(
      context,
    ).extension<IconWrapTextButtonStyle>()?.buttonStyle;

    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          width: qrWidgetSize,
          height: qrWidgetSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          child: Center(
            child: QrImageView(
              data: receiveAddress.recvAddress,
              version: QrVersions.auto,
              size: 223,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Receiving address'.tr(),
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF00B4E9),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: WrappedAddressReceive(
                    wrapText: wrapText.value,
                    receiveAddress: receiveAddress,
                  ),
                ),
                const SizedBox(width: 6),
                IconButton(
                  style: defaultButtonStyle,
                  onPressed: () {
                    wrapText.value = !wrapText.value;
                  },
                  icon: Icon(
                    Icons.short_text,
                    color: wrapText.value
                        ? SideSwapColors.airSuperiorityBlue
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        ...switch (jadeVerifyAddressState) {
          JadeVerifyAddressStateVerifying() => [
            SizedBox(
              height: 48,
              child: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ],
          JadeVerifyAddressStateSuccess() => [
            DecoratedBox(
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1.0,
                    style: BorderStyle.solid,
                    color: SideSwapColors.brightTurquoise,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Verified'.tr()),
              ),
            ),
          ],
          _ => [const SizedBox()],
        },
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButtonWithLabel(
              iconHeight: 48,
              iconWidth: 48,
              onTap: () async {
                await copyToClipboard(
                  context,
                  receiveAddress.recvAddress,
                  displaySnackbar: false,
                );
                showCopyInfo();
              },
              label: 'Copy'.tr(),
              buttonBackground: Colors.white,
              labelTextStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
              child: SvgPicture.asset('assets/copy.svg', width: 22, height: 22),
            ),
            SizedBox(width: 32),
            RoundedButtonWithLabel(
              iconHeight: 48,
              iconWidth: 48,
              onTap: () async {
                await shareAddress(receiveAddress.recvAddress);
              },
              label: 'Share'.tr(),
              buttonBackground: Colors.white,
              child: SvgPicture.asset(
                'assets/share.svg',
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(width: 32),
            ...switch (isJadeWallet) {
              true => [
                RoundedButtonWithLabel(
                  iconHeight: 48,
                  iconWidth: 48,
                  onTap: () {
                    ref
                        .read(jadeVerifyAddressStateNotifierProvider.notifier)
                        .setState(JadeVerifyAddressState.verifying());
                    final msg = To();
                    msg.jadeVerifyAddress = Address(
                      addr: receiveAddress.recvAddress,
                    );
                    ref.read(walletProvider).sendMsg(msg);
                  },
                  label: 'Verify'.tr(),
                  buttonBackground: Colors.white,
                  labelTextStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                  child: Icon(
                    Icons.domain_verification,
                    size: 22,
                    color: SideSwapColors.chathamsBlueDark,
                  ),
                ),
              ],
              _ => [const SizedBox()],
            },
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: AnimatedOpacity(
            opacity: copyInfoState.value ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: RoundedButton(
              color: SideSwapColors.maastrichtBlue,
              width: double.infinity,
              height: 39,
              borderRadius: BorderRadius.circular(8),
              child: Text(
                receiveAddress.account == Account.AMP_
                    ? 'AMP address copied'.tr()
                    : 'Liquid address copied'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class IconWrapTextButtonStyle extends ThemeExtension<IconWrapTextButtonStyle> {
  const IconWrapTextButtonStyle({this.buttonStyle});

  final ButtonStyle? buttonStyle;

  @override
  IconWrapTextButtonStyle lerp(
    ThemeExtension<IconWrapTextButtonStyle> other,
    double t,
  ) {
    if (other is! IconWrapTextButtonStyle) {
      return this;
    }

    return IconWrapTextButtonStyle(
      buttonStyle: ButtonStyle.lerp(buttonStyle, other.buttonStyle, t),
    );
  }

  @override
  IconWrapTextButtonStyle copyWith({ButtonStyle? buttonStyle}) =>
      IconWrapTextButtonStyle(buttonStyle: buttonStyle ?? this.buttonStyle);
}
