import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as image;
import 'package:vector_math/vector_math_64.dart' as vector;

import 'package:sideswap/common/screen_utils.dart';
import 'package:sideswap/common/widgets/custom_app_bar.dart';
import 'package:sideswap/common/widgets/custom_big_button.dart';
import 'package:sideswap/common/widgets/side_swap_scaffold.dart';
import 'package:sideswap/models/avatar_provider.dart';
import 'package:sideswap/models/wallet.dart';

typedef ImageFakeCanvas = Future<void> Function();
typedef OnBack = Future<void> Function(BuildContext context);
typedef OnSave = Future<void> Function(BuildContext context);

class ImportAvatarResizerData {
  final OnBack? onBack;
  final OnSave? onSave;

  ImportAvatarResizerData({this.onBack, this.onSave});
}

class ImportAvatarResizer extends StatefulWidget {
  ImportAvatarResizer({Key? key, this.resizerData}) : super(key: key);

  final ImportAvatarResizerData? resizerData;

  @override
  _ImportAvatarResizerState createState() => _ImportAvatarResizerState();
}

class _ImportAvatarResizerState extends State<ImportAvatarResizer> {
  late ImportAvatarResizerData resizerData;

  @override
  void initState() {
    super.initState();
    if (widget.resizerData == null) {
      resizerData = ImportAvatarResizerData(
        onBack: (context) async {
          Navigator.of(context).pop();
          context.read(walletProvider).setImportAvatar();
        },
        onSave: (context) async {
          Navigator.of(context).pop();
          context.read(walletProvider).setImportAvatarSuccess();
        },
      );
    } else {
      resizerData = widget.resizerData!;
    }
  }

  Future<void> generateThumbnail() async {
    final data = context.read(avatarProvider).userAvatarData;
    if (data.uiImage == null) {
      return;
    }

    final position = data.position;
    final size = Size(MediaQuery.of(context).size.width, 375.h);

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
    final outputImage = image.decodeImage(bytes.toList());
    if (outputImage == null) {
      return;
    }

    final thumbnail = image.copyResize(outputImage, width: 256);
    await context.read(avatarProvider).saveUserAvatarThumbnail(thumbnail);
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
            Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: AvatarResizer(),
            ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomBigButton(
                width: double.maxFinite,
                height: 54.h,
                text: 'SAVE'.tr(),
                backgroundColor: Color(0xFF00C5FF),
                onPressed: () async {
                  await generateThumbnail();
                  final thumbnail = await context
                      .read(avatarProvider)
                      .getUserAvatarThumbnail();
                  if (thumbnail != null) {
                    await context.read(avatarProvider).uploadAvatar();
                    if (resizerData.onSave != null) {
                      await resizerData.onSave!(context);
                    }
                  }
                },
              ),
            ),
            SizedBox(
              height: 40.h,
            )
          ],
        ),
      ),
    );
  }
}

class AvatarResizer extends StatelessWidget {
  AvatarResizer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 375.h,
      child: DragImage(
        position: Offset(0, 0),
      ),
    );
  }
}

class DragImage extends StatefulWidget {
  DragImage({
    required this.position,
  });

  final Offset position;

  @override
  DragImageState createState() => DragImageState();
}

class DragImageState extends State<DragImage> {
  late UserAvatarData _data;

  @override
  void initState() {
    Future.microtask(
      () async =>
          _data = await context.read(avatarProvider).getUserAvatarData(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        _data = watch(avatarProvider).userAvatarData;
        if (_data.uiImage == null) {
          return Container();
        }

        return Container(
          child: GestureDetector(
            onScaleStart: _handleScaleStart,
            onScaleUpdate: _handleScaleUpdate,
            onDoubleTap: _handleScaleReset,
            child: Stack(
              children: [
                if (_data.image != null) ...[
                  Positioned(
                    left: _data.position.dx,
                    top: _data.position.dy,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 375.h,
                      color: Colors.red,
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
          ),
        );
      },
    );
  }

  void _handleScaleStart(ScaleStartDetails start) {
    _data.previousOffset = _data.position - start.focalPoint;
    _data.previousZoom = _data.zoom;
    context.read(avatarProvider).setUserAvatarData(_data);
  }

  void _handleScaleUpdate(ScaleUpdateDetails update) async {
    _data.zoom = _data.previousZoom * update.scale;
    _data.position = (update.focalPoint + _data.previousOffset);
    context.read(avatarProvider).setUserAvatarData(_data);
  }

  void _handleScaleReset() {
    _data.zoom = 1.0;
    _data.position = Offset.zero;
    context.read(avatarProvider).setUserAvatarData(_data);
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
