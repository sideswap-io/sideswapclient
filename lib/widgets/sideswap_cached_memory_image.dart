import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';

class SideswapCachedMemoryImage extends ConsumerWidget {
  const SideswapCachedMemoryImage({
    super.key,
    required this.uniqueKey,
    this.assetSvg,
    this.base64,
    required this.width,
    required this.height,
    // FilterQuality.medium - a bit lower resolution so scaled down png images looks slightly better than FilterQuality.high
    // this value has no matter for svg images
    this.filterQuality = FilterQuality.medium,
  });

  final String uniqueKey;
  final String? assetSvg;
  final String? base64;
  final double width;
  final double height;
  final FilterQuality filterQuality;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageBytes = ref.watch(
      imageBytesResizedFutureProvider(
        uniqueKey: uniqueKey,
        assetSvg: assetSvg,
        base64: base64,
        width: width,
        height: height,
      ),
    );

    return switch (imageBytes) {
      AsyncData(hasValue: true, value: Uint8List bytes) when bytes.isNotEmpty =>
        Image.memory(
          bytes,
          width: width,
          height: height,
          filterQuality: filterQuality,
          isAntiAlias: true,
        ),
      AsyncLoading() => SizedBox(width: width, height: height),
      _ => FittedBox(child: Icon(Icons.help, size: width)),
    };
  }
}
