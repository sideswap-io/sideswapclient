import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/receive_address_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

void main() {
  group('ReceiveAddress', () {
    group('copyWith', () {
      test('replaces account when provided', () {
        final original =
            ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        final copy = original.copyWith(account: Account.AMP_);
        expect(copy.account, Account.AMP_);
        expect(copy.recvAddress, 'abc');
      });

      test('replaces recvAddress when provided', () {
        final original =
            ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        final copy = original.copyWith(recvAddress: 'xyz');
        expect(copy.account, Account.REG);
        expect(copy.recvAddress, 'xyz');
      });

      test('preserves original values when no params provided', () {
        final original =
            ReceiveAddress(account: Account.REG, recvAddress: 'abcd');
        final copy = original.copyWith();
        expect(copy.account, Account.REG);
        expect(copy.recvAddress, 'abcd');
      });
    });

    group('recvAddressList', () {
      test('returns empty list for empty address', () {
        final addr = ReceiveAddress(account: Account.REG, recvAddress: '');
        expect(addr.recvAddressList, isEmpty);
      });

      test('splits address into chunks of 4 when length divisible by 4', () {
        final addr =
            ReceiveAddress(account: Account.REG, recvAddress: 'abcdefgh');
        expect(addr.recvAddressList, ['abcd', 'efgh']);
      });

      test('last chunk is shorter when length not divisible by 4', () {
        final addr =
            ReceiveAddress(account: Account.REG, recvAddress: 'abcde');
        expect(addr.recvAddressList, ['abcd', 'e']);
      });
    });

    group('equality', () {
      test('identical instance is equal to itself', () {
        final addr = ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        // ignore: unrelated_type_equality_checks
        expect(addr == addr, isTrue);
      });

      test('instances with same values are equal', () {
        final a = ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        final b = ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        expect(a, equals(b));
      });

      test('instances with different recvAddress are not equal', () {
        final a = ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        final b = ReceiveAddress(account: Account.REG, recvAddress: 'xyz');
        expect(a, isNot(equals(b)));
      });

      test('hashCode is consistent for equal instances', () {
        final a = ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        final b = ReceiveAddress(account: Account.REG, recvAddress: 'abc');
        expect(a.hashCode, equals(b.hashCode));
      });
    });

    test('toString includes account and recvAddress values', () {
      final addr = ReceiveAddress(account: Account.REG, recvAddress: 'abc123');
      final s = addr.toString();
      expect(s, contains('abc123'));
    });
  });

  group('CurrentReceiveAddress', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initial state has REG account and empty address', () {
        final state = container.read(currentReceiveAddressProvider);
        expect(state.account, Account.REG);
        expect(state.recvAddress, '');
      });
    });

    group('setRecvAddress', () {
      test('updates state to the provided address', () {
        final addr =
            ReceiveAddress(account: Account.AMP_, recvAddress: 'test123');
        container
            .read(currentReceiveAddressProvider.notifier)
            .setRecvAddress(addr);
        expect(container.read(currentReceiveAddressProvider), equals(addr));
      });
    });
  });

  group('RegularAccountAddresses', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer.test();
      addTearDown(container.dispose);
    });

    group('build', () {
      test('initial state is empty list', () {
        expect(container.read(regularAccountAddressesProvider), isEmpty);
      });
    });

    group('insertAddress', () {
      test('inserts address with REG account', () {
        final addr =
            ReceiveAddress(account: Account.REG, recvAddress: 'addr1');
        container
            .read(regularAccountAddressesProvider.notifier)
            .insertAddress(addr);
        expect(container.read(regularAccountAddressesProvider), [addr]);
      });

      test('ignores address with non-REG account', () {
        final addr =
            ReceiveAddress(account: Account.AMP_, recvAddress: 'addr1');
        container
            .read(regularAccountAddressesProvider.notifier)
            .insertAddress(addr);
        expect(container.read(regularAccountAddressesProvider), isEmpty);
      });

      test('accumulates multiple REG addresses in insertion order', () {
        final addr1 =
            ReceiveAddress(account: Account.REG, recvAddress: 'addr1');
        final addr2 =
            ReceiveAddress(account: Account.REG, recvAddress: 'addr2');
        final notifier =
            container.read(regularAccountAddressesProvider.notifier);
        notifier.insertAddress(addr1);
        notifier.insertAddress(addr2);
        expect(
          container.read(regularAccountAddressesProvider),
          [addr1, addr2],
        );
      });
    });
  });
}
