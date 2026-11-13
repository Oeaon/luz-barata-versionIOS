import 'dart:convert';

/// Sistemas eléctricos con PVPC propio, con sus identificadores de REData.
enum PvpcZone {
  peninsula('peninsular', 8741),
  canarias('canarias', 8742),
  baleares('baleares', 8743),
  ceuta('ceuta', 8744),
  melilla('melilla', 8745);

  const PvpcZone(this.geoLimit, this.geoId);

  final String geoLimit;
  final int geoId;
}

/// Precio de una hora en €/kWh. Guarda el instante y el desfase horario que da REData,
/// para mostrar la hora local de cada sistema (Canarias va una hora por detrás).
class HourPrice {
  const HourPrice(this.startUtc, this.offset, this.eurPerKwh);

  final DateTime startUtc;
  final Duration offset;
  final double eurPerKwh;

  DateTime get endUtc => startUtc.add(const Duration(hours: 1));

  /// Hora de reloj de la zona (campos en UTC para no mezclarla con la zona del móvil).
  DateTime get localStart => startUtc.add(offset);

  DateTime get localEnd => endUtc.add(offset);

  bool contains(DateTime instant) => !instant.isBefore(startUtc) && instant.isBefore(endUtc);
}

enum PriceLevel { low, medium, high }

/// Horas consecutivas, p. ej. la mejor franja para poner la lavadora.
class PriceWindow {
  PriceWindow(this.hours) : assert(hours.isNotEmpty);

  final List<HourPrice> hours;

  HourPrice get first => hours.first;

  HourPrice get last => hours.last;

  double get average => hours.map((h) => h.eurPerKwh).reduce((a, b) => a + b) / hours.length;
}

/// Precios de un día (23, 24 o 25 horas según el cambio de hora).
class DayPrices {
  DayPrices(this.date, List<HourPrice> hours) : hours = [...hours]..sort((a, b) => a.startUtc.compareTo(b.startUtc)) {
    if (hours.isEmpty) throw ArgumentError('Un día sin precios no es válido');
    final sorted = this.hours.map((h) => h.eurPerKwh).toList()..sort();
    _lowLimit = sorted[(sorted.length ~/ 3 - 1).clamp(0, sorted.length - 1)];
    _highLimit = sorted[(sorted.length - sorted.length ~/ 3).clamp(0, sorted.length - 1)];
  }

  final DateTime date;
  final List<HourPrice> hours;
  late final double _lowLimit;
  late final double _highLimit;

  HourPrice get cheapest => hours.reduce((a, b) => b.eurPerKwh < a.eurPerKwh ? b : a);

  HourPrice get mostExpensive => hours.reduce((a, b) => b.eurPerKwh > a.eurPerKwh ? b : a);

  double get average => hours.map((h) => h.eurPerKwh).reduce((a, b) => a + b) / hours.length;

  /// Un día entero tiene al menos 23 horas; si llegan menos, aún no está completo.
  bool get isComplete => hours.length >= 23;

  /// Tercio del día: el tercio de horas más barato es low y el más caro high.
  PriceLevel levelOf(HourPrice hour) {
    if (hour.eurPerKwh <= _lowLimit) return PriceLevel.low;
    if (hour.eurPerKwh >= _highLimit) return PriceLevel.high;
    return PriceLevel.medium;
  }

  HourPrice? hourAt(DateTime instant) {
    for (final h in hours) {
      if (h.contains(instant)) return h;
    }
    return null;
  }

  /// Franja de [length] horas seguidas con la media más baja.
  /// Con [notBefore] solo cuentan las franjas cuya primera hora no ha terminado (la hora en curso vale).
  PriceWindow? cheapestWindow(int length, {DateTime? notBefore}) {
    assert(length >= 1);
    PriceWindow? best;
    for (var i = 0; i + length <= hours.length; i++) {
      if (notBefore != null && !hours[i].endUtc.isAfter(notBefore)) continue;
      final window = PriceWindow(hours.sublist(i, i + length));
      if (best == null || window.average < best.average) best = window;
    }
    return best;
  }
}

class PvpcFormatException implements Exception {
  const PvpcFormatException(this.message);

  final String message;

  @override
  String toString() => 'PvpcFormatException: $message';
}

/// Lee la respuesta de REData y devuelve el PVPC por horas en €/kWh.
/// Si llegan cuartos de hora se promedian por hora. Una respuesta sin
/// serie PVPC (p. ej. el día de mañana antes de publicarse) da lista vacía.
class PvpcParser {
  PvpcParser._();

  static const _pvpcId = '1001';

