// ignore: implementation_imports
import 'package:easy_localization/src/localization.dart';
// ignore: implementation_imports
import 'package:easy_localization/src/translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sideswap/common/sideswap_colors.dart';
import 'package:sideswap/common/widgets/peg_in_info_lines.dart';
import 'package:sideswap/providers/pegs_provider.dart';
import 'package:sideswap/providers/server_status_providers.dart';

class MockPegRepository extends Mock implements AbstractPegRepository {}

/// The peg-in copy exactly as shipped in `assets/translations/en.json`, so
/// `.tr(args:)` interpolates the amount for real instead of echoing the key.
Translations get _englishPegInCopy => Translations({
  'PEGIN_1STLINE': 'Your wallet auto-generates the receiving L-BTC address.',
  'PEGIN_2NDLINE':
      'Each peg-in gets a unique address you can revisit to track progress.',
  'PEGIN_CONVERSION_RATE': 'Conversion rate: {}%',
  'PEGIN_LESS': 'Instant credit up to',
  'PEGIN_LESS_AMOUNT': ' {} BTC',
  'PEGIN_LESS_END': ', after 2 Bitcoin confirmations.\n',
  'PEGIN_GREATER': 'Above',
  'PEGIN_GREATER_AMOUNT': ' {} BTC',
  'PEGIN_GREATER_END': ': up to 103 confirmations.\n',
  'PEGIN_RELEASED': 'Network fee: 300 sats. Instant credit limit:',
  'PEGIN_RELEASED_END': '.',
  'PEGIN_INSTANT_UNAVAILABLE':
      'Instant credit temporarily unavailable, peg-ins currently require up to '
      '103 confirmations.',
  'PEGIN_FEE_LINE': 'Network fee: 300 sats.',
});

