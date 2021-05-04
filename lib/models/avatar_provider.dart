import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:sideswap/common/utils/custom_logger.dart';
import 'package:sideswap/models/wallet.dart';

class UserAvatarData {
  double zoom;
  double previousZoom;
  Offset previousOffset;
  Offset position;
  Image image;
  ui.Image uiImage;

  @override
  String toString() {
    return 'UserAvatarData(zoom: $zoom, previousZoom: $previousZoom, previousOffset: $previousOffset, position: $position, image: $image, uiImage: $uiImage)';
  }
}

final avatarProvider = ChangeNotifierProvider<AvatarProvider>((ref) {
  logger.d('Initialize Avatar Provider');
  return AvatarProvider(ref.read);
});

class AvatarProvider with ChangeNotifier {
  AvatarProvider(this.read);

  final Reader read;

  final _picker = ImagePicker();
  Object avatarProviderError;

  PickedFile pickedFile;
  UserAvatarData userAvatarData;
  image.Image _userThumbnail;

  Future<bool> loadCameraImage() async {
    pickedFile = await _loadImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      return true;
    }

    return false;
  }

  Future<bool> loadGalleryImage() async {
    pickedFile = await _loadImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return true;
    }

    return false;
  }

  Future<PickedFile> _loadImage({
    ImageSource source,
    CameraDevice preferredCameraDevice = CameraDevice.front,
  }) async {
    PickedFile pickedFile;
    avatarProviderError = null;

    try {
      pickedFile = await _picker.getImage(
        source: source,
        preferredCameraDevice: preferredCameraDevice,
      );
    } catch (e) {
      logger.e(e);
      avatarProviderError = e;
    }

    notifyListeners();

    return pickedFile;
  }

  Future<UserAvatarData> getUserAvatarData() async {
    imageCache.clearLiveImages();
    final uintList = await File(pickedFile.path).readAsBytes();
    final codec = await ui.instantiateImageCodec(uintList);
    final uiImage = (await codec.getNextFrame()).image;
    final image = Image.memory(uintList);
    final data = UserAvatarData()
      ..image = image
      ..uiImage = uiImage
      ..position = Offset.zero
      ..previousOffset = Offset.zero
      ..previousZoom = null
      ..zoom = 1.0;

    setUserAvatarData(data);

    return data;
  }

  void setUserAvatarData(UserAvatarData data) {
    userAvatarData = data;

    notifyListeners();
  }

  Future<void> saveUserAvatarThumbnail(image.Image thumbnail) async {
    _userThumbnail = thumbnail;

    if (_userThumbnail != null) {
      final storageDirectory = await getExternalStorageDirectory();

      final file = File('${storageDirectory.path}/avatar.jpg');
      file.writeAsBytesSync(image.encodeJpg(thumbnail));
      logger.d('Saving user avatar: ${file.path}');
    }
  }

  Future<image.Image> getUserAvatarImage() async {
    if (_userThumbnail != null) {
      logger.d('Loading user avatar from memory');
      return _userThumbnail;
    }

    final storageDirectory = await getExternalStorageDirectory();
    logger.d('Loading user avatar from disk: ${storageDirectory.path}');
    final file = File('${storageDirectory.path}/avatar.jpg');
    _userThumbnail = image.decodeJpg(file.readAsBytesSync().toList());

    return _userThumbnail;
  }

  Future<Image> getUserAvatarThumbnail() async {
    final thumbnail = await getUserAvatarImage();
    final bytes = Uint8List.fromList(image.encodeJpg(thumbnail));
    return Image.memory(bytes);
  }

  void uploadAvatar() async {
    final img = await getUserAvatarImage();
    final bytes = image.encodeJpg(img);
    final avatarString = base64Encode(bytes);
    read(walletProvider).uploadAvatar(avatar: avatarString);
  }
}
