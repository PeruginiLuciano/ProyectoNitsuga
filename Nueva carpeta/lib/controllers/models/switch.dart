enum SwitchStatus {
  off(0), on(1), state(2);

  const SwitchStatus(this.statusNumber);
  final int statusNumber;

  static SwitchStatus fromByte(int byte) =>
      SwitchStatus.values.firstWhere((element) => element.statusNumber == byte, orElse: () => SwitchStatus.off);
}