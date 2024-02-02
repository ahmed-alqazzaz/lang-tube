extension Booleanizer on int {
  bool toBool() {
    assert([0, 1].contains(this), 'integer must be 1 or 0');
    return this == 1;
  }
}
