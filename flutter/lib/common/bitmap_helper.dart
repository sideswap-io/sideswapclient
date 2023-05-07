import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BitmapHelper {
  static Future<Image> getImageFromSvgAsset(
      String svgAssetLink, double width, double height) async {
    final unit8List =
        await getPngBufferFromSvgAsset(svgAssetLink, width, height);
    return Image.memory(
      unit8List,
      width: width,
      height: height,
      filterQuality: FilterQuality.high,
    );
  }

  static Future<Image> getImageFromSvgString(
      String svgString, double width, double height) async {
    final unit8List = await getPngBufferFromSvgString(svgString, width, height);
    return Image.memory(
      unit8List,
      width: width,
      height: height,
      filterQuality: FilterQuality.high,
    );
  }

  static Future<Uint8List> getPngBufferFromSvgAsset(
      String svgAssetLink, double width, double height) async {
    final svgString = await rootBundle.loadString(svgAssetLink);
    return getPngBufferFromSvgString(svgString, width, height);
  }

  static Future<Uint8List> getPngBufferFromSvgString(
      String svgString, double width, double height) async {
    final pictureInfo =
        await getPictureInfoFromString(svgString, width, height);
    final bytes = await getSizedSvgImageBytes(pictureInfo, width, height);
    pictureInfo.picture.dispose();

    return bytes;
  }

  static Future<ui.Image> getSvgImageFromAssets(String svgAssertLink) async {
    final svgString = await rootBundle.loadString(svgAssertLink);

    final PictureInfo pictureInfo =
        await vg.loadPicture(SvgStringLoader(svgString), null);
    final image = await pictureInfo.picture.toImage(
        pictureInfo.size.width.toInt(), pictureInfo.size.height.toInt());
    pictureInfo.picture.dispose();
    return image;
  }

  static Future<PictureInfo> getPictureInfoFromString(
      String svgString, double width, double height) async {
    return vg.loadPicture(SvgStringLoader(svgString), null);
  }

  static Future<Uint8List> getSizedSvgImageBytes(
      PictureInfo pictureInfo, double width, double height) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    canvas.scale(width / pictureInfo.size.width);
    canvas.drawPicture(pictureInfo.picture);
    final ui.Picture rasterPicture = recorder.endRecording();
    final ui.Image pending =
        rasterPicture.toImageSync(width.round(), height.round());

    final imageBytes = await pending.toByteData(format: ui.ImageByteFormat.png);
    return imageBytes?.buffer.asUint8List() ?? Uint8List(0);
  }
}
