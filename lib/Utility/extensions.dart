extension ListExtensions<T> on List<T> {
  Iterable<R> mapIndexed<R>(R Function(T item, int index) f) sync* {
    for (int i = 0; i < length; i++) {
      yield f(this[i], i);
    }
  }
}
