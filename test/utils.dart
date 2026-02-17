import 'package:mocktail/mocktail.dart';

class ProviderListener<T> extends Mock {
  void call(T? previous, T next);
}
