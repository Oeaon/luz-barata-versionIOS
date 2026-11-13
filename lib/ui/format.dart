import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/prices.dart';
import '../l10n/app_localizations.dart';

const priceUnit = '€/kWh';

String formatPriceNumber(String locale, double eurPerKwh) => NumberFormat('0.0000', locale).format(eurPerKwh);

String formatPrice(String locale, double eurPerKwh) => '${formatPriceNumber(locale, eurPerKwh)} $priceUnit';

String formatHour(DateTime localTime) => DateFormat('HH:mm').format(localTime);

String formatRange(DateTime localStart, DateTime localEnd) => '${formatHour(localStart)}–${formatHour(localEnd)}';

String hourRange(HourPrice hour) => formatRange(hour.localStart, hour.localEnd);

String windowRange(PriceWindow window) => formatRange(window.first.localStart, window.last.localEnd);

Color levelColor(BuildContext context, PriceLevel level) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return switch (level) {
    PriceLevel.low => dark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
    PriceLevel.medium => dark ? const Color(0xFFFFD54F) : const Color(0xFFE09B00),
    PriceLevel.high => dark ? const Color(0xFFE57373) : const Color(0xFFC62828),
  };
}

String levelLabel(L l, PriceLevel level) => switch (level) {
      PriceLevel.low => l.levelLow,
      PriceLevel.medium => l.levelMedium,
      PriceLevel.high => l.levelHigh,
    };

String applianceName(L l, Appliance appliance) => switch (appliance) {
      Appliance.washingMachine => l.applianceWashingMachine,
      Appliance.dishwasher => l.applianceDishwasher,
      Appliance.dryer => l.applianceDryer,
      Appliance.oven => l.applianceOven,
      Appliance.airConditioning => l.applianceAirConditioning,
      Appliance.electricCar => l.applianceElectricCar,
    };

String zoneName(L l, PvpcZone zone) => switch (zone) {
      PvpcZone.peninsula => l.zonePeninsula,
      PvpcZone.canarias => l.zoneCanarias,
      PvpcZone.baleares => l.zoneBaleares,
      PvpcZone.ceuta => l.zoneCeuta,
      PvpcZone.melilla => l.zoneMelilla,
    };
