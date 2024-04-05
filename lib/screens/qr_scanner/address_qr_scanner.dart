import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sideswap/common/enums.dart';

import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/common/utils/use_async_effect.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/qrcode_models.dart';
import 'package:sideswap/providers/qrcode_provider.dart';
import 'package:sideswap/providers/universal_link_provider.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/qr_scanner/qr_overlay_shape.dart';
import 'package:sideswap/screens/qr_scanner/qr_scanner_overlay_clipper.dart';
import 'package:sideswap_permissions/sideswap_permissions.dart';

class AddressQrScanner extends HookConsumerWidget {
  final BIP21AddressTypeEnum? expectedAddress;

  const AddressQrScanner({
    super.key,
    this.expectedAddress,
  });

  Future<void> onQrViewCreated(
    BuildContext context,
    WidgetRef ref,
    String code,
    BIP21AddressTypeEnum? expectedAddress,
    Null Function(String) errorCallback,
  ) async {
    logger.d('Scanned data: $code');

    final navigator = Navigator.of(context);

    final handleResult = ref.read(universalLinkProvider).handleAppUrlStr(code);

    return switch (handleResult) {
      HandleResult.success => () {
          Navigator.of(context).pop();
          return;
        }(),
      HandleResult.failed || HandleResult.failedUriPath => () {
          errorCallback('Invalid QR code'.tr());
          return;
        }(),
      _ => () async {
          final liquidAssetId = ref.read(liquidAssetIdStateProvider);
          logger.d(liquidAssetId);

          final result =
              await ref.read(qrcodeHelperProvider).parseDynamicQrCode(code);

          result.match((l) => errorCallback('Invalid QR code'), (r) {
            if (r.error != null) {
              errorCallback(r.errorMessage ?? 'Invalid QR code'.tr());
              return;
            }

            if (r.outputsData != null) {
              ref
                  .read(qrCodeResultModelNotifierProvider.notifier)
                  .setModel(QrCodeResultModelData(result: r));
              return;
            }

            if (r.assetId != null &&
                ref.read(assetsStateProvider)[r.assetId] == null) {
              errorCallback('Unknown asset'.tr());
              return;
            }

            if (expectedAddress != null && r.addressType != expectedAddress) {
              errorCallback('Invalid QR code'.tr());
              return;
            }

            ref
                .read(qrCodeResultModelNotifierProvider.notifier)
                .setModel(QrCodeResultModelData(result: r));
          });

          navigator.pop();
        }(),
    };
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
              .bodyLarge
              ?.copyWith(color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: SideSwapColors.chathamsBlue,
      ));
    }, const []);

    useAsyncEffect(() async {
      final navigator = Navigator.of(context);

      final plugin = SideswapPermissionsPlugin();
      if (!await plugin.hasCameraPermission()) {
        hasCameraPermission.value = await plugin.requestCameraPermission();
      } else {
        hasCameraPermission.value = true;
      }

      if (!hasCameraPermission.value) {
        logger.w('Requesting camera permission failed');
        navigator.pop();
      }

      return;
    }, const []);

    final cameraController = useMemoized<MobileScannerController?>(() {
      if (!hasCameraPermission.value) {
        return null;
      }
      return MobileScannerController(
        facing: CameraFacing.back,
        torchEnabled: false,
      );
    }, [hasCameraPermission.value]);

    var barCodeTimer = useMemoized<Timer?>(() {
      return null;
    });

    return SideSwapScaffold(
      canPop: true,
      onPopInvoked: (bool didPop) {
        cameraController?.dispose();
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
                controller: cameraController,
                onDetect: (capture) async {
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    if (barCodeTimer == null || !barCodeTimer!.isActive) {
                      barCodeTimer = Timer(const Duration(seconds: 3), () {});

                      await onQrViewCreated(
                        context,
                        ref,
                        barcodes.first.rawValue ?? '',
                        expectedAddress,
                        errorCallback,
                      );
                    }
                  } else {
                    logger.w('Failed to scan Barcode');
                  }
                },
              ),
              ClipPath(
                clipper: QrScannerOverlayClipper(
                  innerWidth: 285,
                  innerHeight: 285,
                  radius: 25,
                ),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Center(
                child: Container(
                  width: 285,
                  height: 285,
                  decoration: const ShapeDecoration(
                      shape: QrScannerOverlayShape(
                    radius: 25,
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
