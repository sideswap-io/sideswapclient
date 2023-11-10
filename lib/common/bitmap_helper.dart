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
    final image = await pictureInfo.picture.toImage(
        pictureInfo.size.width.round(), pictureInfo.size.height.round());
    final imageBytes = await image.toByteData(format: ui.ImageByteFormat.png);

    final byteData = imageBytes?.buffer.asUint8List() ?? Uint8List(0);
    return byteData;
  }

  static Future<Uint8List> getResizedImageFromBase64OrAssetName(
    String? assetSvg,
    String? base64,
    double width,
    double height,
  ) async {
    if (base64 != null) {
      const converter = Base64Decoder();
      final imageBytes = converter.convert(base64);
      final img = image.decodeImage(imageBytes);
      if (img == null) {
        return Uint8List(0);
      }
      final resized = image.copyResize(
        img,
        width: width.ceil(),
        height: height.ceil(),
        maintainAspect: true,
        interpolation: image.Interpolation.average,
      );
      ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resized));
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      final resizedBytes =
          await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
      final byteData = resizedBytes?.buffer.asUint8List() ?? Uint8List(0);
      return byteData;
      // return imageBytes;
    } else if (assetSvg != null && assetSvg.isNotEmpty) {
      return BitmapHelper.getPngBufferFromSvgAsset(assetSvg, width, height);
    }

    return Uint8List(0);
  }
}
