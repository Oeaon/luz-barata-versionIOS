import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/prices.dart';
import '../data/pvpc_repository.dart';
import '../data/settings_store.dart';

enum DaySelection { today, tomorrow }

sealed class DayState {
  const DayState();
}

class DayLoading extends DayState {
  const DayLoading();
}

class DayReady extends DayState {
  const DayReady(this.prices);

  final DayPrices prices;
}

class DayUnpublished extends DayState {
  const DayUnpublished();
}

class DayFailed extends DayState {
  const DayFailed({required this.network});

  final bool network;
}

class MainController extends ChangeNotifier {
  MainController(this.settings, this._prices) {
    settings.addListener(_onSettings);
    _tick();
  }

  final SettingsStore settings;
  final PvpcRepository _prices;

  DaySelection selection = DaySelection.today;
  DayState today = const DayLoading();
  DayState tomorrow = const DayLoading();
  DateTime now = DateTime.now().toUtc();
  bool refreshing = false;

  (DateTime, PvpcZone)? _loadedFor;
  int _loadRun = 0;
  Timer? _timer;

  DayState get selected => selection == DaySelection.today ? today : tomorrow;

  void select(DaySelection value) {
    selection = value;
    notifyListeners();
  }

  Future<void> refresh() async {
    refreshing = true;
    notifyListeners();
    await _load(refresh: true);
  }

  void _onSettings() {
    _loadIfNeeded();
    notifyListeners();
  }

  /// Cada minuto: actualiza la hora en curso, recarga a medianoche y por la tarde reintenta mañana.
  void _tick() {
    now = DateTime.now().toUtc();
    _loadIfNeeded();
    _retryTomorrowIfDue();
    notifyListeners();
    _timer = Timer(Duration(milliseconds: 60000 - now.millisecondsSinceEpoch % 60000), _tick);
  }

  /// Carga al arrancar, al cambiar de zona y a medianoche.
  void _loadIfNeeded() {
    final key = (spainToday(), settings.zone);
    if (key != _loadedFor) {
      _loadedFor = key;
      today = const DayLoading();
      tomorrow = const DayLoading();
      _load(refresh: false);
    }
  }

  Future<void> _load({required bool refresh}) async {
    final loaded = _loadedFor;
    if (loaded == null) return;
    final (date, zone) = loaded;
    final run = ++_loadRun;
    final results = await Future.wait([
      _prices.day(date, zone, refresh: refresh),
      _prices.day(date.add(const Duration(days: 1)), zone, refresh: refresh),
    ]);
    if (run != _loadRun) return;
    today = _toState(results[0]);
    tomorrow = _toState(results[1]);
    refreshing = false;
    notifyListeners();
  }

  /// Por la tarde, mientras mañana no esté publicado, vuelve a mirar cada 10 minutos.
  void _retryTomorrowIfDue() {
    final time = tz.TZDateTime.now(tz.getLocation('Europe/Madrid'));
    final loaded = _loadedFor;
    if (loaded == null || tomorrow is! DayUnpublished || time.hour < 20 || time.minute % 10 != 0) return;
    final (date, zone) = loaded;
    _prices.day(date.add(const Duration(days: 1)), zone).then((result) {
      if (_loadedFor != loaded) return;
      tomorrow = _toState(result);
      notifyListeners();
    });
  }

  static DayState _toState(DayResult result) => switch (result) {
        DayAvailable(:final prices) => DayReady(prices),
        DayNotPublished() => const DayUnpublished(),
        DayNetworkError() => const DayFailed(network: true),
        DayServerError() => const DayFailed(network: false),
      };

  @override
  void dispose() {
    _timer?.cancel();
    settings.removeListener(_onSettings);
    super.dispose();
  }
}
