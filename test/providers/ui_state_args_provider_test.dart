import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/ui_state_args_provider.dart';

import '../utils.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(WalletMainArguments(
      currentIndex: 0,
      navigationItemEnum: WalletMainNavigationItemEnum.home,
    ));
  });
  group('WalletMainArguments', () {
    group('fromIndex', () {
      final testCases = [
        (index: 0, expectedEnum: WalletMainNavigationItemEnum.home),
        (index: 1, expectedEnum: WalletMainNavigationItemEnum.accounts),
        (index: 2, expectedEnum: WalletMainNavigationItemEnum.markets),
        (index: 3, expectedEnum: WalletMainNavigationItemEnum.swap),
        (index: 4, expectedEnum: WalletMainNavigationItemEnum.pegs),
        (index: 5, expectedEnum: WalletMainNavigationItemEnum.addresses),
        (index: 6, expectedEnum: WalletMainNavigationItemEnum.home), // out of range
        (index: 100, expectedEnum: WalletMainNavigationItemEnum.home), // out of range
        (index: -1, expectedEnum: WalletMainNavigationItemEnum.home), // out of range
      ];

      for (final c in testCases) {
        test('maps index ${c.index} to ${c.expectedEnum.name}', () {
          final args = WalletMainArguments(
            currentIndex: 0,
            navigationItemEnum: WalletMainNavigationItemEnum.home,
          );
          final result = args.fromIndex(c.index);

          expect(result.currentIndex, c.index);
          expect(result.navigationItemEnum, c.expectedEnum);
          expect(result.arguments, isNull);
        });
      }

      test('preserves arguments when changing index', () {
        const arguments = {'key': 'value'};
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: arguments,
        );

        final result = args.fromIndex(3);

        expect(result.currentIndex, 3);
        expect(result.navigationItemEnum, WalletMainNavigationItemEnum.swap);
        expect(result.arguments, arguments);
      });

      test('returns new instance', () {
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final result = args.fromIndex(1);

        expect(identical(args, result), false);
      });
    });

    group('fromIndexDesktop', () {
      final testCases = [
        (index: 0, expectedEnum: WalletMainNavigationItemEnum.home),
        (index: 1, expectedEnum: WalletMainNavigationItemEnum.markets),
        (index: 2, expectedEnum: WalletMainNavigationItemEnum.swap),
        (index: 3, expectedEnum: WalletMainNavigationItemEnum.transactions),
        (index: 4, expectedEnum: WalletMainNavigationItemEnum.pegs),
        (index: 5, expectedEnum: WalletMainNavigationItemEnum.addresses),
        (index: 6, expectedEnum: WalletMainNavigationItemEnum.home), // out of range
        (index: 100, expectedEnum: WalletMainNavigationItemEnum.home), // out of range
        (index: -1, expectedEnum: WalletMainNavigationItemEnum.home), // out of range
      ];

      for (final c in testCases) {
        test('maps index ${c.index} to ${c.expectedEnum.name}', () {
          final args = WalletMainArguments(
            currentIndex: 0,
            navigationItemEnum: WalletMainNavigationItemEnum.home,
          );
          final result = args.fromIndexDesktop(c.index);

          expect(result.currentIndex, c.index);
          expect(result.navigationItemEnum, c.expectedEnum);
          expect(result.arguments, isNull);
        });
      }

      test('maps different items than fromIndex', () {
        // Index 1: accounts (mobile) vs markets (desktop)
        // Index 3: swap (mobile) vs transactions (desktop)
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final mobileResult = args.fromIndex(1);
        final desktopResult = args.fromIndexDesktop(1);

        expect(mobileResult.navigationItemEnum,
            WalletMainNavigationItemEnum.accounts);
        expect(desktopResult.navigationItemEnum,
            WalletMainNavigationItemEnum.markets);
      });

      test('preserves arguments when changing index', () {
        const arguments = {'key': 'value'};
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: arguments,
        );

        final result = args.fromIndexDesktop(3);

        expect(result.currentIndex, 3);
        expect(result.navigationItemEnum,
            WalletMainNavigationItemEnum.transactions);
        expect(result.arguments, arguments);
      });

      test('returns new instance', () {
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final result = args.fromIndexDesktop(1);

        expect(identical(args, result), false);
      });
    });

    group('copyWith', () {
      test('updates currentIndex when provided', () {
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final result = args.copyWith(currentIndex: 3);

        expect(result.currentIndex, 3);
        expect(result.navigationItemEnum, WalletMainNavigationItemEnum.home);
      });

      test('updates navigationItemEnum when provided', () {
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final result = args.copyWith(
          navigationItemEnum: WalletMainNavigationItemEnum.swap,
        );

        expect(result.currentIndex, 0);
        expect(result.navigationItemEnum, WalletMainNavigationItemEnum.swap);
      });

      test('updates arguments when provided', () {
        const newArgs = {'updated': true};
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final result = args.copyWith(arguments: newArgs);

        expect(result.currentIndex, 0);
        expect(result.navigationItemEnum, WalletMainNavigationItemEnum.home);
        expect(result.arguments, newArgs);
      });

      test('updates multiple fields at once', () {
        const newArgs = {'updated': true};
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final result = args.copyWith(
          currentIndex: 5,
          navigationItemEnum: WalletMainNavigationItemEnum.addresses,
          arguments: newArgs,
        );

        expect(result.currentIndex, 5);
        expect(result.navigationItemEnum,
            WalletMainNavigationItemEnum.addresses);
        expect(result.arguments, newArgs);
      });

      test('preserves original values when no fields provided', () {
        const originalArgs = {'original': true};
        final args = WalletMainArguments(
          currentIndex: 2,
          navigationItemEnum: WalletMainNavigationItemEnum.swap,
          arguments: originalArgs,
        );

        final result = args.copyWith();

        expect(result.currentIndex, 2);
        expect(result.navigationItemEnum, WalletMainNavigationItemEnum.swap);
        expect(result.arguments, originalArgs);
      });

      test('returns new instance', () {
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        final result = args.copyWith(currentIndex: 1);

        expect(identical(args, result), false);
      });

      test('replaces null arguments', () {
        const newArgs = {'new': 'args'};
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: null,
        );

        final result = args.copyWith(arguments: newArgs);

        expect(result.arguments, newArgs);
      });
    });

    group('equality', () {
      test('instances with same values are equal', () {
        final args1 = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
        );
        final args2 = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
        );

        expect(args1, args2);
      });

      test('instances with different currentIndex are not equal', () {
        final args1 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );
        final args2 = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        expect(args1, isNot(args2));
      });

      test('instances with different navigationItemEnum are not equal', () {
        final args1 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );
        final args2 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
        );

        expect(args1, isNot(args2));
      });

      test('instances with different arguments are not equal', () {
        final args1 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: {'key': 'value1'},
        );
        final args2 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: {'key': 'value2'},
        );

        expect(args1, isNot(args2));
      });

      test('instance equals itself', () {
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );

        expect(args, args);
      });

      test('instance with null arguments equals another with null arguments', () {
        final args1 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: null,
        );
        final args2 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: null,
        );

        expect(args1, args2);
      });

      test('hashCode is same for equal instances', () {
        const sameArgs = {'id': 123};
        final args1 = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
          arguments: sameArgs,
        );
        final args2 = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
          arguments: sameArgs,
        );

        expect(args1.hashCode, args2.hashCode);
      });

      test('hashCode differs for different instances', () {
        final args1 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );
        final args2 = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
        );

        expect(args1.hashCode, isNot(args2.hashCode));
      });
    });

    group('toString', () {
      test('returns formatted string representation', () {
        final args = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
          arguments: {'id': 123},
        );

        final result = args.toString();

        expect(result, contains('WalletMainArguments'));
        expect(result, contains('currentIndex: 1'));
        expect(result, contains('WalletMainNavigationItemEnum.accounts'));
        expect(result, contains('arguments'));
      });

      test('includes null arguments in string', () {
        final args = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
          arguments: null,
        );

        final result = args.toString();

        expect(result, contains('arguments: null'));
      });
    });
  });

  group('UiStateArgsNotifier', () {
    group('build', () {
      test('returns initial WalletMainArguments with home index', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final result = container.read(uiStateArgsProvider);

        expect(result.currentIndex, 0);
        expect(result.navigationItemEnum,
            WalletMainNavigationItemEnum.home);
        expect(result.arguments, isNull);
      });

      test('creates new instance each time', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final result1 = container.read(uiStateArgsProvider);
        final result2 = container.read(uiStateArgsProvider);

        // State should be same instance due to caching
        expect(identical(result1, result2), true);
      });
    });

    group('setWalletMainArguments', () {
      test('updates state with new arguments', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final newArgs = WalletMainArguments(
          currentIndex: 2,
          navigationItemEnum: WalletMainNavigationItemEnum.swap,
          arguments: {'test': 'data'},
        );

        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(newArgs);

        expect(container.read(uiStateArgsProvider), newArgs);
      });

      test('triggers state change listeners when state is updated', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final listener = ProviderListener<WalletMainArguments>();
        final sub = container.listen(uiStateArgsProvider, listener.call);

        final newArgs = WalletMainArguments(
          currentIndex: 3,
          navigationItemEnum: WalletMainNavigationItemEnum.swap,
        );
        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(newArgs);

        // Verify listener was called with the new state
        verify(() => listener(any(), any())).called(1);

        // Verify the state was updated
        expect(sub.read().currentIndex, 3);
        expect(sub.read().navigationItemEnum,
            WalletMainNavigationItemEnum.swap);
      });

      test('accepts arguments with null fields', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final newArgs = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
          arguments: null,
        );

        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(newArgs);

        expect(container.read(uiStateArgsProvider), newArgs);
        expect(container.read(uiStateArgsProvider).arguments, isNull);
      });

      test('replaces previous state completely', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final firstArgs = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
          arguments: {'original': 'data'},
        );
        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(firstArgs);

        final secondArgs = WalletMainArguments(
          currentIndex: 4,
          navigationItemEnum: WalletMainNavigationItemEnum.pegs,
          arguments: null,
        );
        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(secondArgs);

        final finalState =
            container.read(uiStateArgsProvider);
        expect(finalState.currentIndex, 4);
        expect(finalState.navigationItemEnum,
            WalletMainNavigationItemEnum.pegs);
        expect(finalState.arguments, isNull);
      });

      test('can set arguments multiple times in sequence', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final args1 = WalletMainArguments(
          currentIndex: 0,
          navigationItemEnum: WalletMainNavigationItemEnum.home,
        );
        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(args1);
        expect(container.read(uiStateArgsProvider), args1);

        final args2 = WalletMainArguments(
          currentIndex: 1,
          navigationItemEnum: WalletMainNavigationItemEnum.accounts,
        );
        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(args2);
        expect(container.read(uiStateArgsProvider), args2);

        final args3 = WalletMainArguments(
          currentIndex: 2,
          navigationItemEnum: WalletMainNavigationItemEnum.markets,
        );
        container.read(uiStateArgsProvider.notifier)
            .setWalletMainArguments(args3);
        expect(container.read(uiStateArgsProvider), args3);
      });
    });
  });
}
