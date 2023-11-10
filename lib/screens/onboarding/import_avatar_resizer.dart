import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as image;
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/providers/avatar_provider.dart';
import 'package:sideswap/providers/wallet.dart';

typedef ImageFakeCanvas = Future<void> Function();
typedef OnBack = Future<void> Function(BuildContext context);
typedef OnSave = Future<void> Function(BuildContext context);

class ImportAvatarResizerData {
  final OnBack? onBack;
  final OnSave? onSave;

  ImportAvatarResizerData({this.onBack, this.onSave});
}

class ImportAvatarResizer extends ConsumerStatefulWidget {
  const ImportAvatarResizer({super.key, this.resizerData});

  final ImportAvatarResizerData? resizerData;

  @override
  ImportAvatarResizerState createState() => ImportAvatarResizerState();
}

class ImportAvatarResizerState extends ConsumerState<ImportAvatarResizer> {
  late ImportAvatarResizerData resizerData;

  @override
  void initState() {
    super.initState();
    if (widget.resizerData == null) {
      resizerData = ImportAvatarResizerData(
        onBack: (context) async {
          Navigator.of(context).pop();
          ref.read(walletProvider).setImportAvatar();
        },
        onSave: (context) async {
          Navigator.of(context).pop();
          ref.read(walletProvider).setImportAvatarSuccess();
        },
      );
    } else {
      resizerData = widget.resizerData!;
    }
  }

  Future<void> generateThumbnail(WidgetRef ref) async {
    final data = ref.read(avatarProvider).userAvatarData;
    if (data.uiImage == null) {
      return;
    }

    final position = data.position;
    final size = Size(MediaQuery.of(context).size.width, 375);

    final drawOutput =
        Rect.fromLTWH(position.dx, position.dy, size.width, size.height);
    final imageSize =
        Size(data.uiImage!.width.toDouble(), data.uiImage!.height.toDouble());
    final sizes = applyBoxFit(BoxFit.contain, imageSize,
        Size(size.width * data.zoom, size.height * data.zoom));
    final inputSubrect =
        Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final outputSubrect =
        Alignment.center.inscribe(sizes.destination, drawOutput);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, outputSubrect);

    canvas.drawImageRect(data.uiImage!, inputSubrect, outputSubrect, Paint());

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.floor(), size.height.floor());
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);
    if (pngBytes == null) {
      return;
    }

    final bytes = pngBytes.buffer.asUint8List();
    final outputImage = image.decodeImage(bytes);
    if (outputImage == null) {
      return;
    }

    final thumbnail = image.copyResize(outputImage, width: 256, height: 256);
    await ref.read(avatarProvider).saveUserAvatarThumbnail(thumbnail);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black),
      sized: false,
      child: SideSwapScaffold(
        onWillPop: () async {
          if (resizerData.onBack != null) {
            await resizerData.onBack!(context);
          }
          return false;
        },
        sideSwapBackground: false,
        backgroundColor: Colors.black,
        appBar: CustomAppBar(
          title: 'Size setting'.tr(),
          onPressed: () async {
            if (resizerData.onBack != null) {
              await resizerData.onBack!(context);
            }
          },
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: AvatarResizer(),
            ),
            Expanded(child: Container()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CustomBigButton(
                width: double.maxFinite,
                height: 54,
                text: 'SAVE'.tr(),
                backgroundColor: SideSwapColors.brightTurquoise,
                onPressed: () async {
                  await generateThumbnail(ref);
                  final thumbnail =
                      await ref.read(avatarProvider).getUserAvatarThumbnail();
                  if (thumbnail != null) {
                    await ref.read(avatarProvider).uploadAvatar();
                    if (resizerData.onSave != null) {
                      await resizerData.onSave!(context);
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 40)
          ],
        ),
      ),
    );
  }
}

class AvatarResizer extends StatelessWidget {
  const AvatarResizer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 375,
      child: DragImage(
        position: Offset(0, 0),
      ),
    );
  }
}

class DragImage extends ConsumerStatefulWidget {
  const DragImage({
    super.key,
    required this.position,
  });

  final Offset position;

  @override
  DragImageState createState() => DragImageState();
}

class DragImageState extends ConsumerState<DragImage> {
  late UserAvatarData _data;

  @override
  void initState() {
    Future.microtask(
      () async => _data = await ref.read(avatarProvider).getUserAvatarData(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        _data = ref.watch(avatarProvider).userAvatarData;
        if (_data.uiImage == null) {
          return Container();
        }

        return GestureDetector(
          onScaleStart: _handleScaleStart,
          onScaleUpdate: _handleScaleUpdate,
          onDoubleTap: _handleScaleReset,
          child: Stack(
            children: [
              if (_data.image != null) ...[
                Positioned(
                  left: _data.position.dx,
                  top: _data.position.dy,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 375,
                    child: Transform(
                      transform: Matrix4.diagonal3(
                          vector.Vector3(_data.zoom, _data.zoom, _data.zoom)),
                      alignment: FractionalOffset.center,
                      child: _data.image,
                    ),
                  ),
                ),
              ],
              IgnorePointer(
                child: ClipPath(
                  clipper: InvertedCircleClipper(),
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleScaleStart(ScaleStartDetails start) {
    _data.previousOffset = _data.position - start.focalPoint;
    _data.previousZoom = _data.zoom;
    ref.read(avatarProvider).setUserAvatarData(_data);
  }

  void _handleScaleUpdate(ScaleUpdateDetails update) async {
    _data.zoom = _data.previousZoom * update.scale;
    _data.position = (update.focalPoint + _data.previousOffset);
    ref.read(avatarProvider).setUserAvatarData(_data);
  }

  void _handleScaleReset() {
    _data.zoom = 1.0;
    _data.position = Offset.zero;
    ref.read(avatarProvider).setUserAvatarData(_data);
  }
}

class InvertedCircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(Rect.fromCircle(
          center: Offset(size.width / 2, size.height / 2),
          radius: size.width / 2))
      ..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height))
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
