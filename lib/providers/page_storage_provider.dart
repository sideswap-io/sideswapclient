import 'dart:convert';
import 'dart:math';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'page_storage_provider.g.dart';

@Riverpod(keepAlive: true)
class PageStorageKeyData extends _$PageStorageKeyData {
  @override
  String build() {
    return getRandString(5);
  }

  String getRandString(int len) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