void main() {
  late MockPegRepository mockPegRepository;

  // `Localization` is a process-wide singleton, so per docs/TESTING.md the
  // store is reloaded in setUp -- never setUpAll, which would leak the map
  // into whatever runs next under a randomised ordering seed.
  setUp(() {
    Localization.load(const Locale('en'), translations: _englishPegInCopy);
    mockPegRepository = MockPegRepository();
    when(() => mockPegRepository.pegInWalletBalance()).thenReturn('0.1');
    when(
      () => mockPegRepository.pegInWalletBalanceLoaded(),
    ).thenReturn(true);
    when(
      () => mockPegRepository.pegInInstantCreditAvailable(),
    ).thenReturn(true);
  });

  tearDownAll(() {
    Localization.load(const Locale('en'));
  });

  // The default fee percent is non-zero so the conversion row renders in every
  // loaded state -- the not-loaded and unavailable groups then prove those
  // states suppress or keep the row for their own reasons, not because the
  // percent happened to be zero.
  Future<void> pumpInfoLines(
    WidgetTester tester, {
    required double bulletSpacing,
    double pegInServerFeePercent = 0.25,
  }) => tester.pumpWidget(
    ProviderScope(
      overrides: [
        pegRepositoryProvider.overrideWith((ref) => mockPegRepository),
        pegInServerFeePercentProvider.overrideWithValue(pegInServerFeePercent),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: PegInInfoLines(bulletSpacing: bulletSpacing),
        ),
      ),
    ),
  );

  /// The amount bullets are composed `TextSpan` trees, so a plain-text finder
  /// cannot see them -- flatten every rendered span instead.
  List<String> renderedLines(WidgetTester tester) => tester
      .widgetList<RichText>(find.byType(RichText))
      .map((richText) => richText.text.toPlainText())
      .toList();

  /// Every child span of every composed bullet, in render order.
  List<TextSpan> amountSpans(WidgetTester tester) => tester
      .widgetList<RichText>(find.byType(RichText))
      .map((richText) => richText.text)
      .whereType<TextSpan>()
      .expand((span) => span.children ?? const <InlineSpan>[])
      .whereType<TextSpan>()
      .toList();

  /// The vertical gaps between bullets, in order. The horizontal gap after each
  /// bullet dot has no height, so it is filtered out.
  List<double> bulletGaps(WidgetTester tester) => tester
      .widgetList<SizedBox>(find.byType(SizedBox))
      .map((sizedBox) => sizedBox.height)
      .nonNulls
      .toList();

  group('PegInInfoLines', () {
    testWidgets('renders the intro bullets and the interpolated amount bullets', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 8);

      final lines = renderedLines(tester);
      expect(
        lines,
        containsAll([
          'Your wallet auto-generates the receiving L-BTC address.',
          'Each peg-in gets a unique address you can revisit to track progress.',
          'Instant credit up to 0.1 BTC, after 2 Bitcoin confirmations.\n',
          'Above 0.1 BTC: up to 103 confirmations.\n',
          'Network fee: 300 sats. Instant credit limit: 0.1 BTC.',
        ]),
      );
      // The unavailable copy belongs only to the other branch.
      expect(lines, isNot(contains(contains('temporarily unavailable'))));
    });

    testWidgets('computes the conversion bullet as 100 minus the peg-in fee '
        'percent', (tester) async {
      await pumpInfoLines(tester, bulletSpacing: 8, pegInServerFeePercent: 0.25);

      expect(renderedLines(tester), contains('Conversion rate: 99.75%'));
    });

    testWidgets('recomputes the conversion bullet for a whole-percent fee', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 8, pegInServerFeePercent: 1);

      expect(renderedLines(tester), contains('Conversion rate: 99.00%'));
    });

    testWidgets('hides the conversion bullet when the peg-in fee percent is '
        'zero', (tester) async {
      await pumpInfoLines(tester, bulletSpacing: 11, pegInServerFeePercent: 0);

      final lines = renderedLines(tester);
      expect(lines, isNot(contains(contains('Conversion rate'))));
      // The rest of the block is unaffected by the hidden conversion row.
      expect(
        lines,
        containsAll([
          'Your wallet auto-generates the receiving L-BTC address.',
          'Instant credit up to 0.1 BTC, after 2 Bitcoin confirmations.\n',
        ]),
      );
    });

    testWidgets('highlights the amount as its own span in each amount bullet', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 8);

      // The amount carries the highlight on its own span; the copy around it
      // does not. Flattening the tree would hide exactly that distinction.
      final highlighted = amountSpans(tester)
          .where((span) => span.style?.color == SideSwapColors.brightTurquoise)
          .map((span) => span.text)
          .toList();

      expect(highlighted, [' 0.1 BTC', ' 0.1 BTC', ' 0.1 BTC']);
    });

    testWidgets('spaces the bullets at the caller\'s mobile gap', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 8);

      expect(bulletGaps(tester), [8, 8, 8]);
    });

    testWidgets('spaces the bullets at the caller\'s desktop gap', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 11);

      expect(bulletGaps(tester), [11, 11, 11]);
    });

    testWidgets('drops the conversion gap along with the conversion bullet', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 11, pegInServerFeePercent: 0);

      expect(bulletGaps(tester), [11, 11]);
    });
  });

  group('PegInInfoLines when the instant credit limit has not loaded', () {
    setUp(() {
      when(
        () => mockPegRepository.pegInWalletBalanceLoaded(),
      ).thenReturn(false);
    });

    testWidgets('renders nothing at all -- no bullets, no copy', (tester) async {
      // A non-zero fee percent would normally show the conversion row; the
      // not-loaded early return must win over it.
      await pumpInfoLines(tester, bulletSpacing: 8);

      // Every visible line is a RichText (Text builds one), so an empty list is
      // proof the block made no claim -- not an empty bullet, not a placeholder.
      expect(renderedLines(tester), isEmpty);
      // Not even the intro bullets that render in every loaded state.
      expect(
        find.textContaining('Your wallet auto-generates'),
        findsNothing,
      );
      // The block's only output is the empty shrink box.
      expect(
        find.descendant(
          of: find.byType(PegInInfoLines),
          matching: find.byType(SizedBox),
        ),
        findsOneWidget,
      );
    });

    testWidgets('never reads the balance or the availability branch', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 8);

      verifyNever(() => mockPegRepository.pegInWalletBalance());
      verifyNever(() => mockPegRepository.pegInInstantCreditAvailable());
    });
  });

  group('PegInInfoLines when instant credit is unavailable', () {
    setUp(() {
      when(
        () => mockPegRepository.pegInInstantCreditAvailable(),
      ).thenReturn(false);
    });

    testWidgets(
      'hides the three amount bullets and shows the unavailable sentence plus '
      'the standalone fee line',
      (tester) async {
        await pumpInfoLines(tester, bulletSpacing: 8);

        final lines = renderedLines(tester);
        expect(
          lines,
          containsAll([
            'Instant credit temporarily unavailable, peg-ins currently require '
                'up to 103 confirmations.',
            'Network fee: 300 sats.',
          ]),
        );
        // None of the amount bullets, and nothing quoting the zero limit.
        expect(lines, isNot(contains(contains('Instant credit up to'))));
        expect(lines, isNot(contains(contains('up to 103 confirmations.\n'))));
        expect(lines, isNot(contains(contains('Instant credit limit:'))));
      },
    );

    testWidgets('never reads the formatted wallet balance in this state', (
      tester,
    ) async {
      await pumpInfoLines(tester, bulletSpacing: 8);

      verifyNever(() => mockPegRepository.pegInWalletBalance());
    });

    testWidgets('still renders both intro bullets', (tester) async {
      await pumpInfoLines(tester, bulletSpacing: 8);

      expect(
        renderedLines(tester),
        containsAll([
          'Your wallet auto-generates the receiving L-BTC address.',
          'Each peg-in gets a unique address you can revisit to track progress.',
        ]),
      );
    });

    testWidgets(
      'still shows the conversion bullet, independent of the zero limit',
      (tester) async {
        // Regression guard for #139: the conversion row and the instant-credit
        // state are independent rules -- a non-zero fee keeps the row here.
        await pumpInfoLines(tester, bulletSpacing: 8, pegInServerFeePercent: 1);

        expect(renderedLines(tester), contains('Conversion rate: 99.00%'));
      },
    );

    testWidgets('hides the conversion bullet when the peg-in fee percent is '
        'zero', (tester) async {
      await pumpInfoLines(tester, bulletSpacing: 8, pegInServerFeePercent: 0);

      final lines = renderedLines(tester);
      expect(lines, isNot(contains(contains('Conversion rate'))));
      expect(
        lines,
        contains(
          'Instant credit temporarily unavailable, peg-ins currently require '
          'up to 103 confirmations.',
        ),
      );
    });
  });
}
