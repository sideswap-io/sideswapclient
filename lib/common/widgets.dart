import 'dart:async';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sideswap/common/helpers.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/common/screen_utils.dart';

class AddressQrScanner extends StatefulWidget {
  final ValueChanged<QrCodeResult> resultCb;

  AddressQrScanner({this.resultCb});

  @override
  State<StatefulWidget> createState() =>
      _AddressQrScannerState(resultCb: resultCb);
}

class _AddressQrScannerState extends State<AddressQrScanner> {
  QRViewController _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  final ValueChanged<QrCodeResult> resultCb;

  _AddressQrScannerState({this.resultCb});
  bool done = false;

  Future<bool> popup() async {
    done = true;
    Navigator.of(context.read(walletProvider).navigatorKey.currentContext,
            rootNavigator: true)
        .pop();
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
            QRView(
              key: _qrKey,
              onQRViewCreated: _onQrViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.white,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 5,
                cutOutSize: 250,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQrViewCreated(QRViewController controller) {
    _qrController = controller;

    String input;
    controller.scannedDataStream.where((e) {
      final ret = e != input;
      input = e;
      return ret;
    }).listen((scanData) async {
      Future<void>.delayed(Duration(seconds: 2), () {
        input = '';
      });

      if (!done) {
        done = true;
        logger.d('Scanned data: $scanData');
        final result =
            context.read(qrcodeProvider).parseDynamicQrCode(scanData);
        if (result.error != null) {
          final flushbar = Flushbar<Widget>(
            messageText: Text(
              result.errorMessage,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white),
            ),
            duration: Duration(seconds: 3),
            backgroundColor: Color(0xFF135579),
          );
          await flushbar.show(context);

          done = false;
          return;
        }

        if (resultCb != null) {
          resultCb(result);
        }

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

class MnemonicWord extends StatelessWidget {
  final int index;
  final ValueChanged<String> onChanged;
  final bool readOnly;
  final String initialValue;

  factory MnemonicWord.enabled({int index, void Function(String) onChanged}) {
    return MnemonicWord(
      index: index,
      onChanged: onChanged,
      readOnly: false,
      initialValue: null,
    );
  }

  factory MnemonicWord.disabled({int index, String initialValue}) {
    return MnemonicWord(
      index: index,
      onChanged: null,
      readOnly: true,
      initialValue: initialValue,
    );
  }

  MnemonicWord({this.index, this.onChanged, this.readOnly, this.initialValue});

  final _labelStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: Color(0xFF00C5FF),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104.w,
      height: 39.h,
      decoration: BoxDecoration(
        color: Color(0xFF23729D),
        borderRadius: BorderRadius.all(
          Radius.circular(8.w),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Text(
              '${index + 1}',
              style: _labelStyle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: index > 8 ? 8.w : 16.w),
            child: Container(
              width: 65.w,
              height: 21.h,
              child: Center(
                child: TextFormField(
                  initialValue: initialValue,
                  readOnly: readOnly,
                  style: _labelStyle.copyWith(
                    color: Colors.white,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShareTxidButtons extends StatelessWidget {
  final bool isLiquid;
  final String txid;

  ShareTxidButtons({@required this.txid, @required this.isLiquid});

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
              onPressed: () => openTxidUrl(txid, isLiquid),
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
    @required this.addr,
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

  CopyButton({@required this.value});

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
