import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/amp_id_provider.dart';

import '../utils.dart';

void main() {
  group('AmpIdNotifier', () {
    test('initial state is an empty string', () {
      final ref = createContainer();
      final ampId = ref.read(ampIdNotifierProvider);
      expect(ampId, '');
    });

    test('setAmpId updates the state', () {
      final ref = createContainer();
      final ampIdNotifierListener = ProviderListener();
      ref.listen(
        ampIdNotifierProvider,
        ampIdNotifierListener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => ampIdNotifierListener(null, '')]);
      verifyNoMoreInteractions(ampIdNotifierListener);

      final notifier = ref.read(ampIdNotifierProvider.notifier);

      const newAmpId = 'test_amp_id';
      notifier.setAmpId(newAmpId);
      verifyInOrder([() => ampIdNotifierListener('', 'test_amp_id')]);
      verifyNoMoreInteractions(ampIdNotifierListener);

      expect(ref.read(ampIdNotifierProvider), newAmpId);

      const newAmpId2 = 'test_amp_id2';
      notifier.setAmpId(newAmpId2);
      verifyInOrder([() => ampIdNotifierListener(newAmpId, newAmpId2)]);
      verifyNoMoreInteractions(ampIdNotifierListener);

      expect(ref.read(ampIdNotifierProvider), newAmpId2);
    });
  });
}
