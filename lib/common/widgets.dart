import 'dart:async';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/permission_handler.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';

class AddressQrScanner extends StatefulWidget {
  final ValueChanged<QrCodeResult> resultCb;
  final QrCodeAddressType? expectedAddress;

  AddressQrScanner({required this.resultCb, this.expectedAddress});

  @override
  State<StatefulWidget> createState() =>
      _AddressQrScannerState(resultCb: resultCb);
}

class _AddressQrScannerState extends State<AddressQrScanner> {
  QRViewController? _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  final ValueChanged<QrCodeResult> resultCb;

  _AddressQrScannerState({required this.resultCb});
  bool done = false;
  bool hasCameraPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => afterBuild(context));
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
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _qrController?.pauseCamera();
    } else if (Platform.isIOS) {
      _qrController?.resumeCamera();
    }
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
              QRView(
                key: _qrKey,
                onQRViewCreated: (value) {
                  _onQrViewCreated(value, widget.expectedAddress);
                },
                onPermissionSet: onPermissionSet,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 5,
                  cutOutSize: 250,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void onPermissionSet(QRViewController controller, bool isPermissionSet) {
    if (!isPermissionSet) {
      popup();
    }
  }

  void _onQrViewCreated(
      QRViewController controller, QrCodeAddressType? expectedAddress) {
    _qrController = controller;

    var input = '';
    controller.scannedDataStream.where((e) {
      final ret = e.code != input;
      input = e.code;
      return ret;
    }).listen((scanData) async {
      Future<void>.delayed(Duration(seconds: 2), () {
        input = '';
      });

      if (!done) {
        done = true;
        logger.d('Scanned data: ${scanData.code}');
        final result =
            context.read(qrcodeProvider).parseDynamicQrCode(scanData.code);
        if (result.error != null) {
          final flushbar = Flushbar<Widget>(
            messageText: Text(
              result.errorMessage ?? '',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Color(0xFF135579),
          );

          await flushbar.show(context);

          done = false;
          return;
        }

        if (expectedAddress != null && result.addressType != expectedAddress) {
          final flushbar = Flushbar<Widget>(
            messageText: Text(
              'Invalid QR code'.tr(),
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  ?.copyWith(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Color(0xFF135579),
          );

          await flushbar.show(context);

          done = false;
          return;
        }

        resultCb(result);
        await popup();
      }
    });
  }

  @override
  void dispose() {
    _qrController?.dispose();
    super.dispose();
  }
}

class ShareTxidButtons extends StatelessWidget {
  final bool isLiquid;
  final String txid;

  ShareTxidButtons({required this.txid, required this.isLiquid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () =>
                  context.read(walletProvider).openTxUrl(txid, isLiquid, true),
              child: Text('LINK TO EXTERNAL EXPLORER').tr(),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
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
  ShareAddress({
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

  CopyButton({required this.value});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.copy,
        size: 32,
      ),
      onPressed: () => copyToClipboard(context, value),
    );
  }
}
