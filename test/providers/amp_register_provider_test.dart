import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/models/connection_models.dart';
import 'package:sideswap/models/pegx_model.dart';
import 'package:sideswap/models/stokr_model.dart';
import 'package:sideswap/providers/amp_id_provider.dart';
import 'package:sideswap/providers/amp_register_provider.dart';
import 'package:sideswap/providers/connection_state_providers.dart';
import 'package:sideswap/providers/pegx_provider.dart';
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

class MockSideswapWallet extends Mock implements SideswapWallet {}

void main() {
  group('SecuritiesItem', () {
    test('copyWith updates provided fields and preserves omitted fields', () {
      final original = SecuritiesItem(
        token: 'TOKEN',
        icon: 'icon.svg',
        assetId: 'asset-id',
      );

      expect(
        original.copyWith(token: 'UPDATED'),
        SecuritiesItem(token: 'UPDATED', icon: 'icon.svg', assetId: 'asset-id'),
      );
      expect(
        original.copyWith(icon: 'updated.svg', assetId: 'next-id'),
        SecuritiesItem(token: 'TOKEN', icon: 'updated.svg', assetId: 'next-id'),
      );
    });

    test('uses value semantics and a readable string representation', () {
      final item = SecuritiesItem(
        token: 'TOKEN',
        icon: 'icon.svg',
        assetId: 'asset-id',
      );

      expect(item == item, isTrue);
      expect(
        item,
        equals(
          SecuritiesItem(token: 'TOKEN', icon: 'icon.svg', assetId: 'asset-id'),
        ),
      );
      expect(
        item.hashCode,
        SecuritiesItem(
          token: 'TOKEN',
          icon: 'icon.svg',
          assetId: 'asset-id',
        ).hashCode,
      );
      expect(
        item,
        isNot(
          SecuritiesItem(token: 'OTHER', icon: 'icon.svg', assetId: 'asset-id'),
        ),
      );
      expect(
        item.toString(),
        'SecuritiesItem(token: TOKEN, icon: icon.svg, assetId: asset-id)',
      );
    });
  });

  group('stokrSecurities', () {
    test('returns only assets whose domain agent contains stokr.io', () {
      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({
            'stokr-id': createAsset(
              assetId: 'stokr-id',
              ticker: 'STOKR',
              domainAgent: 'issuer.stokr.io',
            ),
            'pegx-id': createAsset(
              assetId: 'pegx-id',
              ticker: 'PEGX',
              domainAgent: 'issuer.pegx.io',
            ),
            'missing-domain': createAsset(
              assetId: 'missing-domain',
              ticker: 'NONE',
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(
        stokrSecuritiesProvider,
        (_, _) {},
      );

      expect(subscription.read(), [
        SecuritiesItem(token: 'STOKR', icon: '', assetId: 'stokr-id'),
      ]);
    });
  });

  group('pegxSecurities', () {
    test('returns only assets whose domain agent contains pegx.io', () {
      final container = ProviderContainer.test(
        overrides: [
          assetsStateProvider.overrideWithValue({
            'pegx-id': createAsset(
              assetId: 'pegx-id',
              ticker: 'SSWP',
              domainAgent: 'issuer.pegx.io',
            ),
            'stokr-id': createAsset(
              assetId: 'stokr-id',
              ticker: 'STOKR',
              domainAgent: 'issuer.stokr.io',
            ),
            'missing-domain': createAsset(
              assetId: 'missing-domain',
              ticker: 'NONE',
            ),
          }),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(pegxSecuritiesProvider, (_, _) {});

      expect(subscription.read(), [
        SecuritiesItem(token: 'SSWP', icon: '', assetId: 'pegx-id'),
      ]);
    });
  });

  group('StokrGaidNotifier', () {
    test('emits the empty state first and then the updated state', () {
      final container = ProviderContainer.test();
      addTearDown(container.dispose);
      final listener = ProviderListener<StokrGaidState>();

      container.listen(stokrGaidProvider, listener.call, fireImmediately: true);

      verifyInOrder([() => listener(null, const StokrGaidStateEmpty())]);
      verifyNoMoreInteractions(listener);

      container
          .read(stokrGaidProvider.notifier)
          .setStokrGaidState(const StokrGaidStateRegistered());

      verifyInOrder([
        () => listener(
          const StokrGaidStateEmpty(),
          const StokrGaidStateRegistered(),
        ),
      ]);
      verifyNoMoreInteractions(listener);
      expect(
        container.read(stokrGaidProvider),
        const StokrGaidStateRegistered(),
      );
    });
  });

  group('checkAmpStatus', () {
    test('derives the login state, amp id, and matching asset ids', () {
      final container = ProviderContainer.test(
        overrides: [
          serverLoginProvider.overrideWithValue(const ServerLoginStateLogin()),
          ampIdProvider.overrideWithValue('amp-id'),
          pegxSecuritiesProvider.overrideWithValue([
            SecuritiesItem(token: 'OTHER', icon: '', assetId: 'other-id'),
            SecuritiesItem(token: 'SSWP', icon: '', assetId: 'pegx-id'),
          ]),
          stokrSecuritiesProvider.overrideWithValue([
            SecuritiesItem(token: 'STOKR', icon: '', assetId: 'stokr-id'),
            SecuritiesItem(token: 'SECOND', icon: '', assetId: 'second-id'),
          ]),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(checkAmpStatusProvider, (_, _) {});
      final value = subscription.read();

      expect(value.ref, same(container.read(checkAmpStatusProvider).ref));
      expect(value.loginState, const ServerLoginStateLogin());
      expect(value.ampId, 'amp-id');
      expect(value.pegxAssetId, 'pegx-id');
      expect(value.stokrAssetId, 'stokr-id');
    });

    test('uses null asset ids when the provider inputs do not match', () {
      final container = ProviderContainer.test(
        overrides: [
          serverLoginProvider.overrideWithValue(const ServerLoginStateLogout()),
          ampIdProvider.overrideWithValue(''),
          pegxSecuritiesProvider.overrideWithValue([
            SecuritiesItem(token: 'OTHER', icon: '', assetId: 'other-id'),
          ]),
          stokrSecuritiesProvider.overrideWithValue(const []),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(checkAmpStatusProvider, (_, _) {});
      final value = subscription.read();

      expect(value.loginState, const ServerLoginStateLogout());
      expect(value.ampId, '');
      expect(value.pegxAssetId, isNull);
      expect(value.stokrAssetId, isNull);
    });
  });

  group('CheckAmpStatusImpl.refreshAmpStatus', () {
    test(
      'sets both gaid providers to loading before checking wallet state',
      () async {
        final wallet = MockSideswapWallet();
        when(() => wallet.checkGaidStatus(any(), any())).thenAnswer((_) {});

        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(wallet),
            serverLoginProvider.overrideWithValue(
              const ServerLoginStateLogout(),
            ),
            ampIdProvider.overrideWithValue('amp-id'),
            pegxSecuritiesProvider.overrideWithValue([
              SecuritiesItem(token: 'SSWP', icon: '', assetId: 'pegx-id'),
            ]),
            stokrSecuritiesProvider.overrideWithValue([
              SecuritiesItem(token: 'STOKR', icon: '', assetId: 'stokr-id'),
            ]),
          ],
        );
        addTearDown(container.dispose);

        final pegxListener = ProviderListener<PegxGaidState>();
        final stokrListener = ProviderListener<StokrGaidState>();
        container.listen(
          pegxGaidProvider,
          pegxListener.call,
          fireImmediately: true,
        );
        container.listen(
          stokrGaidProvider,
          stokrListener.call,
          fireImmediately: true,
        );

        final subscription = container.listen(
          checkAmpStatusProvider,
          (_, _) {},
        );

        subscription.read().refreshAmpStatus();
        await flushAsyncWork();

        verifyInOrder([
          () => pegxListener(null, const PegxGaidStateEmpty()),
          () => pegxListener(
            const PegxGaidStateEmpty(),
            const PegxGaidStateLoading(),
          ),
        ]);
        verifyInOrder([
          () => stokrListener(null, const StokrGaidStateEmpty()),
          () => stokrListener(
            const StokrGaidStateEmpty(),
            const StokrGaidStateLoading(),
          ),
        ]);
        verifyNever(() => wallet.checkGaidStatus(any(), any()));
        expect(container.read(pegxGaidProvider), const PegxGaidStateLoading());
        expect(
          container.read(stokrGaidProvider),
          const StokrGaidStateLoading(),
        );
      },
    );

    test(
      'checks both asset ids when login, amp id, and asset ids are available',
      () async {
        final wallet = MockSideswapWallet();
        when(() => wallet.checkGaidStatus(any(), any())).thenAnswer((_) {});

        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(wallet),
            serverLoginProvider.overrideWithValue(
              const ServerLoginStateLogin(),
            ),
            ampIdProvider.overrideWithValue('amp-id'),
            pegxSecuritiesProvider.overrideWithValue([
              SecuritiesItem(token: 'SSWP', icon: '', assetId: 'pegx-id'),
            ]),
            stokrSecuritiesProvider.overrideWithValue([
              SecuritiesItem(token: 'STOKR', icon: '', assetId: 'stokr-id'),
            ]),
          ],
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          checkAmpStatusProvider,
          (_, _) {},
        );

        subscription.read().refreshAmpStatus();
        await flushAsyncWork();

        verifyInOrder([
          () => wallet.checkGaidStatus('amp-id', 'pegx-id'),
          () => wallet.checkGaidStatus('amp-id', 'stokr-id'),
        ]);
        verifyNoMoreInteractions(wallet);
      },
    );

    test(
      'skips a missing pegx asset id and still checks the stokr asset id',
      () async {
        final wallet = MockSideswapWallet();
        when(() => wallet.checkGaidStatus(any(), any())).thenAnswer((_) {});

        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(wallet),
            serverLoginProvider.overrideWithValue(
              const ServerLoginStateLogin(),
            ),
            ampIdProvider.overrideWithValue('amp-id'),
            pegxSecuritiesProvider.overrideWithValue([
              SecuritiesItem(token: 'OTHER', icon: '', assetId: 'other-id'),
            ]),
            stokrSecuritiesProvider.overrideWithValue([
              SecuritiesItem(token: 'STOKR', icon: '', assetId: 'stokr-id'),
            ]),
          ],
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          checkAmpStatusProvider,
          (_, _) {},
        );

        subscription.read().refreshAmpStatus();
        await flushAsyncWork();

        verify(() => wallet.checkGaidStatus('amp-id', 'stokr-id')).called(1);
        verifyNever(() => wallet.checkGaidStatus('amp-id', 'pegx-id'));
        verifyNoMoreInteractions(wallet);
      },
    );

    test(
      'skips a missing stokr asset id and still checks the pegx asset id',
      () async {
        final wallet = MockSideswapWallet();
        when(() => wallet.checkGaidStatus(any(), any())).thenAnswer((_) {});

        final container = ProviderContainer.test(
          overrides: [
            walletProvider.overrideWithValue(wallet),
            serverLoginProvider.overrideWithValue(
              const ServerLoginStateLogin(),
            ),
            ampIdProvider.overrideWithValue('amp-id'),
            pegxSecuritiesProvider.overrideWithValue([
              SecuritiesItem(token: 'SSWP', icon: '', assetId: 'pegx-id'),
            ]),
            stokrSecuritiesProvider.overrideWithValue(const []),
          ],
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          checkAmpStatusProvider,
          (_, _) {},
        );

        subscription.read().refreshAmpStatus();
        await flushAsyncWork();

        verify(() => wallet.checkGaidStatus('amp-id', 'pegx-id')).called(1);
        verifyNever(() => wallet.checkGaidStatus('amp-id', 'stokr-id'));
        verifyNoMoreInteractions(wallet);
      },
    );

    test('skips all wallet checks when the amp id is empty', () async {
      final wallet = MockSideswapWallet();
      when(() => wallet.checkGaidStatus(any(), any())).thenAnswer((_) {});

      final container = ProviderContainer.test(
        overrides: [
          walletProvider.overrideWithValue(wallet),
          serverLoginProvider.overrideWithValue(const ServerLoginStateLogin()),
          ampIdProvider.overrideWithValue(''),
          pegxSecuritiesProvider.overrideWithValue([
            SecuritiesItem(token: 'SSWP', icon: '', assetId: 'pegx-id'),
          ]),
          stokrSecuritiesProvider.overrideWithValue([
            SecuritiesItem(token: 'STOKR', icon: '', assetId: 'stokr-id'),
          ]),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(checkAmpStatusProvider, (_, _) {});

      subscription.read().refreshAmpStatus();
      await flushAsyncWork();

      verifyNever(() => wallet.checkGaidStatus(any(), any()));
    });
  });
}

Asset createAsset({
  required String assetId,
  required String ticker,
  String? domainAgent,
}) {
  final asset = Asset()
    ..assetId = assetId
    ..ticker = ticker;

  if (domainAgent != null) {
    asset.domainAgent = domainAgent;
  }

  return asset;
}

Future<void> flushAsyncWork() async {
  // `refreshAmpStatus` schedules a microtask and then chains more work in `.then`.
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}
