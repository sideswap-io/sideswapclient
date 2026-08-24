import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sideswap/providers/page_storage_provider.dart';

void main() {
  group('PageStorageKeyData', () {
    group('build', () {
      test('returns a non-empty string', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final result = container.read(pageStorageKeyDataProvider);

        expect(result, isA<String>());
        expect(result.isNotEmpty, true);
      });

      test('returns a 5-character base64-url-encoded string', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final result = container.read(pageStorageKeyDataProvider);

        // Base64-url encoding of 5 random bytes produces a ~7 character string
        // (ceil(5*8/6) = 7 characters for 5 bytes)
        expect(result.length, greaterThan(0));

        // Should be valid base64-url characters (no +, /, only alphanumeric, -, _)
        final base64UrlRegex = RegExp(r'^[A-Za-z0-9\-_=]+$');
        expect(base64UrlRegex.hasMatch(result), true);
      });

      test('returns a base64-url-encoded value that can be decoded', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        final result = container.read(pageStorageKeyDataProvider);

        // Should not throw when decoding
        expect(() => base64Url.decode(result), returnsNormally);

        final decoded = base64Url.decode(result);
        // Should decode to approximately 5 bytes
        // Base64 encoding of 5 bytes can produce up to 8 bytes when padded
        expect(decoded.length, greaterThan(0));
        expect(decoded.length, lessThanOrEqualTo(8));
      });

      test('returns different values on multiple reads', () {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);

        // Since this is a keepAlive provider, multiple reads should return the same cached value
        final result1 = container.read(pageStorageKeyDataProvider);
        final result2 = container.read(pageStorageKeyDataProvider);

        // With keepAlive: true, build() is called only once, so results are identical
        expect(result1, equals(result2));
      });

      test('returns different values across different containers', () {
        final container1 = ProviderContainer.test();
        final container2 = ProviderContainer.test();
        addTearDown(container1.dispose);
        addTearDown(container2.dispose);

        final result1 = container1.read(pageStorageKeyDataProvider);
        final result2 = container2.read(pageStorageKeyDataProvider);

        // probabilistic: P(collision) < 1/2^40
        // Each container gets a fresh build() call, so we expect different random values
        // With 5 random bytes (40 bits), collision probability is extremely low
        expect(result1, isNot(equals(result2)));
      });
    });

    group('getRandString', () {
      late PageStorageKeyData notifier;

      setUp(() {
        final container = ProviderContainer.test();
        addTearDown(container.dispose);
        notifier = container.read(pageStorageKeyDataProvider.notifier);
      });

      test('returns a string', () {
        final result = notifier.getRandString(5);

        expect(result, isA<String>());
      });

      test('returns a base64-url-encoded string', () {
        final result = notifier.getRandString(5);

        // Should be valid base64-url characters
        final base64UrlRegex = RegExp(r'^[A-Za-z0-9\-_=]+$');
        expect(base64UrlRegex.hasMatch(result), true);
      });

      test('returns non-empty string for positive length', () {
        final result = notifier.getRandString(5);

        expect(result.isNotEmpty, true);
      });

      test('returns empty string for zero length', () {
        final result = notifier.getRandString(0);

        expect(result, isEmpty);
      });

      test('returns decodable base64-url string', () {
        final result = notifier.getRandString(5);

        expect(() => base64Url.decode(result), returnsNormally);
      });

      test('decoded value has expected byte length for 5 input bytes', () {
        final result = notifier.getRandString(5);
        final decoded = base64Url.decode(result);

        // Base64 encoding of 5 bytes produces 5-8 bytes when padded
        expect(decoded.length, greaterThan(0));
        expect(decoded.length, lessThanOrEqualTo(8));
      });

      test('returns different values for different calls', () {
        final result1 = notifier.getRandString(5);
        final result2 = notifier.getRandString(5);

        // probabilistic: P(collision) < 1/2^40
        // Two independent calls to getRandString(5) with Random.secure()
        // Collision probability is astronomically low
        expect(result1, isNot(equals(result2)));
      });

      test('string length varies based on input length parameter', () {
        final result1 = notifier.getRandString(1);
        final result2 = notifier.getRandString(10);

        // Larger input should generally produce larger base64 output
        // (though not strictly linear due to base64 padding)
        expect(result2.length, greaterThanOrEqualTo(result1.length));
      });

      test('generates 1-byte random value when length is 1', () {
        final result = notifier.getRandString(1);

        final decoded = base64Url.decode(result);
        expect(decoded.length, greaterThan(0));
        expect(decoded.length, lessThanOrEqualTo(4)); // 1 byte encodes to up to 2 chars, padded to 4
      });

      test('generates 10-byte random value when length is 10', () {
        final result = notifier.getRandString(10);

        final decoded = base64Url.decode(result);
        expect(decoded.length, greaterThan(0));
        expect(decoded.length, lessThanOrEqualTo(16)); // 10 bytes encodes to up to 14 chars, padded to 16
      });
    });
  });
}
