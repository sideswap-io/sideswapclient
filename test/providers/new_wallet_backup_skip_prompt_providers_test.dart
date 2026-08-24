import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/new_wallet_backup_skip_prompt_providers.dart';

import '../utils.dart';

void main() {
  group('SkipForNowNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initial state is empty', () {
        final sub = container.listen<SkipForNowState>(
          skipForNowProvider,
          // ignore: unused_parameters
          (previous, next) {},
        );
        expect(
          sub.read(),
          isA<SkipForNowStateEmpty>(),
        );
      });
    });

    group('setSkipState', () {
      test('updates state to skipped', () {
        final sub = container.listen<SkipForNowState>(
          skipForNowProvider,
          // ignore: unused_parameters
          (previous, next) {},
        );
        container.read(skipForNowProvider.notifier).setSkipState(
          const SkipForNowState.skipped(),
        );
        expect(
          sub.read(),
          isA<SkipForNowStateSkipped>(),
        );
      });

      test('updates state to empty', () {
        final sub = container.listen<SkipForNowState>(
          skipForNowProvider,
          // ignore: unused_parameters
          (previous, next) {},
        );
        // First set to skipped
        container.read(skipForNowProvider.notifier).setSkipState(
          const SkipForNowState.skipped(),
        );
        // Then back to empty
        container.read(skipForNowProvider.notifier).setSkipState(
          const SkipForNowState.empty(),
        );
        expect(
          sub.read(),
          isA<SkipForNowStateEmpty>(),
        );
      });

      test('notifies listeners on state change to skipped', () {
        final listener = ProviderListener<SkipForNowState>();
        final emptyState = const SkipForNowState.empty();
        final skippedState = const SkipForNowState.skipped();

        container.listen(
          skipForNowProvider,
          listener.call,
          fireImmediately: true,
        );

        // Verify initial notification
        verifyInOrder([
          () => listener(null, emptyState),
        ]);
        verifyNoMoreInteractions(listener);

        container.read(skipForNowProvider.notifier).setSkipState(skippedState);

        // Verify state change notification
        verifyInOrder([
          () => listener(emptyState, skippedState),
        ]);
        verifyNoMoreInteractions(listener);
      });
    });
  });
}
