extension Monadic<T> on T {
  T also(Function(T) f) {
    f(this);
    return this;
  }
}