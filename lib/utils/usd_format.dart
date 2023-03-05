extension ToUSD on double {
  String toUsd() {
    return '\$${toStringAsFixed(2)}';
  }
}
