import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/app_state_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CurrentAppLifecycle', () {
    test('initial state is none', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      expect(
        container.read(currentAppLifecycleProvider),
        const Option<AppLifecycleState>.none(),
      );
    });

    test('state can be set directly via notifier', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      container.read(currentAppLifecycleProvider.notifier).state =
          const Option.of(AppLifecycleState.paused);

      expect(
        container.read(currentAppLifecycleProvider),
        const Option.of(AppLifecycleState.paused),
      );
    });

    test('listener receives state changes', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      final states = <Option<AppLifecycleState>>[];
      container.listen(currentAppLifecycleProvider, (_, next) {
        states.add(next);
      });

      final notifier = container.read(currentAppLifecycleProvider.notifier);
      notifier.state = const Option.of(AppLifecycleState.resumed);
      notifier.state = const Option.of(AppLifecycleState.paused);

      expect(states, [
        const Option.of(AppLifecycleState.resumed),
        const Option.of(AppLifecycleState.paused),
      ]);
    });

    testWidgets('observer forwards platform lifecycle events', (tester) async {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);

      // Activate the provider so observer is registered
      container.listen(currentAppLifecycleProvider, (_, _) {});

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);

      expect(
        container.read(currentAppLifecycleProvider),
        const Option.of(AppLifecycleState.paused),
      );

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

      expect(
        container.read(currentAppLifecycleProvider),
        const Option.of(AppLifecycleState.resumed),
      );
    });

    testWidgets('observer is removed on dispose', (tester) async {
      final container = ProviderContainer.test();

      // Activate provider to register observer
      container.listen(currentAppLifecycleProvider, (_, _) {});

      container.dispose();

      // Should not throw — observer was removed
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    });
  });
}
