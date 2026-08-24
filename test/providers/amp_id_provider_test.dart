import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/providers/amp_id_provider.dart';

import '../utils.dart';

void main() {
  group('AmpIdNotifier', () {
    test('emits the default amp id and the updated value when set', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<String>();

      container.listen(
        ampIdProvider,
        listener.call,
        fireImmediately: true,
      );

      verifyInOrder([() => listener(null, '')]);
      verifyNoMoreInteractions(listener);

      final notifier = container.read(ampIdProvider.notifier);

      const newAmpId = 'test_amp_id';
      notifier.setAmpId(newAmpId);

      verifyInOrder([() => listener('', newAmpId)]);
      verifyNoMoreInteractions(listener);
      expect(container.read(ampIdProvider), newAmpId);
    });
  });
}
