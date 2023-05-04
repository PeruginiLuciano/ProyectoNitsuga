extension DoubleExtension on double {
  double zeroIfNegative() => this < 0 ? 0 : this;
  String toStringIncludingSign(int precision) => "${this >= 0 ? "+" : ""}${toStringAsPrecision(precision)}";
}

extension IntExtension on int {
  bool isBitSet(int bit) {
    int bitToCheck = (0x01 << (bit - 1));
    return this & bitToCheck == bitToCheck;
  }

  int limitedTo(int minValue, int maxValue) => this < minValue ? minValue : (this > maxValue ? maxValue : this);
  String toStringIncludingSign() => "${this >= 0 ? "+" : ""}$this";
}