  static List<HourPrice> parse(String body) {
    final Object? root;
    try {
      root = jsonDecode(body);
    } on FormatException {
      throw const PvpcFormatException('Respuesta no es JSON');
    }
    if (root is! Map<String, dynamic>) throw const PvpcFormatException('Respuesta no es un objeto JSON');
    final included = root['included'];
    if (included is! List) return [];
    final pvpc = included.whereType<Map<String, dynamic>>().where(_isPvpc).firstOrNull;
    final values = (pvpc?['attributes'] as Map<String, dynamic>?)?['values'];
    if (values is! List) return [];

    final byHour = <String, (DateTime, Duration, List<double>)>{};
    for (final item in values.whereType<Map<String, dynamic>>()) {
      final datetime = item['datetime'];
      final value = item['value'];
      if (datetime is! String || value is! num) continue;
      final (utc, offset) = _parseWithOffset(datetime);
      // La hora se agrupa en la hora local de la zona, como hace REData.
      final local = utc.add(offset);
      final hourUtc = DateTime.utc(local.year, local.month, local.day, local.hour).subtract(offset);
      final key = '${hourUtc.toIso8601String()}$offset';
      byHour.putIfAbsent(key, () => (hourUtc, offset, <double>[])).$3.add(value.toDouble());
    }
    return [
      for (final (start, offset, mwh) in byHour.values) HourPrice(start, offset, mwh.reduce((a, b) => a + b) / mwh.length / 1000),
    ]..sort((a, b) => a.startUtc.compareTo(b.startUtc));
  }

  static bool _isPvpc(Map<String, dynamic> json) {
    final type = json['type'];
    return json['id'] == _pvpcId || (type is String && type.startsWith('PVPC'));
  }

  static final _offsetPattern = RegExp(r'([+-])(\d{2}):?(\d{2})$');

  /// "2026-10-13T00:00:00.000+02:00" → instante en UTC y desfase de +2 h.
  static (DateTime, Duration) _parseWithOffset(String text) {
    final DateTime utc;
    try {
      utc = DateTime.parse(text).toUtc();
    } on FormatException {
      throw const PvpcFormatException('Fecha con formato inesperado');
    }
    final m = _offsetPattern.firstMatch(text);
    if (m == null) return (utc, Duration.zero);
    final minutes = int.parse(m.group(2)!) * 60 + int.parse(m.group(3)!);
    return (utc, Duration(minutes: m.group(1) == '-' ? -minutes : minutes));
  }
}

/// URLs de la API pública de Red Eléctrica (REData), sin clave.
class RedataUrls {
  RedataUrls._();

  static const _prices = 'https://apidatos.ree.es/es/datos/mercados/precios-mercados-tiempo-real';

  static String pvpc(DateTime date, PvpcZone zone) {
    final d = '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return '$_prices?start_date=${d}T00:00&end_date=${d}T23:59'
        '&time_trunc=hour&geo_trunc=electric_system'
        '&geo_limit=${zone.geoLimit}&geo_ids=${zone.geoId}';
  }
}

/// Consumo típico de una puesta, para estimar cuánto cuesta según la hora.
enum Appliance {
  washingMachine(1.0, 2.0),
  dishwasher(1.1, 2.0),
  dryer(2.5, 1.5),
  oven(1.2, 1.0),
  airConditioning(1.5, 1.0),
  electricCar(7.4 * 4, 4.0);

  const Appliance(this.kwhPerUse, this.hours);

  final double kwhPerUse;
  final double hours;
}

class ApplianceEstimate {
  const ApplianceEstimate(this.costNow, this.bestWindow, this.bestCost);

  /// Coste empezando en la hora actual; null si ya no cabe hoy.
  final double? costNow;
  final PriceWindow bestWindow;
  final double bestCost;

  double get saving => costNow == null ? 0 : costNow! - bestCost;
}

class ApplianceCost {
  ApplianceCost._();

  /// Compara poner el aparato ahora con la franja más barata que queda (o del día entero si [now] es null).
  /// El consumo se reparte por igual entre las horas que dura.
  static ApplianceEstimate? estimate(DayPrices prices, Appliance appliance, DateTime? now) {
    final length = appliance.hours.ceil() < 1 ? 1 : appliance.hours.ceil();
    final best = prices.cheapestWindow(length, notBefore: now);
    if (best == null) return null;
    PriceWindow? nowWindow;
    if (now != null) {
      final start = prices.hours.indexWhere((h) => h.contains(now));
      if (start >= 0 && start + length <= prices.hours.length) nowWindow = PriceWindow(prices.hours.sublist(start, start + length));
    }
    return ApplianceEstimate(
      nowWindow == null ? null : appliance.kwhPerUse * nowWindow.average,
      best,
      appliance.kwhPerUse * best.average,
    );
  }
}
