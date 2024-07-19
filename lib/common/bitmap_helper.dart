import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image/image.dart' as image;

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
    final image = await pictureInfo.picture
        .toImage(pictureInfo.size.width.ceil(), pictureInfo.size.height.ceil());
    pictureInfo.picture.dispose();
    return image;
  }

  static Future<PictureInfo> getPictureInfoFromString(
      String svgString, double width, double height) async {
    return vg.loadPicture(SvgStringLoader(svgString), null);
  }

  static Future<Uint8List> getSizedSvgImageBytes(
      PictureInfo pictureInfo, double width, double height) async {
    /// (malcolmpl): not working on ubuntu 24.04 - crash in nvidia drivers 535.171.04
    /// issue solved by: https://github.com/flutter/flutter/issues/148364
    /// not cherry picked to next release fix :|
    final image = await pictureInfo.picture.toImage(
        pictureInfo.size.width.round(), pictureInfo.size.height.round());
    final imageBytes = await image.toByteData(format: ui.ImageByteFormat.png);

    final byteData = imageBytes?.buffer.asUint8List() ?? Uint8List(0);
    return byteData;

    /// (malcolmpl): paint svg picture in resized canvas and return png image bytes
    // final ui.Picture picture = pictureInfo.picture;
    // final ui.PictureRecorder recorder = ui.PictureRecorder();
    // final ui.Canvas canvas =
    //     Canvas(recorder, Rect.fromPoints(Offset.zero, Offset(width, height)));
    // canvas.scale(
    //     width / pictureInfo.size.width, height / pictureInfo.size.height);
    // canvas.drawPicture(picture);
    // final ui.Image imgByteData =
    //     await recorder.endRecording().toImage(width.ceil(), height.ceil());
    // final ByteData? bytesData =
    //     await imgByteData.toByteData(format: ui.ImageByteFormat.png);
    // final Uint8List imageData = bytesData?.buffer.asUint8List() ?? Uint8List(0);
    // pictureInfo.picture.dispose();
    // return imageData;
  }

  static Future<Uint8List> getResizedImageFromBase64OrAssetName(
    String? assetSvg,
    String? base64,
    double width,
    double height, {
    bool resize = false,
  }) async {
    if (base64 != null) {
      const converter = Base64Decoder();
      final imageBytes = converter.convert(base64);
      final img = image.decodeImage(imageBytes);
      if (img == null) {
        return Uint8List(0);
      }

      image.Image newImage;
      if (img.width <= width || img.height <= height || !resize) {
        newImage = img;
      } else {
        newImage = image.copyResize(
          img,
          width: width.ceil(),
          height: height.ceil(),
          maintainAspect: true,
          interpolation: image.Interpolation.cubic,
        );
      }
      return image.encodePng(newImage);

      /// (malcolmpl) Code below for some reason stopped working on linux since flutter 3.22
      // final pngFile = image.encodePng(newImage);
      // ui.Codec codec = await ui.instantiateImageCodec(pngFile);
      // ui.FrameInfo frameInfo = await codec.getNextFrame();
      // final resizedBytes =
      //     await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      // final byteData = resizedBytes?.buffer.asUint8List() ?? Uint8List(0);
      // frameInfo.image.dispose();
      // codec.dispose();
      // return byteData;
    } else if (assetSvg != null && assetSvg.isNotEmpty) {
      return BitmapHelper.getPngBufferFromSvgAsset(assetSvg, width, height);
    }

    return Uint8List(0);
  }
}
