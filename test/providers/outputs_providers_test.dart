import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap_logger/custom_logger.dart';
import 'package:sideswap/desktop/main/providers/d_send_popup_providers.dart';
import 'package:sideswap/providers/outputs_providers.dart';
import 'package:sideswap/providers/satoshi_providers.dart';
import 'package:sideswap/providers/wallet_assets_providers.dart';
import 'package:sideswap_protobuf/sideswap_api.dart';

class MockXFile extends Mock implements XFile {}

class _FakePathProviderPlatform extends PathProviderPlatform {
  final String _tempPath = Directory.systemTemp.path;

  @override
  Future<String?> getApplicationDocumentsPath() async => _tempPath;

  @override
  Future<String?> getTemporaryPath() async => _tempPath;

  @override
  Future<String?> getApplicationSupportPath() async => _tempPath;

  @override
  Future<String?> getApplicationCachePath() async => _tempPath;
}

class MockAbstractSatoshiRepository extends Mock
    implements AbstractSatoshiRepository {}

class MockAssetUtils extends Mock implements AssetUtils {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    // Suppress all logging
  }
}

// Note: addTearDown works here via zone inheritance from the calling test() body.
Future<void> _runSaveSuccessTest({
  required String fileName,
  String? suggestedName,
}) async {
  final savePath = '${Directory.systemTemp.path}/$fileName';
  String? capturedSuggestedName;

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/file_selector'),
    (MethodCall methodCall) async {
      if (methodCall.method == 'getSavePath') {
        final args = methodCall.arguments as Map?;
        capturedSuggestedName = args?['suggestedName'] as String?;
        return savePath;
      }
      return null;
    },
  );

  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/file_selector'),
      null,
    );
  });

  addTearDown(() {
    final f = File(savePath);
    if (f.existsSync()) f.deleteSync();
  });

  final outputsData = OutputsData(
    type: 'sideswap_app',
    version: '2',
    timestamp: 1234567890,
    receivers: [
      OutputsReceiver(address: 'addr1', assetId: 'asset1', satoshi: 1000),
    ],
  );

  final container = ProviderContainer.test(
    overrides: [
      outputsCreatorProvider.overrideWithBuild(
        (ref, notifier) => Right(outputsData),
      ),
    ],
  );

  final result = await container
      .read(outputsCreatorProvider.notifier)
      .saveToFile(suggestedName: suggestedName);

  expect(result, true);
  expect(File(savePath).existsSync(), true);
  final content = jsonDecode(File(savePath).readAsStringSync()) as Map<String, dynamic>;
  expect(content['type'], 'sideswap_app');
  if (suggestedName != null) {
    expect(capturedSuggestedName, '$suggestedName.json');
  } else {
    expect(capturedSuggestedName, startsWith('SideSwap_'));
    expect(capturedSuggestedName, endsWith('_unsigned.json'));
  }
}

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    registerFallbackValue(OutputsReceiver());
  });

  group('OutputsReaderNotifier', () {
    group('build', () {
      test('returns Left with OutputsErrorOutputsDataIsEmpty on initial state', () {
        final container = ProviderContainer.test();

        final state = container.read(outputsReaderProvider);

        expect(
          state,
          const Left<OutputsError, OutputsData>(
            OutputsErrorOutputsDataIsEmpty(),
          ),
        );
      });
    });

    group('decodeJsonString', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer.test();
      });

      final errorCases = [
        (
          input: '{"type":"wrong","version":"2"}',
          error: isA<OutputsErrorWrongTypeOfFile>(),
          name: 'wrong type',
        ),
        (
          input: '{"type":"sideswap_app","version":"1"}',
          error: isA<OutputsErrorWrongVersionOfFile>(),
          name: 'wrong version',
        ),
        (
          input: '{"type":"sideswap_app"}',
          error: isA<OutputsErrorWrongTypeOfFile>(),
          name: 'missing version',
        ),
        (
          input: '{"version":"2"}',
          error: isA<OutputsErrorWrongTypeOfFile>(),
          name: 'missing type',
        ),
        (
          input: 'invalid json{]',
          error: isA<OutputsErrorJsonFileSyntaxError>(),
          name: 'invalid JSON syntax',
        ),
        (
          input: '["array"]',
          error: isA<OutputsErrorJsonFileSyntaxError>(),
          name: 'non-map JSON',
        ),
      ];

      for (final c in errorCases) {
        test('returns false and sets error for ${c.name}', () async {
          // Fresh container per iteration to avoid state leak between cases.
          final localContainer = ProviderContainer.test();

          final result = await localContainer
              .read(outputsReaderProvider.notifier)
              .decodeJsonString(c.input);

          expect(result, false);
          final state = localContainer.read(outputsReaderProvider);
          expect(
            state,
            isA<Left<OutputsError, OutputsData>>()
                .having((l) => l.value, 'error', c.error),
          );
        });
      }

      // Issue #7: removed optional timestamp field to show minimum valid structure
      test('returns true and sets valid data for correct JSON structure', () async {
        final json = jsonEncode({
          'type': 'sideswap_app',
          'version': '2',
          'receivers': [
            {
              'address': 'addr1',
              'asset_id': 'asset1',
              'satoshi': 1000,
              'account': 0,
            }
          ],
        });

        final result = await container
            .read(outputsReaderProvider.notifier)
            .decodeJsonString(json);

        expect(result, true);
        final state = container.read(outputsReaderProvider);
        expect(state, isA<Right<OutputsError, OutputsData>>());
        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.type, 'sideswap_app');
            expect(r.version, '2');
            expect(r.receivers, hasLength(1));
          },
        );
      });

      test('accepts receivers with partial fields since all are nullable',
          () async {
        final json = jsonEncode({
          'type': 'sideswap_app',
          'version': '2',
          'receivers': [
            {'address': 'addr1'}, // missing fields, but all are nullable
          ],
        });

        final result = await container
            .read(outputsReaderProvider.notifier)
            .decodeJsonString(json);

        expect(result, true);
        final state = container.read(outputsReaderProvider);
        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.receivers, hasLength(1));
            expect(r.receivers![0].address, 'addr1');
          },
        );
      });

      test('returns false and sets error when receivers field has invalid type',
          () async {
        final json = jsonEncode({
          'type': 'sideswap_app',
          'version': '2',
          'receivers': 'not_a_list', // Invalid: should be a list
        });

        final result = await container
            .read(outputsReaderProvider.notifier)
            .decodeJsonString(json);

        expect(result, false);
        final state = container.read(outputsReaderProvider);
        expect(
          state,
          isA<Left<OutputsError, OutputsData>>()
              .having(
                (l) => l.value,
                'error',
                isA<OutputsErrorFileStructureError>(),
              ),
        );
      });
    });

    group('setXFile', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer.test();
      });

      // Issue #10: added state assertion after setXFile(null)
      test('returns false when XFile is null', () async {
        final result =
            await container.read(outputsReaderProvider.notifier).setXFile(null);

        expect(result, false);
        final state = container.read(outputsReaderProvider);
        expect(
          state,
          isA<Left<OutputsError, OutputsData>>()
              .having((l) => l.value, 'error', isA<OutputsErrorOutputsDataIsEmpty>()),
        );
      });

      test('returns false and sets error when file read fails', () async {
        final mockFile = MockXFile();
        when(() => mockFile.readAsString())
            .thenThrow(Exception('File read error'));

        final result = await container
            .read(outputsReaderProvider.notifier)
            .setXFile(mockFile);

        expect(result, false);
        final state = container.read(outputsReaderProvider);
        expect(
          state,
          isA<Left<OutputsError, OutputsData>>()
              .having((l) => l.value, 'error', isA<OutputsErrorOperationCancelled>()),
        );
      });

      test('returns true and sets valid data when file contains valid JSON',
          () async {
        final json = jsonEncode({
          'type': 'sideswap_app',
          'version': '2',
          'timestamp': 1234567890,
        });

        final mockFile = MockXFile();
        when(() => mockFile.readAsString())
            .thenAnswer((_) async => json);

        final result = await container
            .read(outputsReaderProvider.notifier)
            .setXFile(mockFile);

        expect(result, true);
        final state = container.read(outputsReaderProvider);
        expect(state, isA<Right<OutputsError, OutputsData>>());
        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.type, 'sideswap_app');
            expect(r.timestamp, 1234567890);
          },
        );
      });
    });

    group('insertOutput', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer.test();
      });

      test('does not insert when assetId is empty', () {
        final before = container.read(outputsReaderProvider);
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: '',
              address: 'addr1',
              satoshi: 1000,
              account: Account.REG,
            );
        final after = container.read(outputsReaderProvider);
        expect(after, before);
      });

      test('does not insert when address is empty', () {
        final before = container.read(outputsReaderProvider);
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset1',
              address: '',
              satoshi: 1000,
              account: Account.REG,
            );
        final after = container.read(outputsReaderProvider);
        expect(after, before);
      });

      test('does not insert when satoshi is zero', () {
        final before = container.read(outputsReaderProvider);
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset1',
              address: 'addr1',
              satoshi: 0,
              account: Account.REG,
            );
        final after = container.read(outputsReaderProvider);
        expect(after, before);
      });

      // Issue #4: merged type/version/timestamp assertions from the deleted
      // 'sets type and version when creating new OutputsData' test
      test('inserts first output when state is empty', () {
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset1',
              address: 'addr1',
              satoshi: 1000,
              account: Account.REG,
            );

        final state = container.read(outputsReaderProvider);
        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.receivers, hasLength(1));
            expect(r.receivers![0].address, 'addr1');
            expect(r.receivers![0].assetId, 'asset1');
            expect(r.receivers![0].satoshi, 1000);
            expect(r.type, 'sideswap_app');
            expect(r.version, '2');
            expect(r.timestamp, isNotNull);
          },
        );
      });

      test('appends output when state already has data', () {
        // First insert
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset1',
              address: 'addr1',
              satoshi: 1000,
              account: Account.REG,
            );

        // Second insert
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset2',
              address: 'addr2',
              satoshi: 2000,
              account: Account.AMP_,
            );

        final state = container.read(outputsReaderProvider);
        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.receivers, hasLength(2));
            expect(r.receivers![0].address, 'addr1');
            expect(r.receivers![1].address, 'addr2');
          },
        );
      });
    });

    group('removeOutput', () {
      late ProviderContainer container;

      setUp(() {
        container = ProviderContainer.test();
      });

      test('does nothing when state is empty', () {
        container.read(outputsReaderProvider.notifier).removeOutput(0);

        final state = container.read(outputsReaderProvider);
        expect(
          state,
          isA<Left<OutputsError, OutputsData>>()
              .having((l) => l.value, 'error', isA<OutputsErrorOutputsDataIsEmpty>()),
        );
      });

      test('removes output at specified index', () {
        // Insert two outputs
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset1',
              address: 'addr1',
              satoshi: 1000,
              account: Account.REG,
            );
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset2',
              address: 'addr2',
              satoshi: 2000,
              account: Account.AMP_,
            );

        // Remove first output
        container.read(outputsReaderProvider.notifier).removeOutput(0);

        final state = container.read(outputsReaderProvider);
        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.receivers, hasLength(1));
            expect(r.receivers![0].address, 'addr2');
          },
        );
      });

      test('returns to empty state when removing last output', () {
        // Insert one output
        container.read(outputsReaderProvider.notifier).insertOutput(
              assetId: 'asset1',
              address: 'addr1',
              satoshi: 1000,
              account: Account.REG,
            );

        // Remove it
        container.read(outputsReaderProvider.notifier).removeOutput(0);

        final state = container.read(outputsReaderProvider);
        expect(
          state,
          isA<Left<OutputsError, OutputsData>>()
              .having((l) => l.value, 'error', isA<OutputsErrorOutputsDataIsEmpty>()),
        );
      });

      test('removes output from middle of list', () {
        // Insert three outputs
        for (int i = 0; i < 3; i++) {
          container.read(outputsReaderProvider.notifier).insertOutput(
                assetId: 'asset$i',
                address: 'addr$i',
                satoshi: 1000 * (i + 1),
                account: Account.REG,
              );
        }

        // Remove middle output
        container.read(outputsReaderProvider.notifier).removeOutput(1);

        final state = container.read(outputsReaderProvider);
        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.receivers, hasLength(2));
            expect(r.receivers![0].address, 'addr0');
            expect(r.receivers![1].address, 'addr2');
          },
        );
      });
    });
  });

  group('OutputsCreator', () {
    group('build', () {
      test('returns error when all guard conditions fail (empty assetId, empty address, satoshi 0)', () {
        final mockSatoshiRepository = MockAbstractSatoshiRepository();
        when(() => mockSatoshiRepository.satoshiForAmount(
              amount: any(named: 'amount'),
              assetId: any(named: 'assetId'),
            )).thenReturn(0);

        final container = ProviderContainer.test(
          overrides: [
            sendPopupSelectedAssetIdProvider.overrideWithValue(''),
            sendPopupAmountProvider.overrideWithValue(''),
            sendPopupAddressProvider.overrideWithValue(''),
            satoshiRepositoryProvider
                .overrideWith((ref) => mockSatoshiRepository),
            outputsReaderProvider.overrideWithValue(
              const Left(OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );

        final state = container.read(outputsCreatorProvider);

        expect(
          state,
          isA<Left<OutputsError, OutputsData>>()
              .having((l) => l.value, 'error', isA<OutputsErrorRequiredDataIsEmpty>()),
        );
      });

      // Issue #3: assert concrete OutputsErrorAssetNotFound subtype
      test(
          'returns error when all required data is present but asset not found',
          () {
        final mockSatoshiRepository = MockAbstractSatoshiRepository();

        when(() => mockSatoshiRepository.satoshiForAmount(
              amount: '100',
              assetId: 'asset1',
            )).thenReturn(1000);

        final container = ProviderContainer.test(
          overrides: [
            sendPopupSelectedAssetIdProvider.overrideWithValue('asset1'),
            sendPopupAmountProvider.overrideWithValue('100'),
            sendPopupAddressProvider.overrideWithValue('address'),
            satoshiRepositoryProvider
                .overrideWith((ref) => mockSatoshiRepository),
            assetFromAssetIdProvider('asset1')
                .overrideWithValue(Option.none()),
            outputsReaderProvider.overrideWithValue(
              const Left(OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );

        final state = container.read(outputsCreatorProvider);

        expect(
          state,
          isA<Left<OutputsError, OutputsData>>()
              .having((l) => l.value, 'error', isA<OutputsErrorAssetNotFound>()),
        );
      });

      final accountCases = [
        (
          ampMarket: false,
          expectedAccount: Account.REG,
          name: 'REG account when ampMarket is false',
        ),
        (
          ampMarket: true,
          expectedAccount: Account.AMP_,
          name: 'AMP_ account when ampMarket is true',
        ),
      ];

      for (final c in accountCases) {
        test('creates OutputsData with ${c.name}', () {
          final asset = Asset()
            ..assetId = 'asset1'
            ..ampMarket = c.ampMarket;

          final mockSatoshiRepository = MockAbstractSatoshiRepository();

          when(() => mockSatoshiRepository.satoshiForAmount(
                amount: '100',
                assetId: 'asset1',
              )).thenReturn(1000);

          final container = ProviderContainer.test(
            overrides: [
              sendPopupSelectedAssetIdProvider.overrideWithValue('asset1'),
              sendPopupAmountProvider.overrideWithValue('100'),
              sendPopupAddressProvider.overrideWithValue('address'),
              satoshiRepositoryProvider
                  .overrideWith((ref) => mockSatoshiRepository),
              assetFromAssetIdProvider('asset1')
                  .overrideWithValue(Option.of(asset)),
              outputsReaderProvider.overrideWithValue(
                const Left(OutputsErrorOutputsDataIsEmpty()),
              ),
            ],
          );

          final state = container.read(outputsCreatorProvider);

          state.fold(
            (l) => fail('Expected Right but got Left: $l'),
            (r) {
              expect(r.receivers, hasLength(1));
              expect(r.receivers![0].account, c.expectedAccount);
              // build() must not stamp a timestamp; it is stamped at save time.
              expect(r.timestamp, isNull);
            },
          );
        });
      }

      test('preserves existing receivers when outputs data already exists', () {
        // assetFromAssetIdProvider is not overridden: the Right branch of
        // OutputsCreator.build() copies receivers directly and never reads it.
        final existingData = OutputsData(
          type: 'sideswap_app',
          version: '2',
          timestamp: 1234567890,
          receivers: [
            OutputsReceiver(
              address: 'existing_addr',
              assetId: 'existing_asset',
              satoshi: 5000,
            ),
          ],
        );

        final container = ProviderContainer.test(
          overrides: [
            sendPopupSelectedAssetIdProvider.overrideWithValue('asset1'),
            sendPopupAmountProvider.overrideWithValue('100'),
            sendPopupAddressProvider.overrideWithValue('address'),
            outputsReaderProvider
                .overrideWithValue(Right(existingData)),
          ],
        );

        final state = container.read(outputsCreatorProvider);

        state.fold(
          (l) => fail('Expected Right but got Left: $l'),
          (r) {
            expect(r.receivers, hasLength(1));
            expect(r.receivers![0].address, 'existing_addr');
            // The incoming timestamp is dropped: build() never carries one,
            // so OutputsCreator does not re-emit on every rebuild.
            expect(r.timestamp, isNull);
          },
        );
      });
    });

    group('saveToFile', () {
      // Issue #2: use addTearDown inside setUp instead of separate tearDown
      setUp(() {
        final originalPathProvider = PathProviderPlatform.instance;
        PathProviderPlatform.instance = _FakePathProviderPlatform();
        addTearDown(() {
          PathProviderPlatform.instance = originalPathProvider;
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/file_selector'),
            null,
          );
        });
      });

      test('returns false when state is Left (error)', () async {
        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithBuild(
              (ref, notifier) => const Left(OutputsErrorOutputsDataIsEmpty()),
            ),
          ],
        );

        final result =
            await container.read(outputsCreatorProvider.notifier).saveToFile();

        expect(result, false);
      });

      test('returns false when getSaveLocation returns null (user cancels)',
          () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/file_selector'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getSavePath') {
              return null;
            }
            return null;
          },
        );

        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/file_selector'),
            null,
          );
        });

        final outputsData = OutputsData(
          type: 'sideswap_app',
          version: '2',
          timestamp: 1234567890,
          receivers: [
            OutputsReceiver(address: 'addr1', assetId: 'asset1', satoshi: 1000),
          ],
        );

        final container = ProviderContainer.test(
          overrides: [
            outputsReaderProvider.overrideWithValue(Right(outputsData)),
          ],
        );

        final result =
            await container.read(outputsCreatorProvider.notifier).saveToFile();

        expect(result, false);
      });

      // Issue #8: delegate to top-level _runSaveSuccessTest
      test('returns true and saves file with suggestedName', () async {
        await _runSaveSuccessTest(
          fileName: 'test_output_suggested.json',
          suggestedName: 'my_batch',
        );
      });

      test('returns true and saves file without suggestedName (default name)',
          () async {
        await _runSaveSuccessTest(
          fileName: 'test_output_default.json',
        );
      });

      test('stamps export timestamp at save time when build did not', () async {
        final savePath =
            '${Directory.systemTemp.path}/test_output_timestamp.json';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/file_selector'),
          (MethodCall methodCall) async {
            if (methodCall.method == 'getSavePath') {
              return savePath;
            }
            return null;
          },
        );

        addTearDown(() {
          final f = File(savePath);
          if (f.existsSync()) f.deleteSync();
        });

        // Build state carries no timestamp (OutputsCreator.build no longer
        // stamps one); the timestamp must be added at save time.
        final outputsData = OutputsData(
          type: 'sideswap_app',
          version: '2',
          receivers: [
            OutputsReceiver(address: 'addr1', assetId: 'asset1', satoshi: 1000),
          ],
        );

        final container = ProviderContainer.test(
          overrides: [
            outputsCreatorProvider.overrideWithBuild(
              (ref, notifier) => Right(outputsData),
            ),
          ],
        );

        final before = DateTime.now().millisecondsSinceEpoch;
        final result =
            await container.read(outputsCreatorProvider.notifier).saveToFile();
        final after = DateTime.now().millisecondsSinceEpoch;

        expect(result, true);
        final content =
            jsonDecode(File(savePath).readAsStringSync()) as Map<String, dynamic>;
        final timestamp = content['timestamp'] as int;
        expect(timestamp, greaterThanOrEqualTo(before));
        expect(timestamp, lessThanOrEqualTo(after));
      });
    });
  });

  group('outputsDataLength', () {
    test('returns 0 when outputsCreatorProvider is in error state', () {
      final container = ProviderContainer.test(
        overrides: [
          sendPopupSelectedAssetIdProvider.overrideWithValue(''),
          sendPopupAmountProvider.overrideWithValue(''),
          sendPopupAddressProvider.overrideWithValue(''),
          outputsReaderProvider.overrideWithValue(
            const Left(OutputsErrorOutputsDataIsEmpty()),
          ),
        ],
      );

      final length = container.read(outputsDataLengthProvider);

      expect(length, 0);
    });

    test('returns count of receivers when outputsCreatorProvider has data', () {
      final outputsData = OutputsData(
        type: 'sideswap_app',
        version: '2',
        timestamp: 1234567890,
        receivers: [
          OutputsReceiver(
            address: 'addr1',
            assetId: 'asset1',
            satoshi: 1000,
          ),
          OutputsReceiver(
            address: 'addr2',
            assetId: 'asset2',
            satoshi: 2000,
          ),
        ],
      );

      final mockSatoshiRepository = MockAbstractSatoshiRepository();
      when(() => mockSatoshiRepository.satoshiForAmount(
            amount: any(named: 'amount'),
            assetId: any(named: 'assetId'),
          )).thenReturn(0);

      final container = ProviderContainer.test(
        overrides: [
          sendPopupSelectedAssetIdProvider.overrideWithValue(''),
          sendPopupAmountProvider.overrideWithValue(''),
          sendPopupAddressProvider.overrideWithValue(''),
          satoshiRepositoryProvider
              .overrideWith((ref) => mockSatoshiRepository),
          outputsReaderProvider.overrideWithValue(Right(outputsData)),
        ],
      );

      final length = container.read(outputsDataLengthProvider);

      expect(length, 2);
    });

    final zeroReceiverCases = [
      (receivers: <OutputsReceiver>[] as List<OutputsReceiver>?, name: 'empty receivers'),
      (receivers: null as List<OutputsReceiver>?, name: 'null receivers'),
    ];

    for (final c in zeroReceiverCases) {
      test('returns 0 when ${c.name}', () {
        final outputsData = OutputsData(
          type: 'sideswap_app',
          version: '2',
          timestamp: 1234567890,
          receivers: c.receivers,
        );

        final container = ProviderContainer.test(
          overrides: [
            sendPopupSelectedAssetIdProvider.overrideWithValue(''),
            sendPopupAmountProvider.overrideWithValue(''),
            sendPopupAddressProvider.overrideWithValue(''),
            outputsReaderProvider.overrideWithValue(Right(outputsData)),
          ],
        );

        final length = container.read(outputsDataLengthProvider);

        expect(length, 0);
      });
    }

    test('returns 1 when receivers has one entry with satoshi==0 (not filtered by outputsCreator)', () {
      final outputsData = OutputsData(
        type: 'sideswap_app',
        version: '2',
        timestamp: 1234567890,
        receivers: [
          OutputsReceiver(address: 'addr', assetId: 'asset', satoshi: 0),
        ],
      );

      final container = ProviderContainer.test(
        overrides: [
          sendPopupSelectedAssetIdProvider.overrideWithValue(''),
          sendPopupAmountProvider.overrideWithValue(''),
          sendPopupAddressProvider.overrideWithValue(''),
          outputsReaderProvider.overrideWithValue(Right(outputsData)),
        ],
      );

      final length = container.read(outputsDataLengthProvider);

      expect(length, 1);
    });
  });

  group('Data classes', () {
    group('OutputsData', () {
      test('toJson includes all fields', () {
        final data = OutputsData(
          type: 'sideswap_app',
          version: '2',
          timestamp: 1234567890,
          receivers: [
            OutputsReceiver(address: 'addr', assetId: 'asset', satoshi: 1000)
          ],
        );

        final json = data.toJson();

        expect(json['type'], 'sideswap_app');
        expect(json['version'], '2');
        expect(json['timestamp'], 1234567890);
        expect(json['receivers'], hasLength(1));
        expect((json['receivers'] as List).first['address'], 'addr');
      });

      test('fromJson reconstructs object from JSON', () {
        final json = {
          'type': 'sideswap_app',
          'version': '2',
          'timestamp': 1234567890,
          'receivers': [
            {
              'address': 'addr1',
              'asset_id': 'asset1',
              'satoshi': 1000,
            }
          ],
        };

        final data = OutputsData.fromJson(json);

        expect(data.type, 'sideswap_app');
        expect(data.version, '2');
        expect(data.timestamp, 1234567890);
        expect(data.receivers, hasLength(1));
        expect(data.receivers!.first.address, 'addr1');
        expect(data.receivers!.first.assetId, 'asset1');
        expect(data.receivers!.first.satoshi, 1000);
      });

      test('copyWith creates new instance with updated fields', () {
        final original = OutputsData(
          type: 'sideswap_app',
          version: '2',
          timestamp: 1234567890,
        );

        final updated = original.copyWith(version: '3');

        expect(original.version, '2');
        expect(updated.version, '3');
        expect(updated.type, 'sideswap_app');
      });
    });

    group('OutputsReceiver', () {
      test('toJson serializes with snake_case field names', () {
        final receiver = OutputsReceiver(
          address: 'addr',
          assetId: 'asset',
          satoshi: 1000,
        );

        final json = receiver.toJson();

        expect(json['address'], 'addr');
        expect(json['asset_id'], 'asset');
        expect(json['satoshi'], 1000);
      });

      test('fromJson deserializes with snake_case field names', () {
        final json = {
          'address': 'addr',
          'asset_id': 'asset',
          'satoshi': 1000,
          'account': 0,
        };

        final receiver = OutputsReceiver.fromJson(json);

        expect(receiver.address, 'addr');
        expect(receiver.assetId, 'asset');
        expect(receiver.satoshi, 1000);
      });
    });

    group('IntToAccountConverter', () {
      const converter = IntToAccountConverter();

      // Issue #5: added Account.AMP_ case
      final fromJsonCases = [
        // Account.REG.value == 1 (protobuf enum); distinct from 0 which maps to null
        (input: Account.REG.value, expected: Account.REG, name: 'valid value → Account.REG'),
        (input: Account.AMP_.value, expected: Account.AMP_, name: 'AMP_ value → Account.AMP_'),
        // Account.valueOf(0) returns null — 0 is not a defined protobuf enum value
        (input: 0, expected: null, name: 'zero → null (Account.valueOf(0) == null)'),
        (input: null, expected: null, name: 'null → null'),
      ];

      for (final c in fromJsonCases) {
        test('fromJson: ${c.name}', () {
          expect(converter.fromJson(c.input), c.expected);
        });
      }

      final toJsonCases = [
        (input: Account.REG as Account?, expected: Account.REG.value, name: 'REG → value'),
        (input: Account.AMP_ as Account?, expected: Account.AMP_.value, name: 'AMP_ → value'),
        (input: null as Account?, expected: 0, name: 'null → 0'),
      ];

      for (final c in toJsonCases) {
        test('toJson: ${c.name}', () {
          expect(converter.toJson(c.input), c.expected);
        });
      }
    });

    group('DoubleToDecimalConverter', () {
      final converter = DoubleToDecimalConverter();

      // Issue #9: replace weak contains() with equals(Decimal.parse(...))
      final fromJsonCases = [
        (input: 123.45 as double?, name: 'double → Decimal', check: (Decimal? r) {
          expect(r, equals(Decimal.parse('123.45')));
        }),
        (input: null as double?, name: 'null → null', check: (Decimal? r) {
          expect(r, isNull);
        }),
      ];

      for (final c in fromJsonCases) {
        test('fromJson: ${c.name}', () {
          c.check(converter.fromJson(c.input));
        });
      }

      final toJsonCases = [
        (
          input: Decimal.parse('123.45') as Decimal?,
          name: 'Decimal → double',
          check: (double? r) => expect(r, closeTo(123.45, 1e-10)),
        ),
        (
          input: null as Decimal?,
          name: 'null → null',
          check: (double? r) => expect(r, isNull),
        ),
      ];

      for (final c in toJsonCases) {
        test('toJson: ${c.name}', () {
          c.check(converter.toJson(c.input));
        });
      }
    });

  });
}
