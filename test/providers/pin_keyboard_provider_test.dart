import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sideswap/providers/pin_keyboard_provider.dart';

void main() {
  group('PinKeyboardHelper', () {
    group('indexToKey', () {
      late PinKeyboardHelper helper;

      setUp(() {
        final container = ProviderContainer();
        helper = container.read(pinKeyboardHelperProvider);
      });

      // Table-driven tests for all valid and boundary indices
      const cases = [
        (index: -1, expected: PinKeyEnum.backspace),
        (index: 0, expected: PinKeyEnum.one),
        (index: 1, expected: PinKeyEnum.two),
        (index: 2, expected: PinKeyEnum.three),
        (index: 3, expected: PinKeyEnum.four),
        (index: 4, expected: PinKeyEnum.five),
        (index: 5, expected: PinKeyEnum.six),
        (index: 6, expected: PinKeyEnum.seven),
        (index: 7, expected: PinKeyEnum.eight),
        (index: 8, expected: PinKeyEnum.nine),
        (index: 9, expected: PinKeyEnum.backspace),
        (index: 10, expected: PinKeyEnum.zero),
        (index: 11, expected: PinKeyEnum.enter),
        // Boundary: index >= 12 should return backspace
        (index: 13, expected: PinKeyEnum.backspace),
        (index: 100, expected: PinKeyEnum.backspace),
      ];

      for (final c in cases) {
        test('returns ${c.expected} for index ${c.index}', () {
          expect(helper.indexToKey(c.index), c.expected);
        });
      }
    });

    group('pinKeyboardHelperProvider', () {
      test('returns a PinKeyboardHelper instance', () {
        final container = ProviderContainer();
        final helper = container.read(pinKeyboardHelperProvider);

        expect(helper, isA<PinKeyboardHelper>());
      });

      test('returns the same instance within the same container', () {
        final container = ProviderContainer();
        final helper1 = container.read(pinKeyboardHelperProvider);
        final helper2 = container.read(pinKeyboardHelperProvider);

        expect(helper1, same(helper2));
      });

      test('returns different instances in different containers', () {
        final container1 = ProviderContainer();
        final container2 = ProviderContainer();
        final helper1 = container1.read(pinKeyboardHelperProvider);
        final helper2 = container2.read(pinKeyboardHelperProvider);

        expect(helper1, isNot(same(helper2)));
      });

      test('provides ref to the helper', () {
        final container = ProviderContainer();
        final helper = container.read(pinKeyboardHelperProvider);

        expect(helper.ref, isNotNull);
      });
    });

    group('stream initialization', () {
      late PinKeyboardHelper helper;

      setUp(() {
        final container = ProviderContainer();
        helper = container.read(pinKeyboardHelperProvider);
      });

      test('pinKeyStream is a stream of PinKeyEnum', () {
        expect(helper.pinKeyStream, isA<Stream<PinKeyEnum>>());
      });

      test('pinKeySubject is initialized', () {
        expect(helper.pinKeySubject, isNotNull);
      });
    });

    group('keyPressed', () {
      late PinKeyboardHelper helper;

      setUp(() {
        final container = ProviderContainer();
        helper = container.read(pinKeyboardHelperProvider);
      });

      test('adds key to pinKeySubject', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.keyPressed(0);
        // Give the stream time to process
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.one]);

        addTearDown(subscription.cancel);
      });

      test('converts index 1 to PinKeyEnum.two', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.keyPressed(1);
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.two]);

        addTearDown(subscription.cancel);
      });

      test('converts index 9 to PinKeyEnum.backspace', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.keyPressed(9);
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.backspace]);

        addTearDown(subscription.cancel);
      });

      test('converts index 10 to PinKeyEnum.zero', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.keyPressed(10);
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.zero]);

        addTearDown(subscription.cancel);
      });

      test('converts index 11 to PinKeyEnum.enter', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.keyPressed(11);
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.enter]);

        addTearDown(subscription.cancel);
      });

      test('handles invalid index by emitting backspace', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.keyPressed(-1);
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.backspace]);

        addTearDown(subscription.cancel);
      });
    });

    group('onDesktopKeyChanged', () {
      late PinKeyboardHelper helper;

      setUp(() {
        final container = ProviderContainer();
        helper = container.read(pinKeyboardHelperProvider);
      });

      test('does nothing when oldValue equals newValue', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.onDesktopKeyChanged('123', '123');
        await Future.delayed(Duration.zero);

        expect(emissions, isEmpty);

        addTearDown(subscription.cancel);
      });

      test('emits backspace for each deleted character', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.onDesktopKeyChanged('12', '');
        await Future.delayed(Duration.zero);

        expect(emissions, [
          PinKeyEnum.backspace,
          PinKeyEnum.backspace,
        ]);

        addTearDown(subscription.cancel);
      });

      test('emits backspace for deleted characters and keys for new ones', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.onDesktopKeyChanged('12', '34');
        await Future.delayed(Duration.zero);

        expect(emissions, [
          PinKeyEnum.backspace,
          PinKeyEnum.backspace,
          PinKeyEnum.three,
          PinKeyEnum.four,
        ]);

        addTearDown(subscription.cancel);
      });

      test('handles digit 0 correctly by emitting key at index 10', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.onDesktopKeyChanged('', '0');
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.zero]);

        addTearDown(subscription.cancel);
      });

      test('emits correct keys for digits 1-9', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.onDesktopKeyChanged('', '123456789');
        await Future.delayed(Duration.zero);

        expect(emissions, [
          PinKeyEnum.one,
          PinKeyEnum.two,
          PinKeyEnum.three,
          PinKeyEnum.four,
          PinKeyEnum.five,
          PinKeyEnum.six,
          PinKeyEnum.seven,
          PinKeyEnum.eight,
          PinKeyEnum.nine,
        ]);

        addTearDown(subscription.cancel);
      });

      test('handles non-numeric characters by treating as -1 (backspace)', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.onDesktopKeyChanged('', 'a');
        await Future.delayed(Duration.zero);

        expect(emissions, [PinKeyEnum.backspace]);

        addTearDown(subscription.cancel);
      });

      test('handles mixed case of adding and removing characters', () async {
        final emissions = <PinKeyEnum>[];
        final subscription = helper.pinKeySubject.listen((key) {
          emissions.add(key);
        });

        helper.onDesktopKeyChanged('123', '45');
        await Future.delayed(Duration.zero);

        expect(emissions, [
          PinKeyEnum.backspace,
          PinKeyEnum.backspace,
          PinKeyEnum.backspace,
          PinKeyEnum.four,
          PinKeyEnum.five,
        ]);

        addTearDown(subscription.cancel);
      });
    });
  });
}
