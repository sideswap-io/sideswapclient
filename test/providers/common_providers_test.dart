import 'dart:ffi' as ffi;

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/common/enums.dart';
import 'package:sideswap/common/utils/sideswap_logger.dart';
import 'package:sideswap/models/client_ffi.dart';
import 'package:sideswap/providers/common_providers.dart';
import 'package:sideswap/side_swap_client_ffi.dart';
import 'package:sideswap_logger/custom_logger.dart';

class MockNativeLibrary extends Mock implements NativeLibrary {}

class _NoOpLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}

void main() {
  late MockNativeLibrary mockLib;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    logger = CustomLogger('SideSwap', output: _NoOpLogOutput());
    mockLib = MockNativeLibrary();
    Lib.lib = mockLib;
    registerFallbackValue(ffi.Pointer<ffi.Char>.fromAddress(0));
  });

  setUp(() {
    reset(mockLib);
  });

  group('isAddrTypeValid', () {
    group('returns false when', () {
      test('addr is empty string', () {
        final container = ProviderContainer.test(
          overrides: [
            libClientStateProvider
                .overrideWithValue(const LibClientState.initialized()),
            libClientIdProvider.overrideWithValue(1),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(isAddrTypeValidProvider('', AddrType.bitcoin)),
          false,
        );
        verifyNever(() => mockLib.sideswap_check_addr(any(), any(), any()));
      });

      test('libClientState is empty', () {
        final container = ProviderContainer.test(
          overrides: [
            libClientStateProvider
                .overrideWithValue(const LibClientState.empty()),
            libClientIdProvider.overrideWithValue(1),
          ],
        );
        addTearDown(container.dispose);

        expect(
          container.read(isAddrTypeValidProvider('validaddr', AddrType.bitcoin)),
          false,
        );
        verifyNever(() => mockLib.sideswap_check_addr(any(), any(), any()));
      });
    });

    group('FFI path', () {
      final ffiCases = [
        (addrType: AddrType.bitcoin, ffiReturn: true, expectedConst: SIDESWAP_BITCOIN, name: 'bitcoin addr returns true when FFI validates'),
        (addrType: AddrType.bitcoin, ffiReturn: false, expectedConst: SIDESWAP_BITCOIN, name: 'bitcoin addr returns false when FFI rejects'),
        (addrType: AddrType.elements, ffiReturn: true, expectedConst: SIDESWAP_ELEMENTS, name: 'elements addr returns true when FFI validates'),
        (addrType: AddrType.elements, ffiReturn: false, expectedConst: SIDESWAP_ELEMENTS, name: 'elements addr returns false when FFI rejects'),
      ];

      for (final c in ffiCases) {
        test(c.name, () {
          when(() => mockLib.sideswap_check_addr(any(), any(), any()))
              .thenReturn(c.ffiReturn);

          final container = ProviderContainer.test(
            overrides: [
              libClientStateProvider.overrideWithValue(const LibClientState.initialized()),
              libClientIdProvider.overrideWithValue(42),
            ],
          );
          addTearDown(container.dispose);

          final result = container.read(
            isAddrTypeValidProvider('validaddr', c.addrType),
          );

          expect(result, c.ffiReturn);
          verify(() => mockLib.sideswap_check_addr(42, any(), c.expectedConst)).called(1);
        });
      }
    });
  });
}
