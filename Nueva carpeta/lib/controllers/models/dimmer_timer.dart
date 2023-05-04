import 'dart:async';

class DimmerTimer {
  Timer? _timer;
  final Function(int value) _sendFunction;
  int _currentValue = 0;
  int _oldValue = 0;

  DimmerTimer(this._sendFunction);

  void start(double value) {
    _currentValue = (value * 100).round();
    _oldValue = _currentValue;
    _timer =  Timer.periodic(const Duration(milliseconds: 200), _dimmerTimerCallback);
    _sendFunction(_currentValue);
  }

  void update(double newValue) {
    _currentValue = (newValue * 100).round();
  }

  void finish(double value) {
    _currentValue = (value * 100).round();
    _timer?.cancel();
    _sendFunction(_currentValue);
  }

  void _dimmerTimerCallback(Timer timer) {
    if (_oldValue != _currentValue) {
      _oldValue = _currentValue;
      _sendFunction(_currentValue);
    }
  }
}