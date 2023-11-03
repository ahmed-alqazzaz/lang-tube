bool intToBool(int integer) {
  assert([0, 1].contains(integer), 'integer must be 1 or 0');
  return integer == 1;
}
