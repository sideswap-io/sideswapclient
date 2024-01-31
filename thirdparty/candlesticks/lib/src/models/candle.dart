// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Candle model wich holds a single candle data.
/// It contains five required double variables that hold a single candle data: high, low, open, close and volume.
/// It can be instantiated using its default constructor or fromJson named custructor.
class Candle {
  /// DateTime for the candle
  final DateTime date;

  /// The highet price during this candle lifetime
  /// It if always more than low, open and close
  final double high;

  /// The lowest price during this candle lifetime
  /// It if always less than high, open and close
  final double low;

  /// Price at the beginnig of the period
  final double open;

  /// Price at the end of the period
  final double close;

  /// Volume is the number of shares of a
  /// security traded during a given period of time.
  final double volume;

  bool get isBull => open <= close;

  Candle({
    required this.date,
    required this.high,
    required this.low,
    required this.open,
    required this.close,
    required this.volume,
  });

  Candle copyWith({
    DateTime? date,
    double? high,
    double? low,
    double? open,
    double? close,
    double? volume,
  }) {
    return Candle(
      date: date ?? this.date,
      high: high ?? this.high,
      low: low ?? this.low,
      open: open ?? this.open,
      close: close ?? this.close,
      volume: volume ?? this.volume,
    );
  }

  @override
  String toString() {
    return 'Candle(date: $date, high: $high, low: $low, open: $open, close: $close, volume: $volume)';
  }

  @override
  bool operator ==(covariant Candle other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.high == high &&
        other.low == low &&
        other.open == open &&
        other.close == close &&
        other.volume == volume;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        high.hashCode ^
        low.hashCode ^
        open.hashCode ^
        close.hashCode ^
        volume.hashCode;
  }
}
