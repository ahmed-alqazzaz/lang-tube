import 'dart:async';

// when called multiple times before timeout,
// only the last call executes
Timer? _timer;
void debouncer(Duration timeout, void Function() callback) {
  _timer?.cancel();
  _timer = Timer(timeout, callback);
}
