T? enumValueFromString<T>(String key, Iterable<T> values) {
  try {
    final value = values.firstWhere((v) => v != null && key == v.asString());

    return value;
  } on StateError {
    return null;
  }
}

extension EnumX on Object {
  String asString() => toString().split('.').last;
}
