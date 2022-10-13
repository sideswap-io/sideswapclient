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
    final svgImage = await getSvgImageFromString(svgString, width, height);
    final sizedSvgImage = await getSizedSvgImage(svgImage, width, height);

    final pngSizedBytes =
        await sizedSvgImage.toByteData(format: ui.ImageByteFormat.png);
    if (pngSizedBytes == null) {
      return Uint8List(0);
    }
    return pngSizedBytes.buffer.asUint8List();
  }

  static Future<ui.Image> getSvgImageFromAssets(String svgAssertLink) async {
    final svgString = await rootBundle.loadString(svgAssertLink);
    final drawableRoot = await svg.fromSvgString(svgString, '');
    final picture = drawableRoot.toPicture();
    final image = await picture.toImage(drawableRoot.viewport.width.toInt(),
        drawableRoot.viewport.height.toInt());
    return image;
  }

  static Future<ui.Image> getSvgImageFromString(
      String svgString, double width, double height) async {
    final drawableRoot = await svg.fromSvgString(svgString, '');
    final picture = drawableRoot.toPicture(size: Size(width, height));
    final image = await picture.toImage(width.toInt(), height.toInt());
    return image;
  }

  static Future<ui.Image> getSizedSvgImage(
      ui.Image svgImage, double width, double height) async {
    final svgWidth = width * ui.window.devicePixelRatio;
    final svgHeight = height * ui.window.devicePixelRatio;

    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final svgRect = Rect.fromLTRB(
        0.0, 0.0, svgImage.width.toDouble(), svgImage.height.toDouble());
    final sizedRect =
        Rect.fromLTRB(0.0, 0.0, svgWidth, svgHeight); // our size here
    canvas.drawImageRect(svgImage, svgRect, sizedRect, Paint());
    return await pictureRecorder
        .endRecording()
        .toImage(svgWidth.toInt(), svgHeight.toInt());
  }
}
