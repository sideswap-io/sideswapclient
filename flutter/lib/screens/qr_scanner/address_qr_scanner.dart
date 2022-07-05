import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/common_platform.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/models/qrcode_provider.dart';
import 'package:sideswap/models/universal_link_provider.dart';
import 'package:sideswap/models/wallet.dart';
import 'package:sideswap/screens/qr_scanner/qr_overlay_shape.dart';
import 'package:sideswap/screens/qr_scanner/qr_scanner_overlay_clipper.dart';

class AddressQrScanner extends HookConsumerWidget {
  final QrCodeAddressType? expectedAddress;

  const AddressQrScanner({
    super.key,
    this.expectedAddress,
  });

  void onQrViewCreated(
    BuildContext context,
    WidgetRef ref,
    String code,
    QrCodeAddressType? expectedAddress,
    Null Function(String) errorCallback,
  ) {
    logger.d('Scanned data: $code');

    final handleResult = ref.read(universalLinkProvider).handleAppUrlStr(code);
    if (handleResult == HandleResult.success) {
      Navigator.of(context).pop();
      return;
    }
    if (handleResult == HandleResult.failed) {
      errorCallback('Invalid QR code'.tr());
      return;
    }

    final result = ref.read(qrcodeProvider).parseDynamicQrCode(code);
    if (result.error != null) {
      errorCallback(result.errorMessage ?? 'Invalid QR code'.tr());
      return;
    }

    if (result.assetId != null &&
        ref.read(walletProvider).assets[result.assetId] == null) {
      errorCallback('Unknown asset'.tr());
      return;
    }

    if (expectedAddress != null && result.addressType != expectedAddress) {
      errorCallback('Invalid QR code'.tr());
      return;
    }

    ref.read(qrcodeResultModelProvider.notifier).state =
        QrCodeResultModelData(result: result);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCameraPermission = useState(false);

    final errorCallback = useCallback((String errorMessage) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
          style: Theme.of(context)
              .textTheme
              .bodyText1
              ?.copyWith(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: const Color(0xFF135579),
      ));
    }, const []);

    useValueChanged<ValueNotifier<bool>, void>(hasCameraPermission, (_, __) {
      if (!hasCameraPermission.value) {
        logger.w('Requesting camera permission failed');
        Navigator.of(context).pop();
      }
    });

    useEffect(() {
      Future.microtask(() async {
        if (!await commonPlatform.hasCameraPermission()) {
          hasCameraPermission.value =
              await commonPlatform.requestCameraPermission();
        } else {
          hasCameraPermission.value = true;
        }
      });
      return;
    }, const []);

    final cameraController = useMemoized(() {
      return MobileScannerController(
        facing: CameraFacing.back,
        torchEnabled: false,
      );
    });

    useEffect(() {
      return cameraController.dispose;
    }, [cameraController]);

    var barCodeTimer = useMemoized<Timer?>(() {
      return null;
    });

    return SideSwapScaffold(
      onWillPop: () async {
        Navigator.of(context).pop();
        return true;
      },
      extendBodyBehindAppBar: true,
      sideSwapBackground: false,
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'QR code scan'.tr(),
        backButtonColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            if (hasCameraPermission.value) ...[
              MobileScanner(
                  allowDuplicates: true,
                  controller: cameraController,
                  onDetect: (barcode, args) {
                    if (barcode.rawValue == null) {
                      logger.w('Failed to scan Barcode');
                    } else {
                      if (barCodeTimer == null || !barCodeTimer!.isActive) {
                        barCodeTimer = Timer(const Duration(seconds: 3), () {});

                        onQrViewCreated(
                          context,
                          ref,
                          barcode.rawValue ?? '',
                          expectedAddress,
                          errorCallback,
                        );
                      }
                    }
                  }),
              ClipPath(
                clipper: QrScannerOverlayClipper(
                  innerWidth: 285.r,
                  innerHeight: 285.r,
                  radius: 25.r,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Center(
                child: Container(
                  width: 285.r,
                  height: 285.r,
                  decoration: ShapeDecoration(
                      shape: QrScannerOverlayShape(
                    radius: 25.r,
                    borderWidth: 4,
                  )),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
