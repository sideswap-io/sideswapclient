import 'package:sideswap_protobuf/sideswap_api.dart';

class TxItem implements Comparable<TxItem> {
  final TransItem item;
  final bool showDate;
  final int _createdAt;

  int get createdAt => _createdAt;

  TxItem({
    required this.item,
    this.showDate = false,
    int? createdAt,
  }) : _createdAt = item.createdAt.toInt();

  @override
  int compareTo(TxItem other) {
    return _createdAt.compareTo(other._createdAt);
  }

  TxItem copyWith({
    TransItem? item,
    bool? showDate,
    int? createdAt,
  }) {
    return TxItem(
      item: item ?? this.item,
      showDate: showDate ?? this.showDate,
      createdAt: createdAt ?? _createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TxItem &&
        other.item == item &&
        other.showDate == showDate &&
        other._createdAt == _createdAt;
  }

  @override
  int get hashCode => item.hashCode ^ showDate.hashCode ^ _createdAt.hashCode;

  @override
  String toString() =>
      'TxItem(item: $item, showDate: $showDate, createdAt: $_createdAt)';
}
