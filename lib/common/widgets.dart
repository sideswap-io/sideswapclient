import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/permission_handler.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/universal_link_provider.dart';
import 'package:sideswap/models/wallet.dart';

class AddressQrScanner extends ConsumerStatefulWidget {
  final ValueChanged<QrCodeResult> resultCb;
  final QrCodeAddressType? expectedAddress;

  const AddressQrScanner({
    super.key,
    required this.resultCb,
    this.expectedAddress,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddressQrScannerState();
}

class _AddressQrScannerState extends ConsumerState<AddressQrScanner> {
  MobileScannerController cameraController = MobileScannerController();

  bool done = false;
  bool hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => afterBuild(context));
  }

  void afterBuild(BuildContext context) async {
    if (!await PermissionHandler.hasCameraPermission()) {
      hasCameraPermission = await PermissionHandler.requestCameraPermission();
    } else {
      hasCameraPermission = true;
    }

    setState(() {});

    if (!hasCameraPermission) {
      logger.w('Requesting camera permission failed');
      await popup();
    }
  }

  Future<bool> popup() async {
    done = true;
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SideSwapScaffold(
      onWillPop: popup,
      extendBodyBehindAppBar: true,
      sideSwapBackground: false,
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'QR code scan'.tr(),
        backButtonColor: Colors.white,
        onPressed: () {
          popup();
        },
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            if (hasCameraPermission) ...[
              MobileScanner(
                  allowDuplicates: false,
                  controller: MobileScannerController(
                      facing: CameraFacing.front, torchEnabled: true),
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null) {
                      logger.d('Failed to scan Barcode');
                    } else {
                      final String code = barcode.rawValue!;
                      _onQrViewCreated(ref, code, widget.expectedAddress);
                    }
                  }),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> showError(String errorMessage) async {
    final flushbar = Flushbar<Widget>(
      messageText: Text(
        errorMessage,
        style: Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: Colors.white),
      ),
      duration: const Duration(seconds: 3),
      backgroundColor: const Color(0xFF135579),
    );

    await flushbar.show(context);
  }

  void _onQrViewCreated(
      WidgetRef ref, String code, QrCodeAddressType? expectedAddress) {
    if (!done) {
      done = true;
      logger.d('Scanned data: $code');

      final handleResult =
          ref.read(universalLinkProvider).handleAppUrlStr(code);
      if (handleResult == HandleResult.success) {
        popup();
        return;
      }
      if (handleResult == HandleResult.failed) {
        showError('Invalid QR code'.tr());
        done = false;
        return;
      }

      final result = ref.read(qrcodeProvider).parseDynamicQrCode(code);
      if (result.error != null) {
        showError(result.errorMessage ?? 'Invalid QR code'.tr());
        done = false;
        return;
      }

      if (result.assetId != null &&
          ref.read(walletProvider).assets[result.assetId] == null) {
        showError('Unknown asset'.tr());
        done = false;
        return;
      }

      if (expectedAddress != null && result.addressType != expectedAddress) {
        showError('Invalid QR code'.tr());
        done = false;
        return;
      }

      widget.resultCb(result);
      popup();
    }
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}

class ShareTxidButtons extends ConsumerWidget {
  final bool isLiquid;
  final String txid;

  const ShareTxidButtons({
    super.key,
    required this.isLiquid,
    required this.txid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () =>
                  ref.read(walletProvider).openTxUrl(txid, isLiquid, false),
              child: const Text('LINK TO EXTERNAL EXPLORER').tr(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: SizedBox(
            height: 50,
            child: CustomButton(
              onPressed: () => shareTxid(txid),
              text: 'SHARE'.tr(),
            ),
          ),
        ),
      ],
    );
  }
}

class ShareAddress extends StatelessWidget {
  const ShareAddress({
    super.key,
    required this.addr,
  });

  final String addr;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomButton(
          text: 'Copy'.tr(),
          onPressed: () => copyToClipboard(context, addr),
        ),
        CustomButton(
          text: 'Share'.tr(),
          onPressed: () => shareAddress(addr),
        ),
      ],
    );
  }
}

class CopyButton extends StatelessWidget {
  final String value;

  const CopyButton({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.copy,
        size: 32,
      ),
      onPressed: () => copyToClipboard(context, value),
    );
  }
}
