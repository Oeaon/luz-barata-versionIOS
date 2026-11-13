import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/timezone.dart' as tz;

import '../core/prices.dart';

sealed class DayResult {
  const DayResult();
}

class DayAvailable extends DayResult {
  const DayAvailable(this.prices);

  final DayPrices prices;
}

/// Mañana antes de la publicación (hacia las 20:15).
class DayNotPublished extends DayResult {
  const DayNotPublished();
}

class DayNetworkError extends DayResult {
  const DayNetworkError();
}

class DayServerError extends DayResult {
  const DayServerError();
}

/// El PVPC se publica por día oficial de la península.
DateTime spainToday() {
  final now = tz.TZDateTime.now(tz.getLocation('Europe/Madrid'));
  return DateTime.utc(now.year, now.month, now.day);
}

String _dayKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

class PvpcRepository {
  PvpcRepository({http.Client? client}) : _client = client ?? http.Client();

  static const _keepDays = 7;

  final http.Client _client;

  Future<DayResult> day(DateTime date, PvpcZone zone, {bool refresh = false}) async {
    if (!refresh) {
      final cached = await _cachedDay(date, zone);
      if (cached != null) return DayAvailable(cached);
    }
    final http.Response response;
    try {
      response = await _client
          .get(Uri.parse(RedataUrls.pvpc(date, zone)), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 30));
    } on Exception {
      final cached = await _cachedDay(date, zone);
      return cached != null ? DayAvailable(cached) : const DayNetworkError();
    }
    final isFuture = date.isAfter(spainToday());
    if (response.statusCode < 200 || response.statusCode > 299) {
      return isFuture ? const DayNotPublished() : const DayServerError();
    }
    final List<HourPrice> hours;
    try {
      hours = PvpcParser.parse(response.body);
    } on PvpcFormatException {
      return const DayServerError();
    }
    if (hours.isEmpty) return isFuture ? const DayNotPublished() : const DayServerError();

    final prices = DayPrices(date, hours);
    // El precio de un día completo ya no cambia, así que se guarda sin caducidad.
    if (prices.isComplete) await _write(date, zone, response.body);
    return DayAvailable(prices);
  }

  Future<DayPrices?> _cachedDay(DateTime date, PvpcZone zone) async {
    try {
      final file = await _file(date, zone);
      if (!await file.exists()) return null;
      final hours = PvpcParser.parse(await file.readAsString());
      return hours.isEmpty ? null : DayPrices(date, hours);
    } on Exception {
      return null;
    }
  }

  Future<void> _write(DateTime date, PvpcZone zone, String body) async {
    try {
      final file = await _file(date, zone);
      await file.parent.create(recursive: true);
      await file.writeAsString(body);
      final limit = _dayKey(date.subtract(const Duration(days: _keepDays)));
      await for (final old in file.parent.list()) {
        final name = old.uri.pathSegments.last;
        final day = name.split('_').last.replaceAll('.json', '');
        if (day.compareTo(limit) < 0) await old.delete();
      }
    } on IOException {
      // Sin caché la app sigue funcionando; solo vuelve a descargar.
    }
  }

  Future<File> _file(DateTime date, PvpcZone zone) async =>
      File('${(await getApplicationSupportDirectory()).path}/prices/${zone.name}_${_dayKey(date)}.json');
}
