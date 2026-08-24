import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/desktop/desktop_dialog_presenter.dart';
import 'package:sideswap/desktop/widgets/d_popup_with_close.dart';
import 'package:sideswap/providers/desktop_dialog_providers.dart';
import 'package:sideswap/providers/tx_provider.dart';
import 'package:sideswap/providers/warmup_app_provider.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockNavigatorKey extends Mock implements GlobalKey<NavigatorState> {
  final BuildContext? _context;
  MockNavigatorKey({this._context});
  @override
  BuildContext? get currentContext => _context;
}

class MockBuildContext extends Mock implements BuildContext {}

class MockCurrentTxPopupItemNotifier extends Mock
    implements CurrentTxPopupItemNotifier {}

class MockDesktopDialogPresenter extends Mock
    implements DesktopDialogPresenter {}

void main() {
  late MockBuildContext mockContext;
  late MockCurrentTxPopupItemNotifier mockNotifier;
  late MockDesktopDialogPresenter mockPresenter;
  late DesktopDialog sut;

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(Asset());
  });

  setUp(() {
    mockContext = MockBuildContext();
    mockNotifier = MockCurrentTxPopupItemNotifier();
    mockPresenter = MockDesktopDialogPresenter();
    sut = DesktopDialog(
      mockNotifier,
      context: mockContext,
      presenter: mockPresenter,
    );
  });

  group('DesktopDialog', () {
    group('constructor', () {
      test('stores currentTxPopupItemNotifier reference', () {
        expect(sut.currentTxPopupItemNotifier, same(mockNotifier));
      });

      test('uses FlutterDesktopDialogPresenter by default', () {
        final dialog = DesktopDialog(mockNotifier, context: mockContext);
        expect(dialog, isA<DesktopDialog>());
      });
    });

    group('desktopDialogProvider', () {
      test('creates DesktopDialog from navigatorKey and txPopupNotifier', () {
        final container = ProviderContainer.test(
          overrides: [
            navigatorKeyProvider.overrideWithValue(
              MockNavigatorKey(context: mockContext),
            ),
            currentTxPopupItemProvider.overrideWithBuild(
              (ref, notifier) => const Option.none(),
            ),
          ],
        );
        addTearDown(container.dispose);

        final dialog = container.read(desktopDialogProvider);
        expect(dialog, isA<DesktopDialog>());
      });
    });

    group('simple delegation methods', () {
      final delegationCases = [
        (
          name: 'showRecvAddress',
          call: (DesktopDialog d) => d.showRecvAddress(),
          verify: (MockDesktopDialogPresenter p) =>
              p.showRecvAddress(any(), routeName: any(named: 'routeName')),
        ),
        (
          name: 'showNeedRestartDialog',
          call: (DesktopDialog d) => d.showNeedRestartDialog(),
          verify: (MockDesktopDialogPresenter p) => p.showNeedRestartDialog(
            any(),
            routeName: any(named: 'routeName'),
          ),
        ),
        (
          name: 'showGenerateAddress',
          call: (DesktopDialog d) => d.showGenerateAddress(),
          verify: (MockDesktopDialogPresenter p) =>
              p.showGenerateAddress(any(), routeName: any(named: 'routeName')),
        ),
        (
          name: 'showSendTx',
          call: (DesktopDialog d) => d.showSendTx(),
          verify: (MockDesktopDialogPresenter p) =>
              p.showSendTx(any(), routeName: any(named: 'routeName')),
        ),
        (
          name: 'showSelectInputs',
          call: (DesktopDialog d) => d.showSelectInputs(),
          verify: (MockDesktopDialogPresenter p) =>
              p.showSelectInputs(any(), routeName: any(named: 'routeName')),
        ),
        (
          name: 'showAcceptQuoteErrorDialog',
          call: (DesktopDialog d) => d.showAcceptQuoteErrorDialog(),
          verify: (MockDesktopDialogPresenter p) =>
              p.showAcceptQuoteErrorDialog(any()),
        ),
        (
          name: 'openTxImport',
          call: (DesktopDialog d) => d.openTxImport(),
          verify: (MockDesktopDialogPresenter p) =>
              p.openTxImport(any(), routeName: any(named: 'routeName')),
        ),
        (
          name: 'openExportTxSuccess',
          call: (DesktopDialog d) => d.openExportTxSuccess(),
          verify: (MockDesktopDialogPresenter p) =>
              p.openExportTxSuccess(any(), routeName: any(named: 'routeName')),
        ),
      ];

      for (final c in delegationCases) {
        test('${c.name} delegates to presenter', () {
          when(() => c.verify(mockPresenter)).thenAnswer((_) => Future.value());

          c.call(sut);

          verify(() => c.verify(mockPresenter)).called(1);
        });
      }

      test('showExportCsv delegates to presenter', () async {
        when(
          () => mockPresenter.showExportCsv<void>(
            any(),
            routeName: any(named: 'routeName'),
          ),
        ).thenAnswer((_) async {});

        await sut.showExportCsv<void>();

        verify(
          () => mockPresenter.showExportCsv<void>(
            any(),
            routeName: any(named: 'routeName'),
          ),
        ).called(1);
      });

      test('showAssetInfoDialog delegates to presenter with asset', () {
        final asset = Asset()..assetId = 'test-asset';
        when(
          () => mockPresenter.showAssetInfoDialog(
            any(),
            any(),
            routeName: any(named: 'routeName'),
          ),
        ).thenReturn(null);

        sut.showAssetInfoDialog(asset);

        verify(
          () => mockPresenter.showAssetInfoDialog(
            any(),
            asset,
            routeName: any(named: 'routeName'),
          ),
        ).called(1);
      });
    });

    group('showTx', () {
      setUp(() {
        when(
          () => mockPresenter.closePopups(
            any(),
            popupRouteName: any(named: 'popupRouteName'),
          ),
        ).thenReturn(null);
        when(() => mockNotifier.setCurrentTxId(any())).thenReturn(null);
        when(
          () => mockPresenter.showTxDialog(
            any(),
            isPeg: any(named: 'isPeg'),
            routeName: any(named: 'routeName'),
          ),
        ).thenAnswer((_) async {});
      });

      test('calls closePopups before showing dialog', () async {
        final transItem = TransItem()..tx = (Tx()..txid = 'abc');

        await sut.showTx(transItem, isPeg: false);

        verifyInOrder([
          () => mockPresenter.closePopups(
            any(),
            popupRouteName: any(named: 'popupRouteName'),
          ),
          () => mockNotifier.setCurrentTxId('abc'),
          () => mockPresenter.showTxDialog(
            any(),
            isPeg: false,
            routeName: any(named: 'routeName'),
          ),
        ]);
      });

      test('uses tx.txid when not a peg', () async {
        final transItem = TransItem()..tx = (Tx()..txid = 'regular-txid');

        await sut.showTx(transItem, isPeg: false);

        verify(() => mockNotifier.setCurrentTxId('regular-txid')).called(1);
      });

      test('uses peg.txidRecv when isPegIn', () async {
        final transItem = TransItem()
          ..peg = (Peg()
            ..isPegIn = true
            ..txidRecv = 'recv-id'
            ..txidSend = 'send-id');

        await sut.showTx(transItem, isPeg: true);

        verify(() => mockNotifier.setCurrentTxId('recv-id')).called(1);
      });

      test('uses peg.txidSend when not isPegIn', () async {
        final transItem = TransItem()
          ..peg = (Peg()
            ..isPegIn = false
            ..txidRecv = 'recv-id'
            ..txidSend = 'send-id');

        await sut.showTx(transItem, isPeg: true);

        verify(() => mockNotifier.setCurrentTxId('send-id')).called(1);
      });

      test('passes isPeg=true to presenter', () async {
        final transItem = TransItem()
          ..peg = (Peg()
            ..isPegIn = true
            ..txidRecv = 'recv-id');

        await sut.showTx(transItem, isPeg: true);

        verify(
          () => mockPresenter.showTxDialog(
            any(),
            isPeg: true,
            routeName: any(named: 'routeName'),
          ),
        ).called(1);
      });
    });

    group('openViewTx', () {
      test('returns presenter result when non-null', () async {
        const expected = DialogReturnValue.accepted();
        when(
          () => mockPresenter.openViewTx(
            any(),
            routeName: any(named: 'routeName'),
          ),
        ).thenAnswer((_) async => expected);

        final result = await sut.openViewTx();

        expect(result, expected);
      });

      test(
        'returns DialogReturnValueCancelled when presenter returns null',
        () async {
          when(
            () => mockPresenter.openViewTx(
              any(),
              routeName: any(named: 'routeName'),
            ),
          ).thenAnswer((_) async => null);

          final result = await sut.openViewTx();

          expect(result, isA<DialogReturnValueCancelled>());
        },
      );
    });

    group('closePopups', () {
      test('delegates to presenter with default routeName', () {
        when(
          () => mockPresenter.closePopups(
            any(),
            popupRouteName: any(named: 'popupRouteName'),
          ),
        ).thenReturn(null);

        sut.closePopups();

        verify(
          () => mockPresenter.closePopups(any(), popupRouteName: null),
        ).called(1);
      });

      test('delegates to presenter with custom routeName', () {
        when(
          () => mockPresenter.closePopups(
            any(),
            popupRouteName: any(named: 'popupRouteName'),
          ),
        ).thenReturn(null);

        sut.closePopups(popupRouteName: '/custom');

        verify(
          () => mockPresenter.closePopups(any(), popupRouteName: '/custom'),
        ).called(1);
      });
    });
  });
}
