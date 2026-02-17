import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/amp_id_provider.dart';

import '../utils.dart';

void main() {
  group('AmpIdNotifier', () {
    test('initial state is an empty string', () {
      final ref = ProviderContainer.test();
      final ampId = ref.read(ampIdProvider);
      expect(ampId, '');
    });

    test('setAmpId updates the state', () {
      final ref = ProviderContainer.test();
      final ampIdNotifierListener = ProviderListener();
      ref.listen(
        ampIdProvider,
        ampIdNotifierListener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => ampIdNotifierListener(null, '')]);
      verifyNoMoreInteractions(ampIdNotifierListener);

      final notifier = ref.read(ampIdProvider.notifier);

      const newAmpId = 'test_amp_id';
      notifier.setAmpId(newAmpId);
      verifyInOrder([() => ampIdNotifierListener('', 'test_amp_id')]);
      verifyNoMoreInteractions(ampIdNotifierListener);

      expect(ref.read(ampIdProvider), newAmpId);

      const newAmpId2 = 'test_amp_id2';
      notifier.setAmpId(newAmpId2);
      verifyInOrder([() => ampIdNotifierListener(newAmpId, newAmpId2)]);
      verifyNoMoreInteractions(ampIdNotifierListener);

      expect(ref.read(ampIdProvider), newAmpId2);
    });
  });
}
