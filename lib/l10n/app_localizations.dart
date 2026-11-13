import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_gl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
    Locale('gl'),
  ];

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get back;

  /// No description provided for @today.
  ///
  /// In es, this message translates to:
  /// **'Hoy'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In es, this message translates to:
  /// **'Mañana'**
  String get tomorrow;

  /// No description provided for @nowLabel.
  ///
  /// In es, this message translates to:
  /// **'Ahora ({p1})'**
  String nowLabel(String p1);

  /// No description provided for @nowTag.
  ///
  /// In es, this message translates to:
  /// **'Ahora'**
  String get nowTag;

  /// No description provided for @levelLow.
  ///
  /// In es, this message translates to:
  /// **'Barata'**
  String get levelLow;

  /// No description provided for @levelMedium.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get levelMedium;

  /// No description provided for @levelHigh.
  ///
  /// In es, this message translates to:
  /// **'Cara'**
  String get levelHigh;

  /// No description provided for @cheapest.
  ///
  /// In es, this message translates to:
  /// **'Mínimo'**
  String get cheapest;

  /// No description provided for @average.
  ///
  /// In es, this message translates to:
  /// **'Media'**
  String get average;

  /// No description provided for @mostExpensive.
  ///
  /// In es, this message translates to:
  /// **'Máximo'**
  String get mostExpensive;

  /// No description provided for @bestWindowTitle.
  ///
  /// In es, this message translates to:
  /// **'Mejor hora para lavadora, lavavajillas…'**
  String get bestWindowTitle;

  /// No description provided for @bestWindowAverage.
  ///
  /// In es, this message translates to:
  /// **'{p1} de media'**
  String bestWindowAverage(String p1);

  /// No description provided for @bestWindowSaving.
  ///
  /// In es, this message translates to:
  /// **'Un {p1} % más barato que la media del día'**
  String bestWindowSaving(int p1);

  /// No description provided for @bestWindowNone.
  ///
  /// In es, this message translates to:
  /// **'Hoy ya no quedan tantas horas seguidas. Mira los precios de mañana.'**
  String get bestWindowNone;

  /// No description provided for @allHours.
  ///
  /// In es, this message translates to:
  /// **'Todas las horas'**
  String get allHours;

  /// No description provided for @chartDescription.
  ///
  /// In es, this message translates to:
  /// **'Gráfico del precio de la luz por horas'**
  String get chartDescription;

  /// No description provided for @dataSource.
  ///
  /// In es, this message translates to:
  /// **'Precio PVPC con impuestos excluidos. Datos: Red Eléctrica (REData).'**
  String get dataSource;

  /// No description provided for @tomorrowNotPublished.
  ///
  /// In es, this message translates to:
  /// **'Los precios de mañana se publican cada día hacia las 20:15.'**
  String get tomorrowNotPublished;

  /// No description provided for @tomorrowWillNotify.
  ///
  /// In es, this message translates to:
  /// **'Te avisaremos en cuanto salgan.'**
  String get tomorrowWillNotify;

  /// No description provided for @notifyMe.
  ///
  /// In es, this message translates to:
  /// **'Avísame cuando salgan'**
  String get notifyMe;

  /// No description provided for @errorNetwork.
  ///
  /// In es, this message translates to:
  /// **'No hay conexión. Comprueba tu internet e inténtalo de nuevo.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In es, this message translates to:
  /// **'No se han podido cargar los precios. Inténtalo dentro de un rato.'**
  String get errorServer;

  /// No description provided for @retry.
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// No description provided for @zoneTitle.
  ///
  /// In es, this message translates to:
  /// **'Zona'**
  String get zoneTitle;

  /// No description provided for @zonePeninsula.
  ///
  /// In es, this message translates to:
  /// **'Península'**
  String get zonePeninsula;

  /// No description provided for @zoneCanarias.
  ///
  /// In es, this message translates to:
  /// **'Canarias'**
  String get zoneCanarias;

  /// No description provided for @zoneBaleares.
  ///
  /// In es, this message translates to:
  /// **'Baleares'**
  String get zoneBaleares;

  /// No description provided for @zoneCeuta.
  ///
  /// In es, this message translates to:
  /// **'Ceuta'**
  String get zoneCeuta;

  /// No description provided for @zoneMelilla.
  ///
  /// In es, this message translates to:
  /// **'Melilla'**
  String get zoneMelilla;

  /// No description provided for @notificationsTitle.
  ///
  /// In es, this message translates to:
  /// **'Avisos'**
  String get notificationsTitle;

  /// No description provided for @notifyTomorrow.
  ///
  /// In es, this message translates to:
  /// **'Precios de mañana'**
  String get notifyTomorrow;

  /// No description provided for @notifyTomorrowDetail.
  ///
  /// In es, this message translates to:
  /// **'Cada tarde, a las 20:30, un aviso para consultar las horas más baratas del día siguiente.'**
  String get notifyTomorrowDetail;

  /// No description provided for @channelTomorrowName.
  ///
  /// In es, this message translates to:
  /// **'Precios de mañana'**
  String get channelTomorrowName;

  /// No description provided for @channelTomorrowDescription.
  ///
  /// In es, this message translates to:
  /// **'Aviso diario cuando se publican los precios del día siguiente'**
  String get channelTomorrowDescription;

  /// No description provided for @notificationTomorrowTitle.
  ///
  /// In es, this message translates to:
  /// **'Ya están los precios de mañana'**
  String get notificationTomorrowTitle;

  /// No description provided for @privacyOptions.
  ///
  /// In es, this message translates to:
  /// **'Opciones de privacidad de anuncios'**
  String get privacyOptions;

  /// No description provided for @aboutTitle.
  ///
  /// In es, this message translates to:
  /// **'Acerca de'**
  String get aboutTitle;

  /// No description provided for @aboutText.
  ///
  /// In es, this message translates to:
  /// **'Precio voluntario para el pequeño consumidor (PVPC), publicado por Red Eléctrica. Solo es tu precio si tienes una tarifa regulada PVPC; en el mercado libre depende de tu contrato.'**
  String get aboutText;

  /// No description provided for @sourceTitle.
  ///
  /// In es, this message translates to:
  /// **'Fuentes oficiales'**
  String get sourceTitle;

  /// No description provided for @source1.
  ///
  /// In es, this message translates to:
  /// **'Precio PVPC en e·sios (Red Eléctrica)'**
  String get source1;

  /// No description provided for @source2.
  ///
  /// In es, this message translates to:
  /// **'API REData de Red Eléctrica'**
  String get source2;

  /// No description provided for @aboutDisclaimer.
  ///
  /// In es, this message translates to:
  /// **'Luz Barata es una app independiente y no está vinculada a Red Eléctrica, a ningún organismo público ni a ninguna comercializadora.'**
  String get aboutDisclaimer;

  /// No description provided for @version.
  ///
  /// In es, this message translates to:
  /// **'Versión {p1}'**
  String version(String p1);

  /// No description provided for @applianceTitle.
  ///
  /// In es, this message translates to:
  /// **'¿Cuánto me cuesta poner…?'**
  String get applianceTitle;

  /// No description provided for @applianceLocked.
  ///
  /// In es, this message translates to:
  /// **'Calcula lo que cuesta cada electrodoméstico ahora y en la mejor hora del día.'**
  String get applianceLocked;

  /// No description provided for @applianceCostNow.
  ///
  /// In es, this message translates to:
  /// **'Si lo pones ahora: {p1}'**
  String applianceCostNow(String p1);

  /// No description provided for @applianceCostBest.
  ///
  /// In es, this message translates to:
  /// **'En la mejor hora: {p1} ({p2})'**
  String applianceCostBest(String p1, String p2);

  /// No description provided for @applianceSaving.
  ///
  /// In es, this message translates to:
  /// **'Te ahorras {p1} por puesta'**
  String applianceSaving(String p1);

  /// No description provided for @applianceNote.
  ///
  /// In es, this message translates to:
  /// **'Estimación con un consumo típico y el precio PVPC sin impuestos.'**
  String get applianceNote;

  /// No description provided for @applianceWashingMachine.
  ///
  /// In es, this message translates to:
  /// **'Lavadora'**
  String get applianceWashingMachine;

  /// No description provided for @applianceDishwasher.
  ///
  /// In es, this message translates to:
  /// **'Lavavajillas'**
  String get applianceDishwasher;

  /// No description provided for @applianceDryer.
  ///
  /// In es, this message translates to:
  /// **'Secadora'**
  String get applianceDryer;

  /// No description provided for @applianceOven.
  ///
  /// In es, this message translates to:
  /// **'Horno'**
  String get applianceOven;

  /// No description provided for @applianceAirConditioning.
  ///
  /// In es, this message translates to:
  /// **'Aire acondicionado'**
  String get applianceAirConditioning;

  /// No description provided for @applianceElectricCar.
  ///
  /// In es, this message translates to:
  /// **'Coche eléctrico'**
  String get applianceElectricCar;

  /// No description provided for @premiumFeatureAppliances.
  ///
  /// In es, this message translates to:
  /// **'Calculadora de coste por electrodoméstico'**
  String get premiumFeatureAppliances;

  /// No description provided for @premiumSettingsText.
  ///
  /// In es, this message translates to:
  /// **'Quita los anuncios y desbloquea la calculadora de electrodomésticos.'**
  String get premiumSettingsText;

  /// No description provided for @removeAds.
  ///
  /// In es, this message translates to:
  /// **'Quitar anuncios'**
  String get removeAds;

  /// No description provided for @hoursShort.
  ///
  /// In es, this message translates to:
  /// **'{p1, plural, =1{{p1} h} other{{p1} h}}'**
  String hoursShort(int p1);

  /// No description provided for @premiumTitle.
  ///
  /// In es, this message translates to:
  /// **'Premium'**
  String get premiumTitle;

  /// No description provided for @premiumBack.
  ///
  /// In es, this message translates to:
  /// **'Volver'**
  String get premiumBack;

  /// No description provided for @premiumHeadline.
  ///
  /// In es, this message translates to:
  /// **'Pásate a Premium'**
  String get premiumHeadline;

  /// No description provided for @premiumActive.
  ///
  /// In es, this message translates to:
  /// **'Ya eres Premium. ¡Gracias por tu apoyo!'**
  String get premiumActive;

  /// No description provided for @premiumBenefitNoAds.
  ///
  /// In es, this message translates to:
  /// **'Sin anuncios'**
  String get premiumBenefitNoAds;

  /// No description provided for @premiumMonthly.
  ///
  /// In es, this message translates to:
  /// **'{p1} al mes'**
  String premiumMonthly(String p1);

  /// No description provided for @premiumLifetime.
  ///
  /// In es, this message translates to:
  /// **'{p1}, pago único para siempre'**
  String premiumLifetime(String p1);

  /// No description provided for @premiumLoading.
  ///
  /// In es, this message translates to:
  /// **'Cargando precio…'**
  String get premiumLoading;

  /// No description provided for @premiumStoreUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No se puede conectar con el App Store. Inténtalo más tarde.'**
  String get premiumStoreUnavailable;

  /// No description provided for @premiumRestore.
  ///
  /// In es, this message translates to:
  /// **'Restaurar compras'**
  String get premiumRestore;

  /// No description provided for @premiumLegal.
  ///
  /// In es, this message translates to:
  /// **'La suscripción se renueva cada mes y puedes cancelarla cuando quieras en el App Store.'**
  String get premiumLegal;

  /// No description provided for @lockedWatchAd.
  ///
  /// In es, this message translates to:
  /// **'Ver un anuncio y desbloquear 24 h'**
  String get lockedWatchAd;

  /// No description provided for @lockedGoPremium.
  ///
  /// In es, this message translates to:
  /// **'Hazte Premium'**
  String get lockedGoPremium;

  /// No description provided for @rewardedUnavailable.
  ///
  /// In es, this message translates to:
  /// **'No hay ningún anuncio disponible ahora mismo. Prueba dentro de un rato.'**
  String get rewardedUnavailable;

  /// No description provided for @privacyPolicy.
  ///
  /// In es, this message translates to:
  /// **'Política de privacidad'**
  String get privacyPolicy;

  /// No description provided for @termsOfUse.
  ///
  /// In es, this message translates to:
  /// **'Términos de uso'**
  String get termsOfUse;

  /// No description provided for @notificationTomorrowReminder.
  ///
  /// In es, this message translates to:
  /// **'Toca para ver la hora más barata y la más cara.'**
  String get notificationTomorrowReminder;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es', 'gl'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return LCa();
    case 'en':
      return LEn();
    case 'es':
      return LEs();
    case 'gl':
      return LGl();
  }

  throw FlutterError(
    'L.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
