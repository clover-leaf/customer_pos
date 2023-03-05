extension RoundDouble on double {
  double roundTo(int n) {
    return double.parse(toStringAsFixed(n));
  }
}
