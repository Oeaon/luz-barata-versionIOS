// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get back => 'Back';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String nowLabel(String p1) {
    return 'Now ($p1)';
  }

  @override
  String get nowTag => 'Now';

  @override
  String get levelLow => 'Cheap';

  @override
  String get levelMedium => 'Average';

  @override
  String get levelHigh => 'Expensive';

  @override
  String get cheapest => 'Lowest';

  @override
  String get average => 'Average';

  @override
  String get mostExpensive => 'Highest';

  @override
  String get bestWindowTitle =>
      'Best time for the washing machine, dishwasher…';

  @override
  String bestWindowAverage(String p1) {
    return '$p1 on average';
  }

  @override
  String bestWindowSaving(int p1) {
    return '$p1 % cheaper than the daily average';
  }

  @override
  String get bestWindowNone =>
      'Not enough hours left today. Check tomorrow\'s prices.';

  @override
  String get allHours => 'All hours';

  @override
  String get chartDescription => 'Hourly electricity price chart';

  @override
  String get dataSource =>
      'PVPC price excluding taxes. Data: Red Eléctrica (REData).';

  @override
  String get tomorrowNotPublished =>
      'Tomorrow\'s prices are published every day around 20:15.';

  @override
  String get tomorrowWillNotify =>
      'We\'ll let you know as soon as they are out.';

  @override
  String get notifyMe => 'Notify me';

  @override
  String get errorNetwork =>
      'No connection. Check your internet and try again.';

  @override
  String get errorServer => 'Prices could not be loaded. Try again later.';

  @override
  String get retry => 'Retry';

  @override
  String get zoneTitle => 'Region';

  @override
  String get zonePeninsula => 'Mainland Spain';

  @override
  String get zoneCanarias => 'Canary Islands';

  @override
  String get zoneBaleares => 'Balearic Islands';

  @override
  String get zoneCeuta => 'Ceuta';

  @override
  String get zoneMelilla => 'Melilla';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notifyTomorrow => 'Tomorrow\'s prices';

  @override
  String get notifyTomorrowDetail =>
      'Every evening at 8:30 pm, a reminder to check the cheapest hours of the next day.';

  @override
  String get channelTomorrowName => 'Tomorrow\'s prices';

  @override
  String get channelTomorrowDescription =>
      'Daily notice when next day\'s prices are published';

  @override
  String get notificationTomorrowTitle => 'Tomorrow\'s prices are out';

  @override
  String get privacyOptions => 'Ad privacy options';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutText =>
      'Regulated tariff for small consumers (PVPC), published by Red Eléctrica. It is only your price if you are on the regulated PVPC tariff; on the free market it depends on your contract.';

  @override
  String get sourceTitle => 'Official sources';

  @override
  String get source1 => 'PVPC price on e·sios (Red Eléctrica)';

  @override
  String get source2 => 'Red Eléctrica REData API';

  @override
  String get aboutDisclaimer =>
      'Luz Barata is an independent app and is not affiliated with Red Eléctrica, any government body or any electricity supplier.';

  @override
  String version(String p1) {
    return 'Version $p1';
  }

  @override
  String get applianceTitle => 'How much does it cost to run…?';

  @override
  String get applianceLocked =>
      'Work out what each appliance costs now and at the best time of the day.';

  @override
  String applianceCostNow(String p1) {
    return 'If you start it now: $p1';
  }

  @override
  String applianceCostBest(String p1, String p2) {
    return 'At the best time: $p1 ($p2)';
  }

  @override
  String applianceSaving(String p1) {
    return 'You save $p1 per use';
  }

  @override
  String get applianceNote =>
      'Estimate with typical consumption and the PVPC price excluding taxes.';

  @override
  String get applianceWashingMachine => 'Washing machine';

  @override
  String get applianceDishwasher => 'Dishwasher';

  @override
  String get applianceDryer => 'Dryer';

  @override
  String get applianceOven => 'Oven';

  @override
  String get applianceAirConditioning => 'Air conditioning';

  @override
  String get applianceElectricCar => 'Electric car';

  @override
  String get premiumFeatureAppliances => 'Appliance cost calculator';

  @override
  String get premiumSettingsText =>
      'Remove the ads and unlock the appliance calculator.';

  @override
  String get removeAds => 'Remove ads';

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
  String get premiumBack => 'Back';

  @override
  String get premiumHeadline => 'Go Premium';

  @override
  String get premiumActive => 'You are Premium. Thanks for your support!';

  @override
  String get premiumBenefitNoAds => 'No ads';

  @override
  String premiumMonthly(String p1) {
    return '$p1 per month';
  }

  @override
  String premiumLifetime(String p1) {
    return '$p1, one-off payment forever';
  }

  @override
  String get premiumLoading => 'Loading price…';

  @override
  String get premiumStoreUnavailable =>
      'Cannot connect to the App Store. Try again later.';

  @override
  String get premiumRestore => 'Restore purchases';

  @override
  String get premiumLegal =>
      'The subscription renews every month and you can cancel it at any time in the App Store.';

  @override
  String get lockedWatchAd => 'Watch an ad to unlock for 24 h';

  @override
  String get lockedGoPremium => 'Go Premium';

  @override
  String get rewardedUnavailable =>
      'No ad is available right now. Try again in a while.';

  @override
  String get privacyPolicy => 'Privacy policy';

  @override
  String get termsOfUse => 'Terms of use';

  @override
  String get notificationTomorrowReminder =>
      'Tap to see the cheapest and most expensive hours.';
}
