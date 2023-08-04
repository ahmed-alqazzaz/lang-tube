// ignore_for_file: public_member_api_docs, sort_constructors_first
final class Loop {
  final Duration start;
  final Duration end;
  const Loop({required this.start, required this.end})
      : assert(end > start, "Loop end position must be lower than its start");
  Duration get duration => end - start;

  Loop copyWith({Duration? start, Duration? end}) {
    return Loop(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  String toString() => 'Loop(start: $start, end: $end)';

  @override
  bool operator ==(covariant Loop other) {
    if (identical(this, other)) return true;

    return other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}
