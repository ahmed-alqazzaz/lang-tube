part of 'tapster.dart';

final _throttler = Throttler.privateInstance();

abstract mixin class TapsResolver {
  late final TapPriority _tapPriority;

  _TapType? _currentTap;
  Timer? _executor;
  bool _isResolverInitialized = false;

  void initialize({required TapPriority tapPriority}) {
    assert(!_isResolverInitialized);
    _tapPriority = tapPriority;
    _isResolverInitialized = true;
  }

  void resolveInsideTap() {
    assert(_isResolverInitialized);
    if (_currentTap == _TapType.outside) {
      if (_tapPriority != TapPriority.insideEvents) {
        return;
      } else {
        _executor?.cancel();
      }
    }
    log('1 $_currentTap');
    _updateCurrentTap(_TapType.inside);
    _executor = Timer(
      _tapPriority == TapPriority.outsideEvents
          ? _defaultDuration
          : Duration.zero,
      tapInside,
    );
  }

  void resolveOutsideTap() {
    assert(_isResolverInitialized);
    if (_currentTap == _TapType.inside) {
      if (_tapPriority != TapPriority.outsideEvents) {
        return;
      } else {
        log('cancelled');
        _executor?.cancel();
      }
    }
    log('2 $_currentTap');
    _updateCurrentTap(_TapType.outside);
    _executor = Timer(
      _tapPriority == TapPriority.insideEvents
          ? _defaultDuration
          : Duration.zero,
      tapOutside,
    );
  }

  void _updateCurrentTap(_TapType value) {
    assert(_isResolverInitialized);
    _currentTap = value;
    _throttler.throttle(const Duration(milliseconds: 800), () {
      log("nullifying");
      _currentTap = null;
    });
  }

  void tapOutside();
  void tapInside();

  static const Duration _defaultDuration = Duration(milliseconds: 100);
}
