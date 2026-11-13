// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class LCa extends L {
  LCa([String locale = 'ca']) : super(locale);

  @override
  String get settings => 'Configuració';

  @override
  String get back => 'Tornar';

  @override
  String get today => 'Avui';

  @override
  String get tomorrow => 'Demà';

  @override
  String nowLabel(String p1) {
    return 'Ara ($p1)';
  }

  @override
  String get nowTag => 'Ara';

  @override
  String get levelLow => 'Barata';

  @override
  String get levelMedium => 'Mitjana';

  @override
  String get levelHigh => 'Cara';

  @override
  String get cheapest => 'Mínim';

  @override
  String get average => 'Mitjana';

  @override
  String get mostExpensive => 'Màxim';

  @override
  String get bestWindowTitle =>
      'Millor hora per a la rentadora, el rentaplats…';

  @override
  String bestWindowAverage(String p1) {
    return '$p1 de mitjana';
  }

  @override
  String bestWindowSaving(int p1) {
    return 'Un $p1 % més barat que la mitjana del dia';
  }

  @override
  String get bestWindowNone =>
      'Avui ja no queden tantes hores seguides. Mira els preus de demà.';

  @override
  String get allHours => 'Totes les hores';

  @override
  String get chartDescription => 'Gràfic del preu de la llum per hores';

  @override
  String get dataSource =>
      'Preu PVPC sense impostos. Dades: Red Eléctrica (REData).';

  @override
  String get tomorrowNotPublished =>
      'Els preus de demà es publiquen cada dia cap a les 20:15.';

  @override
  String get tomorrowWillNotify => 'T\'avisarem tan bon punt surtin.';

  @override
  String get notifyMe => 'Avisa\'m quan surtin';

  @override
  String get errorNetwork =>
      'No hi ha connexió. Comprova la connexió a internet i torna-ho a provar.';

  @override
  String get errorServer =>
      'No s\'han pogut carregar els preus. Torna-ho a provar d\'aquí a una estona.';

  @override
  String get retry => 'Torna-ho a provar';

  @override
  String get zoneTitle => 'Zona';

  @override
  String get zonePeninsula => 'Península';

  @override
  String get zoneCanarias => 'Canàries';

  @override
  String get zoneBaleares => 'Illes Balears';

  @override
  String get zoneCeuta => 'Ceuta';

  @override
  String get zoneMelilla => 'Melilla';

  @override
  String get notificationsTitle => 'Avisos';

  @override
  String get notifyTomorrow => 'Preus de demà';

  @override
  String get notifyTomorrowDetail =>
      'Cada tarda, a les 20:30, un avís per consultar les hores més barates de l\'endemà.';

  @override
  String get channelTomorrowName => 'Preus de demà';

  @override
  String get channelTomorrowDescription =>
      'Avís diari quan es publiquen els preus de l\'endemà';

  @override
  String get notificationTomorrowTitle => 'Ja hi ha els preus de demà';

  @override
  String get privacyOptions => 'Opcions de privadesa dels anuncis';

  @override
  String get aboutTitle => 'Quant a';

  @override
  String get aboutText =>
      'Preu voluntari per al petit consumidor (PVPC), publicat per Red Eléctrica. Només és el teu preu si tens una tarifa regulada PVPC; al mercat lliure depèn del teu contracte.';

  @override
  String get sourceTitle => 'Fonts oficials';

  @override
  String get source1 => 'Preu PVPC a e·sios (Red Eléctrica)';

  @override
  String get source2 => 'API REData de Red Eléctrica';

  @override
  String get aboutDisclaimer =>
      'Luz Barata és una app independent i no està vinculada a Red Eléctrica, a cap organisme públic ni a cap comercialitzadora.';

  @override
  String version(String p1) {
    return 'Versió $p1';
  }

  @override
  String get applianceTitle => 'Quant em costa posar…?';

  @override
  String get applianceLocked =>
      'Calcula el que costa cada electrodomèstic ara i a la millor hora del dia.';

  @override
  String applianceCostNow(String p1) {
    return 'Si el poses ara: $p1';
  }

  @override
  String applianceCostBest(String p1, String p2) {
    return 'A la millor hora: $p1 ($p2)';
  }

  @override
  String applianceSaving(String p1) {
    return 'T\'estalvies $p1 cada vegada';
  }

  @override
  String get applianceNote =>
      'Estimació amb un consum típic i el preu PVPC sense impostos.';

  @override
  String get applianceWashingMachine => 'Rentadora';

  @override
  String get applianceDishwasher => 'Rentaplats';

  @override
  String get applianceDryer => 'Assecadora';

  @override
  String get applianceOven => 'Forn';

  @override
  String get applianceAirConditioning => 'Aire condicionat';

  @override
  String get applianceElectricCar => 'Cotxe elèctric';

  @override
  String get premiumFeatureAppliances =>
      'Calculadora del cost per electrodomèstic';

  @override
  String get premiumSettingsText =>
      'Treu els anuncis i desbloqueja la calculadora d\'electrodomèstics.';

  @override
  String get removeAds => 'Treure els anuncis';

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
  String get premiumBack => 'Tornar';

  @override
  String get premiumHeadline => 'Passa\'t a Premium';

  @override
  String get premiumActive => 'Ja ets Premium. Gràcies pel teu suport!';

  @override
  String get premiumBenefitNoAds => 'Sense anuncis';

  @override
  String premiumMonthly(String p1) {
    return '$p1 al mes';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, pagament únic per sempre';
  }

  @override
  String get premiumLoading => 'Carregant el preu…';

  @override
  String get premiumStoreUnavailable =>
      'No es pot connectar amb l\'App Store. Torna-ho a provar més tard.';

  @override
  String get premiumRestore => 'Restaura les compres';

  @override
  String get premiumLegal =>
      'La subscripció es renova cada mes i la pots cancel·lar quan vulguis a l\'App Store.';

  @override
  String get lockedWatchAd => 'Mira un anunci i desbloqueja-ho 24 h';

  @override
  String get lockedGoPremium => 'Fes-te Premium';

  @override
  String get rewardedUnavailable =>
      'Ara mateix no hi ha cap anunci disponible. Prova-ho d\'aquí a una estona.';

  @override
  String get privacyPolicy => 'Política de privadesa';

  @override
  String get termsOfUse => 'Termes d\'ús';

  @override
  String get notificationTomorrowReminder =>
      'Toca per veure l\'hora més barata i la més cara.';
}
