import 'package:hooks_riverpod/hooks_riverpod.dart';

final ampIdProvider = AutoDisposeStateProvider((ref) {
  ref.keepAlive();
  return '';
});
