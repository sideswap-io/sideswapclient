import 'package:sideswap/protobuf/sideswap.pb.dart';

class TxItem implements Comparable<TxItem> {
  final TransItem item;
  final bool showDate;
  int createdAt;

  TxItem({
    this.item,
    this.showDate = false,
    this.createdAt,
  }) {
    createdAt = item.createdAt.toInt();
  }

  @override
  int compareTo(TxItem other) {
    return createdAt.compareTo(other.createdAt);
  }

  TxItem copyWith({
    TransItem item,
    int createdAt,
    bool showDate,
  }) {
    return TxItem(
      item: item ?? this.item,
      showDate: showDate ?? this.showDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is TxItem &&
        o.item == item &&
        o.showDate == showDate &&
        o.createdAt == createdAt;
  }

  @override
  int get hashCode => item.hashCode ^ showDate.hashCode ^ createdAt.hashCode;

  @override
  String toString() =>
      'TxItem(item: $item, showDate: $showDate, createdAt: $createdAt)';
}
