import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/src/framework.dart'
    show Override, ProviderListenable, ProviderSubscription;
import 'package:sideswap/providers/addresses_providers.dart';
import 'package:sideswap/providers/amount_to_string_provider.dart';
import 'package:sideswap/providers/asset_image_providers.dart';
import 'package:sideswap/providers/inputs_providers.dart' as inputs;
import 'package:sideswap/providers/wallet.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap/screens/markets/widgets/amp_flag.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

import '../utils.dart';

class MockWallet extends Mock implements SideswapWallet {}

class FakeAssetImageRepository extends Fake
    implements AbstractAssetImageRepository {
  @override
  String generateImageHash(String label) => label;

  @override
  Widget getBigImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return getCustomImage(assetId);
  }

  @override
  Widget getCustomImage(
    String? assetId, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return Text('asset:$assetId');
  }

  @override
  Widget getCustomImageFromAsset(
    String assetSvg, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return Text('svg:$assetSvg');
  }

  @override
  Widget? getCustomImageOrNull(
    String? assetId, {
    double width = 32,
    double height = 32,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return assetId == null ? null : Text('asset:$assetId');
  }

  @override
  Uint8List getIconData(String? assetId) => Uint8List(0);

  @override
  Widget getMemoryImage(
    String? assetId, {
    required double width,
    required double height,
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return Text('memory:$assetId');
  }

  @override
  Widget getSmallImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return getCustomImage(assetId);
  }

  @override
  Widget getVerySmallImage(
    String? assetId, {
    FilterQuality filterQuality = FilterQuality.high,
  }) {
    return getCustomImage(assetId);
  }
}

ProviderContainer createContainer({List<Override> overrides = const []}) {
  final container = ProviderContainer.test(overrides: overrides);
  addTearDown(container.dispose);
  return container;
}

ProviderSubscription<T> keepAlive<T>(
  ProviderContainer container,
  ProviderListenable<T> provider, {
  bool fireImmediately = false,
}) {
  final ProviderSubscription<T> subscription = container.listen<T>(
    provider,
    (_, _) {},
    fireImmediately: fireImmediately,
  );
  addTearDown(subscription.close);
  return subscription;
}

Asset buildAsset({
  required String assetId,
  required String ticker,
  int precision = 8,
  bool ampMarket = false,
}) {
  return Asset(
    assetId: assetId,
    name: ticker,
    ticker: ticker,
    icon: 'aWNvbg==',
    precision: precision,
    swapMarket: true,
    domain: '',
    unregistered: false,
    ampMarket: ampMarket,
    domainAgent: '',
    instantSwaps: false,
  );
}

From_LoadAddresses_Address buildAddress({
  required String address,
  required int index,
  required bool isInternal,
  String? unconfidentialAddress,
}) {
  return From_LoadAddresses_Address(
    address: address,
    unconfidentialAddress: unconfidentialAddress ?? 'unconf-$address',
    index: index,
    isInternal: isInternal,
  );
}

From_LoadUtxos_Utxo buildUtxo({
  required String address,
  required String txid,
  required int vout,
  required String assetId,
  required int amount,
  required bool isInternal,
  required bool isConfidential,
}) {
  return From_LoadUtxos_Utxo(
    address: address,
    txid: txid,
    vout: vout,
    assetId: assetId,
    amount: Int64(amount),
    isInternal: isInternal,
    isConfidential: isConfidential,
  );
}

From_LoadAddresses buildLoadAddresses({
  required Account account,
  required List<From_LoadAddresses_Address> addresses,
  String errorMsg = '',
}) {
  return From_LoadAddresses(
    account: account,
    addresses: addresses,
    errorMsg: errorMsg,
  );
}

From_LoadUtxos buildLoadUtxos({
  required List<From_LoadUtxos_Utxo> utxos,
  String errorMsg = '',
}) {
  return From_LoadUtxos(utxos: utxos, errorMsg: errorMsg);
}

AddressesItem buildAddressesItem({
  required Account account,
  required String address,
  required bool isInternal,
  required int index,
  required List<UtxosItem> utxos,
}) {
  return AddressesItem(
    account: account,
    address: address,
    unconfidentialAddress: 'unconf-$address',
    index: index,
    isInternal: isInternal,
    utxos: utxos,
  );
}

