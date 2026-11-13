// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Galician (`gl`).
class LGl extends L {
  LGl([String locale = 'gl']) : super(locale);

  @override
  String get settings => 'Axustes';

  @override
  String get back => 'Volver';

  @override
  String get today => 'Hoxe';

  @override
  String get tomorrow => 'Mañá';

  @override
  String nowLabel(String p1) {
    return 'Agora ($p1)';
  }

  @override
  String get nowTag => 'Agora';

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
  String get bestWindowTitle => 'Mellor hora para a lavadora, o lavalouzas…';

  @override
  String bestWindowAverage(String p1) {
    return '$p1 de media';
  }

  @override
  String bestWindowSaving(int p1) {
    return 'Un $p1 % máis barato que a media do día';
  }

  @override
  String get bestWindowNone =>
      'Hoxe xa non quedan tantas horas seguidas. Mira os prezos de mañá.';

  @override
  String get allHours => 'Todas as horas';

  @override
  String get chartDescription => 'Gráfico do prezo da luz por horas';

  @override
  String get dataSource =>
      'Prezo PVPC sen impostos. Datos: Red Eléctrica (REData).';

  @override
  String get tomorrowNotPublished =>
      'Os prezos de mañá publícanse cada día arredor das 20:15.';

  @override
  String get tomorrowWillNotify => 'Avisarémoste en canto saian.';

  @override
  String get notifyMe => 'Avísame cando saian';

  @override
  String get errorNetwork =>
      'Non hai conexión. Comproba a túa conexión e téntao de novo.';

  @override
  String get errorServer =>
      'Non se puideron cargar os prezos. Téntao dentro dun anaco.';

  @override
  String get retry => 'Tentar de novo';

  @override
  String get zoneTitle => 'Zona';

  @override
  String get zonePeninsula => 'Península';

  @override
  String get zoneCanarias => 'Canarias';

  @override
  String get zoneBaleares => 'Illas Baleares';

  @override
  String get zoneCeuta => 'Ceuta';

  @override
  String get zoneMelilla => 'Melilla';

  @override
  String get notificationsTitle => 'Avisos';

  @override
  String get notifyTomorrow => 'Prezos de mañá';

  @override
  String get notifyTomorrowDetail =>
      'Cada tarde, ás 20:30, un aviso para consultar as horas máis baratas do día seguinte.';

  @override
  String get channelTomorrowName => 'Prezos de mañá';

  @override
  String get channelTomorrowDescription =>
      'Aviso diario cando se publican os prezos do día seguinte';

  @override
  String get notificationTomorrowTitle => 'Xa están os prezos de mañá';

  @override
  String get privacyOptions => 'Opcións de privacidade dos anuncios';

  @override
  String get aboutTitle => 'Acerca de';

  @override
  String get aboutText =>
      'Prezo voluntario para o pequeno consumidor (PVPC), publicado por Red Eléctrica. Só é o teu prezo se tes unha tarifa regulada PVPC; no mercado libre depende do teu contrato.';

  @override
  String get sourceTitle => 'Fontes oficiais';

  @override
  String get source1 => 'Prezo PVPC en e·sios (Red Eléctrica)';

  @override
  String get source2 => 'API REData de Red Eléctrica';

  @override
  String get aboutDisclaimer =>
      'Luz Barata é unha app independente e non está vinculada a Red Eléctrica, a ningún organismo público nin a ningunha comercializadora.';

  @override
  String version(String p1) {
    return 'Versión $p1';
  }

  @override
  String get applianceTitle => 'Canto me custa poñer…?';

  @override
  String get applianceLocked =>
      'Calcula o que custa cada electrodoméstico agora e na mellor hora do día.';

  @override
  String applianceCostNow(String p1) {
    return 'Se o pos agora: $p1';
  }

  @override
  String applianceCostBest(String p1, String p2) {
    return 'Na mellor hora: $p1 ($p2)';
  }

  @override
  String applianceSaving(String p1) {
    return 'Aforras $p1 cada vez';
  }

  @override
  String get applianceNote =>
      'Estimación cun consumo típico e o prezo PVPC sen impostos.';

  @override
  String get applianceWashingMachine => 'Lavadora';

  @override
  String get applianceDishwasher => 'Lavalouzas';

  @override
  String get applianceDryer => 'Secadora';

  @override
  String get applianceOven => 'Forno';

  @override
  String get applianceAirConditioning => 'Aire acondicionado';

  @override
  String get applianceElectricCar => 'Coche eléctrico';

  @override
  String get premiumFeatureAppliances =>
      'Calculadora do custo por electrodoméstico';

  @override
  String get premiumSettingsText =>
      'Quita os anuncios e desbloquea a calculadora de electrodomésticos.';

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
  String get premiumActive => 'Xa es Premium. Grazas polo teu apoio!';

  @override
  String get premiumBenefitNoAds => 'Sen anuncios';

  @override
  String premiumMonthly(String p1) {
    return '$p1 ao mes';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, pagamento único para sempre';
  }

  @override
  String get premiumLoading => 'Cargando o prezo…';

  @override
  String get premiumStoreUnavailable =>
      'Non se pode conectar coa App Store. Téntao máis tarde.';

  @override
  String get premiumRestore => 'Restaurar compras';

  @override
  String get premiumLegal =>
      'A subscrición renóvase cada mes e podes cancelala cando queiras na App Store.';

  @override
  String get lockedWatchAd => 'Ver un anuncio e desbloquear 24 h';

  @override
  String get lockedGoPremium => 'Faite Premium';

  @override
  String get rewardedUnavailable =>
      'Agora mesmo non hai ningún anuncio dispoñible. Proba dentro dun anaco.';

  @override
  String get privacyPolicy => 'Política de privacidade';

  @override
  String get termsOfUse => 'Termos de uso';

  @override
  String get notificationTomorrowReminder =>
      'Toca para ver a hora máis barata e a máis cara.';
}
