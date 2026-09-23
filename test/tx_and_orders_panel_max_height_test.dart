import 'package:flutter_test/flutter_test.dart';
import 'package:sideswap/desktop/home/widgets/d_tx_and_orders_panel.dart';

/// `txAndOrdersPanelMaxHeight` is the rule that makes the transactions panel
/// the one that yields, on both pages that carry it. ADR-0014 decision 11.
void main() {
  test('leaves the whole column to the panel when there is room to spare', () {
    // `DHome` at the design height: 662 px of column, 16 of gap, and the
    // assets panel's 233 px lower bound leaves 413 -- more than the panel's
    // 228 px design height, so nothing is capped.
    expect(
      txAndOrdersPanelMaxHeight(
        available: 662,
        gap: 16,
        companionMinHeight: 233,
      ),
      413,
    );
  });

  test('caps the panel at what the companion does not need', () {
    // `DHome` at the supported floor: 442 px of column.
    expect(
      txAndOrdersPanelMaxHeight(
        available: 442,
        gap: 16,
        companionMinHeight: 233,
      ),
      193,
    );
  });

  test('stops yielding at the panel minimum rather than letting it vanish', () {
    // `DMarkets` at the supported floor: the order column's 380 px lower
    // bound would leave the panel 94 px, which is less than it may take.
    expect(
      txAndOrdersPanelMaxHeight(
        available: 490,
        gap: 16,
        companionMinHeight: 380,
      ),
      kTxAndOrdersPanelMinHeight,
    );
  });

  test('yields nothing below the minimum however little room there is', () {
    expect(
      txAndOrdersPanelMaxHeight(available: 0, gap: 16, companionMinHeight: 380),
      kTxAndOrdersPanelMinHeight,
    );
  });
}
