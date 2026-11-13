// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class LEs extends L {
  LEs([String locale = 'es']) : super(locale);

  @override
  String get settings => 'Ajustes';

  @override
  String get back => 'Volver';

  @override
  String get today => 'Hoy';

  @override
  String get tomorrow => 'Mañana';

  @override
  String nowLabel(String p1) {
    return 'Ahora ($p1)';
  }

  @override
  String get nowTag => 'Ahora';

  @override
  String get levelLow => 'Barata';

  @override
  String get levelMedium => 'Media';

  @override
  String get levelHigh => 'Cara';

  @override
  String get cheapest => 'Mínimo';

  @override
  String get average => 'Media';

  @override
  String get mostExpensive => 'Máximo';

  @override
  String get bestWindowTitle => 'Mejor hora para lavadora, lavavajillas…';

  @override
  String bestWindowAverage(String p1) {
    return '$p1 de media';
  }

  @override
  String bestWindowSaving(int p1) {
    return 'Un $p1 % más barato que la media del día';
  }

  @override
  String get bestWindowNone =>
      'Hoy ya no quedan tantas horas seguidas. Mira los precios de mañana.';

  @override
  String get allHours => 'Todas las horas';

  @override
  String get chartDescription => 'Gráfico del precio de la luz por horas';

  @override
  String get dataSource =>
      'Precio PVPC con impuestos excluidos. Datos: Red Eléctrica (REData).';

  @override
  String get tomorrowNotPublished =>
      'Los precios de mañana se publican cada día hacia las 20:15.';

  @override
  String get tomorrowWillNotify => 'Te avisaremos en cuanto salgan.';

  @override
  String get notifyMe => 'Avísame cuando salgan';

  @override
  String get errorNetwork =>
      'No hay conexión. Comprueba tu internet e inténtalo de nuevo.';

  @override
  String get errorServer =>
      'No se han podido cargar los precios. Inténtalo dentro de un rato.';

  @override
  String get retry => 'Reintentar';

  @override
  String get zoneTitle => 'Zona';

  @override
  String get zonePeninsula => 'Península';

  @override
  String get zoneCanarias => 'Canarias';

  @override
  String get zoneBaleares => 'Baleares';

  @override
  String get zoneCeuta => 'Ceuta';

  @override
  String get zoneMelilla => 'Melilla';

  @override
  String get notificationsTitle => 'Avisos';

  @override
  String get notifyTomorrow => 'Precios de mañana';

  @override
  String get notifyTomorrowDetail =>
      'Cada tarde, a las 20:30, un aviso para consultar las horas más baratas del día siguiente.';

  @override
  String get channelTomorrowName => 'Precios de mañana';

  @override
  String get channelTomorrowDescription =>
      'Aviso diario cuando se publican los precios del día siguiente';

  @override
  String get notificationTomorrowTitle => 'Ya están los precios de mañana';

  @override
  String get privacyOptions => 'Opciones de privacidad de anuncios';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutText =>
      'Precio voluntario para el pequeño consumidor (PVPC), publicado por Red Eléctrica. Solo es tu precio si tienes una tarifa regulada PVPC; en el mercado libre depende de tu contrato.';

  @override
  String get sourceTitle => 'Fuentes oficiales';

  @override
  String get source1 => 'Precio PVPC en e·sios (Red Eléctrica)';

  @override
  String get source2 => 'API REData de Red Eléctrica';

  @override
  String get aboutDisclaimer =>
      'Luz Barata es una app independiente y no está vinculada a Red Eléctrica, a ningún organismo público ni a ninguna comercializadora.';

  @override
  String version(String p1) {
    return 'Versión $p1';
  }

  @override
  String get applianceTitle => '¿Cuánto me cuesta poner…?';

  @override
  String get applianceLocked =>
      'Calcula lo que cuesta cada electrodoméstico ahora y en la mejor hora del día.';

  @override
  String applianceCostNow(String p1) {
    return 'Si lo pones ahora: $p1';
  }

  @override
  String applianceCostBest(String p1, String p2) {
    return 'En la mejor hora: $p1 ($p2)';
  }

  @override
  String applianceSaving(String p1) {
    return 'Te ahorras $p1 por puesta';
  }

  @override
  String get applianceNote =>
      'Estimación con un consumo típico y el precio PVPC sin impuestos.';

  @override
  String get applianceWashingMachine => 'Lavadora';

  @override
  String get applianceDishwasher => 'Lavavajillas';

  @override
  String get applianceDryer => 'Secadora';

  @override
  String get applianceOven => 'Horno';

  @override
  String get applianceAirConditioning => 'Aire acondicionado';

  @override
  String get applianceElectricCar => 'Coche eléctrico';

  @override
  String get premiumFeatureAppliances =>
      'Calculadora de coste por electrodoméstico';

  @override
  String get premiumSettingsText =>
      'Quita los anuncios y desbloquea la calculadora de electrodomésticos.';

  @override
  String get removeAds => 'Quitar anuncios';

  @override
  String hoursShort(int p1) {
    String _temp0 = intl.Intl.pluralLogic(
      p1,
      locale: localeName,
      other: '$p1 h',
      one: '$p1 h',
    );
    return '$_temp0';
  }

  @override
  String get premiumTitle => 'Premium';

  @override
  String get premiumBack => 'Volver';

  @override
  String get premiumHeadline => 'Pásate a Premium';

  @override
  String get premiumActive => 'Ya eres Premium. ¡Gracias por tu apoyo!';

  @override
  String get premiumBenefitNoAds => 'Sin anuncios';

  @override
  String premiumMonthly(String p1) {
    return '$p1 al mes';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, pago único para siempre';
  }

  @override
  String get premiumLoading => 'Cargando precio…';

  @override
  String get premiumStoreUnavailable =>
      'No se puede conectar con el App Store. Inténtalo más tarde.';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumLegal =>
      'La suscripción se renueva cada mes y puedes cancelarla cuando quieras en el App Store.';

  @override
  String get lockedWatchAd => 'Ver un anuncio y desbloquear 24 h';

  @override
  String get lockedGoPremium => 'Hazte Premium';

  @override
  String get rewardedUnavailable =>
      'No hay ningún anuncio disponible ahora mismo. Prueba dentro de un rato.';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get termsOfUse => 'Términos de uso';

  @override
  String get notificationTomorrowReminder =>
      'Toca para ver la hora más barata y la más cara.';
}
