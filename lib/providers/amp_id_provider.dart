import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'amp_id_provider.g.dart';

@Riverpod(keepAlive: true)
class AmpIdNotifier extends _$AmpIdNotifier {
  @override
  String build() {
    return '';
  }

  void setAmpId(String ampId) {
    state = ampId;
  }
}
