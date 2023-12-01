extension Capitilization on String {
  String capitalize() =>
      "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
}