UtxosItem buildUtxosItem({
  required String txid,
  required int vout,
  required String assetId,
  required int amount,
  required Account account,
  required bool isInternal,
  required bool isConfidential,
}) {
  return UtxosItem(
    txid: txid,
    vout: vout,
    assetId: assetId,
    amount: amount,
    account: account,
    isInternal: isInternal,
    isConfidential: isConfidential,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const liquidAssetId = 'lbtc';
  const ampAssetId = 'amp-asset';

  late MockWallet wallet;
  late FakeAssetImageRepository assetImageRepository;

  setUpAll(() {
    registerFallbackValue(Account.REG);
  });

  setUp(() {
    wallet = MockWallet();
    assetImageRepository = FakeAssetImageRepository();
    when(() => wallet.loadAddresses(any())).thenReturn(null);
    when(() => wallet.loadUtxos(any())).thenReturn(null);
  });

  List<Override> defaultOverrides() {
    return [
      walletProvider.overrideWith((ref) => wallet),
      assetImageRepositoryProvider.overrideWith((ref) => assetImageRepository),
      amountToStringProvider.overrideWith((ref) => AmountToString(locale: 'en')),
      liquidAssetIdStateProvider.overrideWith(
        LiquidAssetIdState.new,
      ),
      assetsStateProvider.overrideWith(
        AssetsState.new,
      ),
    ];
  }

  void seedAssets(ProviderContainer container) {
    container
        .read(liquidAssetIdStateProvider.notifier)
        .setState(liquidAssetId);
    container
        .read(assetsStateProvider.notifier)
        .addAsset(liquidAssetId, buildAsset(assetId: liquidAssetId, ticker: 'L-BTC'));
    container.read(assetsStateProvider.notifier).addAsset(
      ampAssetId,
      buildAsset(assetId: ampAssetId, ticker: 'AMP', precision: 2, ampMarket: true),
    );
  }

  group('LoadAddressesStateNotifier', () {
    test('emits loading, error and data states in order', () {
      final container = createContainer();
      final listener = ProviderListener<LoadAddressesState>();

      keepAlive(container, loadAddressesStateProvider, fireImmediately: true);
      container.listen(
        loadAddressesStateProvider,
        listener.call,
        fireImmediately: true,
      );

      final notifier = container.read(loadAddressesStateProvider.notifier);
      final data = buildLoadAddresses(
        account: Account.REG,
        addresses: [buildAddress(address: 'reg-1', index: 0, isInternal: false)],
      );

      notifier.setLoadAddressesState(const LoadAddressesState.loading());
      notifier.setLoadAddressesState(const LoadAddressesState.error('boom'));
      notifier.setLoadAddressesState(LoadAddressesState.data(data));

      verifyInOrder([
        () => listener(null, const LoadAddressesState.empty()),
        () => listener(const LoadAddressesState.empty(), const LoadAddressesState.loading()),
        () => listener(const LoadAddressesState.loading(), const LoadAddressesState.error('boom')),
        () => listener(const LoadAddressesState.error('boom'), LoadAddressesState.data(data)),
      ]);
      verifyNoMoreInteractions(listener);
    });
  });

  group('LoadUtxosStateNotifier', () {
    test('emits loading, error and data states in order', () {
      final container = createContainer();
      final listener = ProviderListener<LoadUtxosState>();

      keepAlive(container, loadUtxosStateProvider, fireImmediately: true);
      container.listen(
        loadUtxosStateProvider,
        listener.call,
        fireImmediately: true,
      );

      final notifier = container.read(loadUtxosStateProvider.notifier);
      final data = buildLoadUtxos(
        utxos: [
          buildUtxo(
            address: 'reg-1',
            txid: 'tx-1',
            vout: 0,
            assetId: liquidAssetId,
            amount: 1500,
            isInternal: false,
            isConfidential: true,
          ),
        ],
      );

      notifier.setLoadUtxosState(const LoadUtxosState.loading());
      notifier.setLoadUtxosState(const LoadUtxosState.error('boom'));
      notifier.setLoadUtxosState(LoadUtxosState.data(data));

      verifyInOrder([
        () => listener(null, const LoadUtxosState.empty()),
        () => listener(const LoadUtxosState.empty(), const LoadUtxosState.loading()),
        () => listener(const LoadUtxosState.loading(), const LoadUtxosState.error('boom')),
        () => listener(const LoadUtxosState.error('boom'), LoadUtxosState.data(data)),
      ]);
      verifyNoMoreInteractions(listener);
    });
  });

  group('AddressesAsyncNotifier', () {
    test('requests addresses and utxos when both sources are empty', () {
      final container = createContainer(overrides: defaultOverrides());
      final subscription = keepAlive(
        container,
        addressesAsyncProvider(Account.REG),
      );

      expect(subscription.read(), const AsyncLoading<AddressesModel>());
      verify(() => wallet.loadAddresses(Account.REG)).called(1);
      verify(() => wallet.loadUtxos(Account.REG)).called(1);
    });

    test('updateData forwards both wallet requests for the selected account', () {
      final container = createContainer(overrides: defaultOverrides());
      container
          .read(loadAddressesStateProvider.notifier)
          .setLoadAddressesState(const LoadAddressesState.loading());
      container
          .read(loadUtxosStateProvider.notifier)
          .setLoadUtxosState(const LoadUtxosState.loading());

      container.read(addressesAsyncProvider(Account.AMP_).notifier).updateData(Account.AMP_);

      verify(() => wallet.loadAddresses(Account.AMP_)).called(1);
      verify(() => wallet.loadUtxos(Account.AMP_)).called(1);
    });

    test('builds addresses with matching utxos when both sources have data', () async {
      final container = createContainer(overrides: defaultOverrides());
      final data = buildLoadAddresses(
        account: Account.REG,
        addresses: [
          buildAddress(address: 'reg-1', index: 1, isInternal: false),
          buildAddress(address: 'reg-2', index: 2, isInternal: true),
        ],
      );
      final utxos = buildLoadUtxos(
        utxos: [
          buildUtxo(
            address: 'reg-1',
            txid: 'tx-1',
            vout: 0,
            assetId: liquidAssetId,
            amount: 1500,
            isInternal: false,
            isConfidential: true,
          ),
          buildUtxo(
            address: 'other-address',
            txid: 'tx-2',
            vout: 1,
            assetId: ampAssetId,
            amount: 2500,
            isInternal: true,
            isConfidential: false,
          ),
        ],
      );

      container
          .read(loadAddressesStateProvider.notifier)
          .setLoadAddressesState(LoadAddressesState.data(data));
      container
          .read(loadUtxosStateProvider.notifier)
          .setLoadUtxosState(LoadUtxosState.data(utxos));

      keepAlive(container, addressesAsyncProvider(Account.REG));
      final model = await container.read(addressesAsyncProvider(Account.REG).future);

      expect(model.addresses, hasLength(2));
      expect(
        model.addresses?.first,
        isA<AddressesItem>()
            .having((item) => item.account, 'account', Account.REG)
            .having((item) => item.address, 'address', 'reg-1')
            .having((item) => item.unconfidentialAddress, 'unconfidentialAddress', 'unconf-reg-1')
            .having((item) => item.index, 'index', 1)
            .having((item) => item.isInternal, 'isInternal', false),
      );
      expect(model.addresses?.first.utxos, hasLength(1));
      expect(
        model.addresses?.first.utxos?.first,
        isA<UtxosItem>()
            .having((item) => item.txid, 'txid', 'tx-1')
            .having((item) => item.vout, 'vout', 0)
            .having((item) => item.assetId, 'assetId', liquidAssetId)
            .having((item) => item.amount, 'amount', 1500)
            .having((item) => item.isInternal, 'isInternal', false)
            .having((item) => item.isConfidential, 'isConfidential', true)
            .having((item) => item.account, 'account', Account.REG),
      );
      expect(model.addresses?.last.utxos, isEmpty);
      verifyNever(() => wallet.loadAddresses(any()));
      verifyNever(() => wallet.loadUtxos(any()));
    });

    test('stays loading when the loaded account does not match the requested family', () {
      final container = createContainer(overrides: defaultOverrides());
      container.read(loadAddressesStateProvider.notifier).setLoadAddressesState(
        LoadAddressesState.data(
          buildLoadAddresses(
            account: Account.REG,
            addresses: [buildAddress(address: 'reg-1', index: 0, isInternal: false)],
          ),
        ),
      );
      container.read(loadUtxosStateProvider.notifier).setLoadUtxosState(
        LoadUtxosState.data(
          buildLoadUtxos(
            utxos: [
              buildUtxo(
                address: 'reg-1',
                txid: 'tx-1',
                vout: 0,
                assetId: liquidAssetId,
                amount: 1,
                isInternal: false,
                isConfidential: false,
              ),
            ],
          ),
        ),
      );

      final subscription = keepAlive(container, addressesAsyncProvider(Account.AMP_));

      expect(subscription.read(), const AsyncLoading<AddressesModel>());
      verifyNever(() => wallet.loadAddresses(any()));
      verifyNever(() => wallet.loadUtxos(any()));
    });

    test('stays loading when source states are incomplete', () {
      final container = createContainer(overrides: defaultOverrides());
      container
          .read(loadAddressesStateProvider.notifier)
          .setLoadAddressesState(const LoadAddressesState.loading());

      final subscription = keepAlive(container, addressesAsyncProvider(Account.REG));

      expect(subscription.read(), const AsyncLoading<AddressesModel>());
      verifyNever(() => wallet.loadAddresses(any()));
      verifyNever(() => wallet.loadUtxos(any()));
    });
  });

  group('derived address providers', () {
    test('regularAddressesModelAsync returns data for the regular account', () async {
      final container = createContainer(overrides: defaultOverrides());
      container.read(loadAddressesStateProvider.notifier).setLoadAddressesState(
        LoadAddressesState.data(
          buildLoadAddresses(
            account: Account.REG,
            addresses: [buildAddress(address: 'reg-1', index: 0, isInternal: false)],
          ),
        ),
      );
      container.read(loadUtxosStateProvider.notifier).setLoadUtxosState(
        LoadUtxosState.data(
          buildLoadUtxos(
            utxos: [
              buildUtxo(
                address: 'reg-1',
                txid: 'tx-1',
                vout: 0,
                assetId: liquidAssetId,
                amount: 5,
                isInternal: false,
                isConfidential: false,
              ),
            ],
          ),
        ),
      );

      final subscription = keepAlive(container, regularAddressesModelAsyncProvider);
      await container.read(addressesAsyncProvider(Account.REG).future);

      expect(subscription.read().value?.addresses, hasLength(1));
    });

    test('regularAddressesModelAsync returns loading when regular data is not ready', () {
      final container = createContainer(overrides: defaultOverrides());
      final subscription = keepAlive(container, regularAddressesModelAsyncProvider);

      expect(subscription.read(), const AsyncLoading<AddressesModel>());
    });

    test('ampAdressesModelAsync returns data for the amp account', () async {
      final container = createContainer(overrides: defaultOverrides());
      container.read(loadAddressesStateProvider.notifier).setLoadAddressesState(
        LoadAddressesState.data(
          buildLoadAddresses(
            account: Account.AMP_,
            addresses: [buildAddress(address: 'amp-1', index: 1, isInternal: true)],
          ),
        ),
      );
      container.read(loadUtxosStateProvider.notifier).setLoadUtxosState(
        LoadUtxosState.data(
          buildLoadUtxos(
            utxos: [
              buildUtxo(
                address: 'amp-1',
                txid: 'tx-amp',
                vout: 2,
                assetId: ampAssetId,
                amount: 99,
                isInternal: true,
                isConfidential: true,
              ),
            ],
          ),
        ),
      );

      final subscription = keepAlive(container, ampAdressesModelAsyncProvider);
      await container.read(addressesAsyncProvider(Account.AMP_).future);

      expect(subscription.read().value?.addresses?.single.account, Account.AMP_);
    });

    test('groupedAddressesAsync returns loading when both sources are loading', () {
      final container = createContainer(
        overrides: [
          regularAddressesModelAsyncProvider.overrideWith(
            (ref) => const AsyncValue.loading(),
          ),
          ampAdressesModelAsyncProvider.overrideWith(
            (ref) => const AsyncValue.loading(),
          ),
        ],
      );

      final subscription = keepAlive(container, groupedAddressesAsyncProvider);

      expect(subscription.read(), const AsyncLoading<AddressesModel>());
    });

    test('groupedAddressesAsync concatenates regular and amp addresses', () {
      final regular = AddressesModel(
        addresses: [
          buildAddressesItem(
            account: Account.REG,
            address: 'reg-1',
            isInternal: false,
            index: 0,
            utxos: [],
          ),
        ],
      );
      final amp = AddressesModel(
        addresses: [
          buildAddressesItem(
            account: Account.AMP_,
            address: 'amp-1',
            isInternal: true,
            index: 1,
            utxos: [],
          ),
        ],
      );
      final container = createContainer(
        overrides: [
          regularAddressesModelAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(regular),
          ),
          ampAdressesModelAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(amp),
          ),
        ],
      );

      final subscription = keepAlive(container, groupedAddressesAsyncProvider);

      expect(subscription.read().value?.addresses?.map((e) => e.address), ['reg-1', 'amp-1']);
    });

    test('filteredAddressesAsync returns loading when grouped addresses are unavailable', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => const AsyncValue.loading(),
          ),
        ],
      );

      final subscription = keepAlive(container, filteredAddressesAsyncProvider);

      expect(subscription.read(), const AsyncLoading<AddressesModel>());
    });

    test('filteredAddressesAsync keeps default wallet and address filters but hides empty rows by default', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(
              AddressesModel(
                addresses: [
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'reg-external',
                    isInternal: false,
                    index: 0,
                    utxos: [],
                  ),
                  buildAddressesItem(
                    account: Account.AMP_,
                    address: 'amp-internal',
                    isInternal: true,
                    index: 1,
                    utxos: [buildUtxosItem(
                      txid: 'tx-amp',
                      vout: 0,
                      assetId: ampAssetId,
                      amount: 10,
                      account: Account.AMP_,
                      isInternal: true,
                      isConfidential: true,
                    )],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      final subscription = keepAlive(container, filteredAddressesAsyncProvider);

      expect(
        subscription.read().value?.addresses?.map((e) => e.address),
        ['amp-internal'],
      );
    });

    test('filteredAddressesAsync applies regular, internal and hide-empty filters together', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(
              AddressesModel(
                addresses: [
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'reg-external',
                    isInternal: false,
                    index: 0,
                    utxos: [buildUtxosItem(
                      txid: 'tx-1',
                      vout: 0,
                      assetId: liquidAssetId,
                      amount: 1,
                      account: Account.REG,
                      isInternal: false,
                      isConfidential: false,
                    )],
                  ),
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'reg-internal-empty',
                    isInternal: true,
                    index: 1,
                    utxos: [],
                  ),
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'reg-internal-funded',
                    isInternal: true,
                    index: 2,
                    utxos: [buildUtxosItem(
                      txid: 'tx-2',
                      vout: 1,
                      assetId: liquidAssetId,
                      amount: 2,
                      account: Account.REG,
                      isInternal: true,
                      isConfidential: true,
                    )],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      container
          .read(addressesWalletTypeFlagProvider.notifier)
          .setFlag(const AddressesWalletTypeFlag.regular());
      container
          .read(addressesAddressTypeFlagProvider.notifier)
          .setFlag(const AddressesAddressTypeFlag.internal());
      container
          .read(addressesBalanceTypeFlagProvider.notifier)
          .setFlag(const AddressesBalanceFlag.hideEmpty());

      final subscription = keepAlive(container, filteredAddressesAsyncProvider);

      expect(
        subscription.read().value?.addresses?.map((e) => e.address),
        ['reg-internal-funded'],
      );
    });

    test('filteredAddressesAsync applies amp, external and show-all filters together', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(
              AddressesModel(
                addresses: [
                  buildAddressesItem(
                    account: Account.AMP_,
                    address: 'amp-external-empty',
                    isInternal: false,
                    index: 0,
                    utxos: [],
                  ),
                  buildAddressesItem(
                    account: Account.AMP_,
                    address: 'amp-internal-funded',
                    isInternal: true,
                    index: 1,
                    utxos: [buildUtxosItem(
                      txid: 'tx-amp',
                      vout: 0,
                      assetId: ampAssetId,
                      amount: 3,
                      account: Account.AMP_,
                      isInternal: true,
                      isConfidential: false,
                    )],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      container
          .read(addressesWalletTypeFlagProvider.notifier)
          .setFlag(const AddressesWalletTypeFlag.amp());
      container
          .read(addressesAddressTypeFlagProvider.notifier)
          .setFlag(const AddressesAddressTypeFlag.external());
      container
          .read(addressesBalanceTypeFlagProvider.notifier)
          .setFlag(const AddressesBalanceFlag.showAll());

      final subscription = keepAlive(container, filteredAddressesAsyncProvider);

      expect(
        subscription.read().value?.addresses?.map((e) => e.address),
        ['amp-external-empty'],
      );
    });
  });

  group('address details and flags', () {
    test('AddressDetailsDialogNotifier stores the selected address item', () {
      final container = createContainer();
      final listener = ProviderListener<AddressDetailsState>();
      final selected = buildAddressesItem(
        account: Account.REG,
        address: 'reg-1',
        isInternal: false,
        index: 3,
        utxos: [],
      );

      keepAlive(container, addressDetailsDialogProvider, fireImmediately: true);
      container.listen(
        addressDetailsDialogProvider,
        listener.call,
        fireImmediately: true,
      );

      container
          .read(addressDetailsDialogProvider.notifier)
          .setAddressDetailsItem(selected);

      verifyInOrder([
        () => listener(null, const AddressDetailsState.empty()),
        () => listener(const AddressDetailsState.empty(), AddressDetailsState.data(selected)),
      ]);
      verifyNoMoreInteractions(listener);
    });

    test('addressesItemHelper exposes scalar item details', () {
      final item = buildAddressesItem(
        account: Account.REG,
        address: 'reg-1',
        isInternal: true,
        index: 7,
        utxos: [
          buildUtxosItem(
            txid: 'tx-1',
            vout: 0,
            assetId: liquidAssetId,
            amount: 1,
            account: Account.REG,
            isInternal: true,
            isConfidential: false,
          ),
        ],
      );
      final container = createContainer(overrides: defaultOverrides());
      final helper = container.read(addressesItemHelperProvider(item));

      expect(helper.isRegular(), isTrue);
      expect(helper.isInternal(), isTrue);
      expect(helper.addressIndex(), 7);
      expect(helper.address(), 'reg-1');
      expect(helper.utxoCount(), 1);
    });

    test('addressesItemHelper.asset returns the expected widget for one, many or zero utxos', () {
      final container = createContainer(overrides: defaultOverrides());
      final oneUtxoHelper = container.read(
        addressesItemHelperProvider(
          buildAddressesItem(
            account: Account.REG,
            address: 'one',
            isInternal: false,
            index: 0,
            utxos: [
              buildUtxosItem(
                txid: 'tx-1',
                vout: 0,
                assetId: liquidAssetId,
                amount: 1,
                account: Account.REG,
                isInternal: false,
                isConfidential: false,
              ),
            ],
          ),
        ),
      );
      final manyUtxosHelper = container.read(
        addressesItemHelperProvider(
          buildAddressesItem(
            account: Account.REG,
            address: 'many',
            isInternal: false,
            index: 1,
            utxos: [
              buildUtxosItem(
                txid: 'tx-2',
                vout: 0,
                assetId: liquidAssetId,
                amount: 1,
                account: Account.REG,
                isInternal: false,
                isConfidential: false,
              ),
              buildUtxosItem(
                txid: 'tx-3',
                vout: 1,
                assetId: ampAssetId,
                amount: 2,
                account: Account.REG,
                isInternal: false,
                isConfidential: true,
              ),
            ],
          ),
        ),
      );
      final emptyHelper = container.read(
        addressesItemHelperProvider(
          buildAddressesItem(
            account: Account.REG,
            address: 'empty',
            isInternal: false,
            index: 2,
            utxos: [],
          ),
        ),
      );

      expect((oneUtxoHelper.asset() as Text).data, 'asset:$liquidAssetId');
      expect((manyUtxosHelper.asset() as Text).data, 'Multiple');
      expect(emptyHelper.asset(), isA<SizedBox>());
    });

    test('addressesItemHelper.amount formats a single utxo and hides other cases', () {
      final container = createContainer(overrides: defaultOverrides());
      seedAssets(container);
      final oneUtxoHelper = container.read(
        addressesItemHelperProvider(
          buildAddressesItem(
            account: Account.REG,
            address: 'one',
            isInternal: false,
            index: 0,
            utxos: [
              buildUtxosItem(
                txid: 'tx-1',
                vout: 0,
                assetId: liquidAssetId,
                amount: 123456789,
                account: Account.REG,
                isInternal: false,
                isConfidential: false,
              ),
            ],
          ),
        ),
      );
      final manyUtxosHelper = container.read(
        addressesItemHelperProvider(
          buildAddressesItem(
            account: Account.REG,
            address: 'many',
            isInternal: false,
            index: 1,
            utxos: [
              buildUtxosItem(
                txid: 'tx-2',
                vout: 0,
                assetId: liquidAssetId,
                amount: 1,
                account: Account.REG,
                isInternal: false,
                isConfidential: false,
              ),
              buildUtxosItem(
                txid: 'tx-3',
                vout: 1,
                assetId: ampAssetId,
                amount: 2,
                account: Account.REG,
                isInternal: false,
                isConfidential: false,
              ),
            ],
          ),
        ),
      );
      final emptyHelper = container.read(
        addressesItemHelperProvider(
          buildAddressesItem(
            account: Account.REG,
            address: 'empty',
            isInternal: false,
            index: 2,
            utxos: [],
          ),
        ),
      );

      expect((oneUtxoHelper.amount() as Text).data, '1.23456789');
      expect(manyUtxosHelper.amount(), isA<SizedBox>());
      expect(emptyHelper.amount(), isA<SizedBox>());
    });

    test('wallet and address flag notifiers switch between all and specific filters', () {
      final container = createContainer();
      keepAlive(container, addressesWalletTypeFlagProvider);
      keepAlive(container, addressesAddressTypeFlagProvider);

      expect(
        container.read(addressesWalletTypeFlagProvider),
        const AddressesWalletTypeFlag.all(),
      );
      expect(
        container.read(addressesAddressTypeFlagProvider),
        const AddressesAddressTypeFlag.all(),
      );

      container
          .read(addressesWalletTypeFlagProvider.notifier)
          .setFlag(const AddressesWalletTypeFlag.regular());
      container
          .read(addressesWalletTypeFlagProvider.notifier)
          .setFlag(const AddressesWalletTypeFlag.amp());
      container
          .read(addressesAddressTypeFlagProvider.notifier)
          .setFlag(const AddressesAddressTypeFlag.internal());
      container
          .read(addressesAddressTypeFlagProvider.notifier)
          .setFlag(const AddressesAddressTypeFlag.external());

      expect(
        container.read(addressesWalletTypeFlagProvider),
        const AddressesWalletTypeFlag.amp(),
      );
      expect(
        container.read(addressesAddressTypeFlagProvider),
        const AddressesAddressTypeFlag.external(),
      );
    });

    test('AddressesBalanceTypeFlagNotifier builds hide-empty when grouped data contains funds', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(
              AddressesModel(
                addresses: [
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'funded',
                    isInternal: false,
                    index: 0,
                    utxos: [buildUtxosItem(
                      txid: 'tx-1',
                      vout: 0,
                      assetId: liquidAssetId,
                      amount: 10,
                      account: Account.REG,
                      isInternal: false,
                      isConfidential: false,
                    )],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      keepAlive(container, addressesBalanceTypeFlagProvider);

      expect(
        container.read(addressesBalanceTypeFlagProvider),
        const AddressesBalanceFlag.hideEmpty(),
      );

      container
          .read(addressesBalanceTypeFlagProvider.notifier)
          .setFlag(const AddressesBalanceFlag.showAll());

      expect(
        container.read(addressesBalanceTypeFlagProvider),
        const AddressesBalanceFlag.showAll(),
      );
    });

    test('AddressesBalanceTypeFlagNotifier still defaults to hide-empty without grouped data', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => const AsyncValue.loading(),
          ),
        ],
      );

      keepAlive(container, addressesBalanceTypeFlagProvider);

      expect(
        container.read(addressesBalanceTypeFlagProvider),
        const AddressesBalanceFlag.hideEmpty(),
      );
    });
  });

  group('inputs and selection helpers', () {
    test('inputsAddressesAsync returns loading when grouped addresses are unavailable', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => const AsyncValue.loading(),
          ),
        ],
      );

      final subscription = keepAlive(container, inputsAddressesAsyncProvider);

      expect(subscription.read(), const AsyncLoading<AddressesModel>());
    });

    test('inputsAddressesAsync defaults to funded regular addresses only', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(
              AddressesModel(
                addresses: [
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'regular-funded',
                    isInternal: false,
                    index: 0,
                    utxos: [buildUtxosItem(
                      txid: 'tx-1',
                      vout: 0,
                      assetId: liquidAssetId,
                      amount: 4,
                      account: Account.REG,
                      isInternal: false,
                      isConfidential: false,
                    )],
                  ),
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'regular-empty',
                    isInternal: false,
                    index: 1,
                    utxos: [],
                  ),
                  buildAddressesItem(
                    account: Account.AMP_,
                    address: 'amp-funded',
                    isInternal: false,
                    index: 2,
                    utxos: [buildUtxosItem(
                      txid: 'tx-amp',
                      vout: 0,
                      assetId: ampAssetId,
                      amount: 5,
                      account: Account.AMP_,
                      isInternal: false,
                      isConfidential: true,
                    )],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      final subscription = keepAlive(container, inputsAddressesAsyncProvider);

      expect(
        subscription.read().value?.addresses?.map((e) => e.address),
        ['regular-funded'],
      );
    });

    test('inputsAddressesAsync returns funded amp addresses when the amp flag is selected', () {
      final container = createContainer(
        overrides: [
          groupedAddressesAsyncProvider.overrideWith(
            (ref) => AsyncValue.data(
              AddressesModel(
                addresses: [
                  buildAddressesItem(
                    account: Account.REG,
                    address: 'regular-funded',
                    isInternal: false,
                    index: 0,
                    utxos: [buildUtxosItem(
                      txid: 'tx-1',
                      vout: 0,
                      assetId: liquidAssetId,
                      amount: 4,
                      account: Account.REG,
                      isInternal: false,
                      isConfidential: false,
                    )],
                  ),
                  buildAddressesItem(
                    account: Account.AMP_,
                    address: 'amp-funded',
                    isInternal: false,
                    index: 1,
                    utxos: [buildUtxosItem(
                      txid: 'tx-amp',
                      vout: 0,
                      assetId: ampAssetId,
                      amount: 5,
                      account: Account.AMP_,
                      isInternal: false,
                      isConfidential: true,
                    )],
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      container
          .read(inputs.inputsWalletFlagProvider.notifier)
          .setInputsWalletTypeFlag(const inputs.InputsWalletFlagType.amp());
      final subscription = keepAlive(container, inputsAddressesAsyncProvider);

      expect(
        subscription.read().value?.addresses?.map((e) => e.address),
        ['amp-funded'],
      );
    });

    test('SelectedInputsNotifier ignores nulls and duplicates, and resets when wallet flag changes', () async {
      final container = createContainer();
      final listener = ProviderListener<List<UtxosItem>>();
      final item = buildUtxosItem(
        txid: 'tx-1',
        vout: 0,
        assetId: liquidAssetId,
        amount: 7,
        account: Account.REG,
        isInternal: false,
        isConfidential: false,
      );

      keepAlive(container, selectedInputsProvider, fireImmediately: true);
      container.listen(selectedInputsProvider, listener.call, fireImmediately: true);

      final notifier = container.read(selectedInputsProvider.notifier);
      notifier.addItem(null);
      notifier.addItem(item);
      notifier.addItem(item);
      notifier.addAllItems(null);
      notifier.addAllItems([item]);
      container
          .read(inputs.inputsWalletFlagProvider.notifier)
          .setInputsWalletTypeFlag(const inputs.InputsWalletFlagType.amp());
      await container.pump();

      verifyInOrder([
        () => listener(null, <UtxosItem>[]),
        () => listener(<UtxosItem>[], [item]),
        () => listener([item], <UtxosItem>[]),
      ]);
      verifyNoMoreInteractions(listener);
    });

    test('SelectedInputsNotifier removes one, many, or all items', () {
      final container = createContainer();
      final first = buildUtxosItem(
        txid: 'tx-1',
        vout: 0,
        assetId: liquidAssetId,
        amount: 1,
        account: Account.REG,
        isInternal: false,
        isConfidential: false,
      );
      final second = buildUtxosItem(
        txid: 'tx-2',
        vout: 1,
        assetId: ampAssetId,
        amount: 2,
        account: Account.AMP_,
        isInternal: true,
        isConfidential: true,
      );
      final notifier = container.read(selectedInputsProvider.notifier);

      notifier.addAllItems([first, second]);
      notifier.removeItem(null);
      notifier.removeItem(first);
      expect(container.read(selectedInputsProvider), [second]);

      notifier.removeAllItems(null);
      notifier.removeAllItems([second]);
      expect(container.read(selectedInputsProvider), isEmpty);

      notifier.addAllItems([first, second]);
      notifier.removeAll();
      expect(container.read(selectedInputsProvider), isEmpty);
    });

    test('SelectedInputsHelper reports containment, totals and max utxo count', () {
      final container = createContainer(overrides: defaultOverrides());
      seedAssets(container);
      final lbtc = buildUtxosItem(
        txid: 'tx-1',
        vout: 0,
        assetId: liquidAssetId,
        amount: 150000000,
        account: Account.REG,
        isInternal: false,
        isConfidential: false,
      );
      final amp = buildUtxosItem(
        txid: 'tx-2',
        vout: 1,
        assetId: ampAssetId,
        amount: 500,
        account: Account.AMP_,
        isInternal: true,
        isConfidential: true,
      );

      container.read(selectedInputsProvider.notifier).addAllItems([lbtc, amp]);
      final helper = container.read(selectedInputsHelperProvider);

      expect(helper.contains(null), isFalse);
      expect(helper.contains(lbtc), isTrue);
      expect(helper.containsAll(null), isFalse);
      expect(helper.containsAll([lbtc, amp]), isTrue);
      expect(helper.containsAll([buildUtxosItem(
        txid: 'missing',
        vout: 9,
        assetId: liquidAssetId,
        amount: 1,
        account: Account.REG,
        isInternal: false,
        isConfidential: false,
      )]), isFalse);
      expect(helper.containsModel(const AddressesModel(addresses: null)), isFalse);
      expect(
        helper.containsModel(
          AddressesModel(
            addresses: [
              buildAddressesItem(
                account: Account.REG,
                address: 'group',
                isInternal: false,
                index: 0,
                utxos: [lbtc, amp],
              ),
            ],
          ),
        ),
        isTrue,
      );
      expect(helper.containsModel(
        AddressesModel(
          addresses: [
            buildAddressesItem(
              account: Account.REG,
              address: 'group',
              isInternal: false,
              index: 0,
              utxos: [lbtc, buildUtxosItem(
                txid: 'missing',
                vout: 9,
                assetId: liquidAssetId,
                amount: 1,
                account: Account.REG,
                isInternal: false,
                isConfidential: false,
              )],
            ),
          ],
        ),
      ), isFalse);
      expect(helper.count(), 2);
      expect(helper.maxUtxos(), maxUtxosCount);
      expect(helper.lbtcTotalAmount(), '1.50000000');
      expect(helper.containsLbtc(), isTrue);
    });

    test('SelectedInputsHelper formats individual utxos and derived asset data', () {
      final container = createContainer(overrides: defaultOverrides());
      seedAssets(container);
      final lbtc = buildUtxosItem(
        txid: 'tx-1',
        vout: 0,
        assetId: liquidAssetId,
        amount: 150000000,
        account: Account.REG,
        isInternal: false,
        isConfidential: false,
      );
      final amp = buildUtxosItem(
        txid: 'tx-2',
        vout: 1,
        assetId: ampAssetId,
        amount: 500,
        account: Account.AMP_,
        isInternal: true,
        isConfidential: true,
      );

      container.read(selectedInputsProvider.notifier).addAllItems([lbtc, amp]);
      final helper = container.read(selectedInputsHelperProvider);
      final totals = helper.totalAmounts();

      expect(helper.utxoAmount(utxo: null), '0.0');
      expect(helper.utxoAmount(utxo: lbtc), '1.50000000');
      expect((helper.utxoAsset(utxo: null) as SizedBox), isA<SizedBox>());
      expect((helper.utxoAsset(utxo: amp) as Text).data, 'asset:$ampAssetId');
      expect(helper.utxoTicker(utxo: null), '');
      expect(helper.utxoTicker(utxo: amp), 'AMP');
      expect(totals, hasLength(2));
      expect(totals.map((row) => row.ticker), containsAll(['L-BTC', 'AMP']));
      expect(totals.map((row) => row.amount), containsAll(['1.50000000', '5.00']));
      expect((totals.first.asset as Text).data, startsWith('asset:'));
      expect(helper.utxoAccount(utxo: null), isA<SizedBox>());
      expect(helper.utxoAccount(utxo: lbtc), isA<SizedBox>());
      expect(helper.utxoAccount(utxo: amp), isA<AmpFlag>());
    });
  });

  group('input expansion state', () {
    test('InputListItemExpandedStatesNotifier adds and removes collapsed states', () {
      final container = createContainer();
      keepAlive(container, inputListItemExpandedStatesProvider);
      final notifier = container.read(inputListItemExpandedStatesProvider.notifier);

      notifier.updateState(5, true);
      expect(container.read(inputListItemExpandedStatesProvider), isEmpty);

      notifier.updateState(5, false);
      expect(
        container.read(inputListItemExpandedStatesProvider),
        [const InputListItemExpandedState(hash: 5, expanded: false)],
      );

      notifier.updateState(5, true);
      expect(container.read(inputListItemExpandedStatesProvider), isEmpty);
    });

    test('inputListItemExpandedState defaults to true and returns stored values', () {
      final defaultContainer = createContainer();
      final defaultSubscription = keepAlive(
        defaultContainer,
        inputListItemExpandedStateProvider(99),
      );

      expect(defaultSubscription.read(), isTrue);

      final trueContainer = createContainer(
        overrides: [
          inputListItemExpandedStatesProvider.overrideWith(
            InputListItemExpandedStatesNotifier.new,
          ),
        ],
      );
      trueContainer.read(inputListItemExpandedStatesProvider.notifier).state = const [
        InputListItemExpandedState(hash: 77),
      ];

      expect(
        keepAlive(trueContainer, inputListItemExpandedStateProvider(77)).read(),
        isTrue,
      );

      final falseContainer = createContainer(
        overrides: [
          inputListItemExpandedStatesProvider.overrideWith(
            InputListItemExpandedStatesNotifier.new,
          ),
        ],
      );
      falseContainer.read(inputListItemExpandedStatesProvider.notifier).state = const [
        InputListItemExpandedState(hash: 77, expanded: false),
      ];

      expect(
        keepAlive(falseContainer, inputListItemExpandedStateProvider(77)).read(),
        isFalse,
      );
    });
  });
}
