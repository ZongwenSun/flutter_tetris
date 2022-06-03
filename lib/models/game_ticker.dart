import 'dart:async';

typedef OnTickListener = void Function(GameTicker ticker, Duration passedTime);

class GameTicker {
  final OnTickListener listener;
  Duration internal;

  Stopwatch stopwatch = Stopwatch();
  Timer? _timer;

  GameTicker(this.internal, this.listener);

  void start() {
    if (!stopwatch.isRunning) {
      stopwatch.start();
    }
    _scheduleTimer();
  }

  void _scheduleTimer() {
    _timer = Timer.periodic(internal, (timer) {
      listener(this, stopwatch.elapsed);
    });
  }

  void pause() {
    _timer?.cancel();
  }

  void reset() {
    stopwatch.reset();
    _timer?.cancel();
  }

  void setInternel(Duration duration) {
    internal = duration;
    if (_timer != null) {
      _timer!.cancel();
      _scheduleTimer();
    }
  }
}
