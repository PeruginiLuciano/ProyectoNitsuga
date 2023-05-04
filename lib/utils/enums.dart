enum TriState {
  enabled, disabled, waiting
}

extension TriStateExtension on TriState {
  bool isEnabled() => this == TriState.enabled;
  bool isWaiting() => this == TriState.waiting;
}