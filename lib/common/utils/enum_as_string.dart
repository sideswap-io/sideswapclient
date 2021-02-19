T enumValueFromString<T>(String key, Iterable<T> values) => values.firstWhere(
      (v) => v != null && key == v.asString(),
      orElse: () => null,
    );

extension EnumX on Object {
  String asString() => toString().split('.').last;
}
