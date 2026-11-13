import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/prices.dart';

/// Zona del PVPC, franja buscada, aparato de la calculadora y aviso de mañana.
class SettingsStore extends ChangeNotifier {
  SettingsStore._(this._prefs);

  static const minWindow = 1;
  static const maxWindow = 4;

  final SharedPreferences _prefs;

  static Future<SettingsStore> open() async => SettingsStore._(await SharedPreferences.getInstance());

  PvpcZone get zone => PvpcZone.values.firstWhere((z) => z.name == _prefs.getString('zone'), orElse: () => PvpcZone.peninsula);

  /// Duración de la franja buscada (lavadora, lavavajillas…), de 1 a 4 horas.
  int get windowHours => (_prefs.getInt('window_hours') ?? 2).clamp(minWindow, maxWindow);

  bool get notifyTomorrow => _prefs.getBool('notify_tomorrow') ?? false;

  Appliance get appliance =>
      Appliance.values.firstWhere((a) => a.name == _prefs.getString('appliance'), orElse: () => Appliance.washingMachine);

  Future<void> setZone(PvpcZone value) => _set(() => _prefs.setString('zone', value.name));

  Future<void> setWindowHours(int hours) => _set(() => _prefs.setInt('window_hours', hours.clamp(minWindow, maxWindow)));

  Future<void> setNotifyTomorrow(bool enabled) => _set(() => _prefs.setBool('notify_tomorrow', enabled));

  Future<void> setAppliance(Appliance value) => _set(() => _prefs.setString('appliance', value.name));

  Future<void> _set(Future<bool> Function() write) async {
    await write();
    notifyListeners();
  }
}
