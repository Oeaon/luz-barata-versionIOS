import 'package:flutter_test/flutter_test.dart';
import 'package:luz_barata/core/prices.dart';

// Los mismos casos que los tests de la versión Android (core/src/test).
const _summer = Duration(hours: 2);

HourPrice hourAt(int hour, double eurPerKwh) => HourPrice(DateTime.utc(2026, 10, 13, hour).subtract(_summer), _summer, eurPerKwh);

DayPrices dayOf(List<double> prices) => DayPrices(DateTime.utc(2026, 10, 13), [for (var h = 0; h < prices.length; h++) hourAt(h, prices[h])]);

/// Respuesta con la forma de REData: PVPC más otra serie que se debe ignorar.
String redataResponse(List<(String, double)> values) {
  final items = values.map((v) => '{"value":${v.$2},"percentage":0.5,"datetime":"${v.$1}"}').join(',');
  return '{"data":{"type":"Precios mercado peninsular en tiempo real"},'
      '"included":['
      '{"type":"Precio mercado spot (€/MWh)","id":"600","attributes":{"values":['
      '{"value":999.0,"percentage":0.5,"datetime":"2026-10-13T00:00:00.000+02:00"}]}},'
      '{"type":"PVPC (€/MWh)","id":"1001","attributes":{"title":"PVPC (€/MWh)","values":[$items]}}'
      ']}';
}

final day = dayOf([
  0.20, 0.10, 0.08, 0.07, 0.09, 0.12, 0.15, 0.18, //
  0.22, 0.19, 0.14, 0.11, 0.10, 0.09, 0.10, 0.13,
  0.17, 0.21, 0.26, 0.28, 0.27, 0.24, 0.20, 0.16,
]);

void main() {
  group('precios del día', () {
    test('calcula mínimo, máximo y media', () {
      expect(day.cheapest.localStart.hour, 3);
      expect(day.mostExpensive.localStart.hour, 19);
      expect(day.average, closeTo(day.hours.map((h) => h.eurPerKwh).reduce((a, b) => a + b) / 24, 1e-12));
      expect(day.isComplete, isTrue);
    });

    test('reparte las horas en tercios', () {
      final high = day.hours.where((h) => day.levelOf(h) == PriceLevel.high).length;
      final low = day.hours.where((h) => day.levelOf(h) == PriceLevel.low).length;

      expect(day.levelOf(day.cheapest), PriceLevel.low);
      expect(day.levelOf(day.mostExpensive), PriceLevel.high);
      expect(high, 8);
      expect(low, greaterThanOrEqualTo(8));
    });

    test('encuentra la franja más barata de horas seguidas', () {
      final window = day.cheapestWindow(3)!;

      expect(window.first.localStart.hour, 2);
      expect(window.last.localEnd.hour, 5);
      expect(window.average, closeTo((0.08 + 0.07 + 0.09) / 3, 1e-12));
    });

    test('sin franjas pasadas cuando se pide a partir de ahora', () {
      final tenAndHalf = day.hours[10].startUtc.add(const Duration(minutes: 30));

      expect(day.cheapestWindow(2, notBefore: tenAndHalf)!.first.localStart.hour, 12);
    });

    test('la hora en curso cuenta como inicio de franja', () {
      final threeAndHalf = day.hours[3].startUtc.add(const Duration(minutes: 30));

      expect(day.cheapestWindow(1, notBefore: threeAndHalf)!.first.localStart.hour, 3);
    });

    test('no hay franja si es más larga que lo que queda del día', () {
      expect(day.cheapestWindow(2, notBefore: day.hours.last.startUtc), isNull);
    });

    test('localiza la hora actual', () {
      expect(day.hourAt(day.hours[14].startUtc.add(const Duration(minutes: 59)))!.localStart.hour, 14);
      expect(day.hourAt(day.hours.last.endUtc), isNull);
    });

    test('un día con pocas horas no está completo', () {
      expect(dayOf([0.1, 0.2]).isComplete, isFalse);
    });
  });

  group('lectura de REData', () {
    test('lee la serie PVPC en euros por kWh e ignora las demás', () {
      final hours = PvpcParser.parse(redataResponse([
        ('2026-10-13T00:00:00.000+02:00', 120.0),
        ('2026-10-13T01:00:00.000+02:00', 95.5),
      ]));

      expect(hours, hasLength(2));
      expect(hours[0].eurPerKwh, closeTo(0.120, 1e-9));
      expect(hours[1].eurPerKwh, closeTo(0.0955, 1e-9));
      expect(hours[1].localStart.hour, 1);
    });

    test('promedia los cuartos de hora de cada hora', () {
      final hours = PvpcParser.parse(redataResponse([
        ('2026-10-13T10:00:00.000+02:00', 100.0),
        ('2026-10-13T10:15:00.000+02:00', 110.0),
        ('2026-10-13T10:30:00.000+02:00', 120.0),
        ('2026-10-13T10:45:00.000+02:00', 130.0),
      ]));

      expect(hours, hasLength(1));
      expect(hours.single.eurPerKwh, closeTo(0.115, 1e-9));
    });

    test('el día del cambio de hora de octubre tiene 25 horas', () {
      final values = [
        for (var h = 0; h <= 2; h++) ('2026-10-25T${h.toString().padLeft(2, '0')}:00:00.000+02:00', 100.0),
        for (var h = 2; h <= 23; h++) ('2026-10-25T${h.toString().padLeft(2, '0')}:00:00.000+01:00', 100.0),
      ];

      final hours = PvpcParser.parse(redataResponse(values));

      expect(hours, hasLength(25));
      for (var i = 1; i < hours.length; i++) {
        expect(hours[i - 1].endUtc, hours[i].startUtc);
      }
    });

    test('una respuesta de error sin serie da lista vacía', () {
      expect(PvpcParser.parse('{"errors":[{"code":502,"title":"Error","detail":"Sin datos"}]}'), isEmpty);
    });

    test('un cuerpo que no es JSON lanza PvpcFormatException', () {
      expect(() => PvpcParser.parse('<html>Bad gateway</html>'), throwsA(isA<PvpcFormatException>()));
    });
  });

  group('electrodomésticos', () {
    test('compara ponerla ahora con la mejor franja que queda', () {
      final sevenPm = day.hours[19].startUtc.add(const Duration(minutes: 10));

      final estimate = ApplianceCost.estimate(day, Appliance.washingMachine, sevenPm)!;

      expect(estimate.costNow, closeTo(1.0 * (0.28 + 0.27) / 2, 1e-9));
      expect(estimate.bestWindow.first.localStart.hour, 22);
      expect(estimate.bestCost, closeTo(1.0 * (0.20 + 0.16) / 2, 1e-9));
      expect(estimate.saving, greaterThan(0));
    });

    test('sin hora actual busca en todo el día y no hay coste ahora', () {
      final estimate = ApplianceCost.estimate(day, Appliance.oven, null)!;

      expect(estimate.costNow, isNull);
      expect(estimate.bestWindow.first.localStart.hour, 3);
      expect(estimate.saving, 0);
    });

    test('el coche necesita cuatro horas seguidas', () {
      final estimate = ApplianceCost.estimate(day, Appliance.electricCar, null)!;

      expect(estimate.bestWindow.hours, hasLength(4));
      expect(estimate.bestWindow.first.localStart.hour, 1);
    });

    test('si no caben las horas que quedan no hay estimación', () {
      expect(ApplianceCost.estimate(day, Appliance.electricCar, day.hours.last.startUtc), isNull);
    });
  });
}
