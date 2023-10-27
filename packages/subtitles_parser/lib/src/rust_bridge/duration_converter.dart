import 'package:subtitles_parser/src/rust_bridge/bridge_generated.dart';

extension DurationConverter on RustDuration {
  Duration toDart() => Duration(seconds: secs, milliseconds: millis);
}
