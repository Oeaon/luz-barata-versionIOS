import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tzdata;

import 'app_info.dart';
import 'core/prices.dart';
import 'data/pvpc_repository.dart';
import 'data/reminder.dart';
import 'data/settings_store.dart';
import 'l10n/app_localizations.dart';
import 'monetization/monetization.dart';
import 'monetization/monetization_ui.dart';
import 'ui/format.dart';
import 'ui/main_controller.dart';
import 'ui/prices_screen.dart';
import 'ui/settings_screen.dart';

const _seed = Color(0xFF1E6B3A);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tzdata.initializeTimeZones();
  final monetization = await Monetization.create();
  final settings = await SettingsStore.open();
  final controller = MainController(settings, PvpcRepository());
  final reminder = TomorrowReminder(onOpenTomorrow: () => controller.select(DaySelection.tomorrow));
  await reminder.init();
  runApp(App(monetization: monetization, controller: controller, reminder: reminder));
}

class App extends StatelessWidget {
  const App({super.key, required this.monetization, required this.controller, required this.reminder});

  final Monetization monetization;
  final MainController controller;
  final TomorrowReminder reminder;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.name,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _seed)),
      darkTheme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark)),
      localizationsDelegates: const [
        L.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: L.supportedLocales,
      home: Root(monetization: monetization, controller: controller, reminder: reminder),
    );
  }
}

class Root extends StatefulWidget {
  const Root({super.key, required this.monetization, required this.controller, required this.reminder});

  final Monetization monetization;
  final MainController controller;
  final TomorrowReminder reminder;

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  SettingsStore get _settings => widget.controller.settings;

  @override
  void initState() {
    super.initState();
    // El consentimiento se pide con la primera pantalla ya dibujada.
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.monetization.gatherConsent());
  }

  Future<void> _setReminder(bool enabled) async {
    if (!enabled) {
      await widget.reminder.disable();
      await _settings.setNotifyTomorrow(false);
      return;
    }
    final l = L.of(context);
    final granted = await widget.reminder.enable(
      title: l.notificationTomorrowTitle,
      body: l.notificationTomorrowReminder,
      channelName: l.channelTomorrowName,
      channelDescription: l.channelTomorrowDescription,
    );
    await _settings.setNotifyTomorrow(granted);
  }

  void _openPremium() {
    final l = L.of(context);
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => PremiumScreen(
        monetization: widget.monetization,
        features: [l.premiumFeatureAppliances],
        privacyUrl: AppInfo.privacyUrl,
        termsUrl: AppInfo.termsUrl,
      ),
    ));
  }

  Future<void> _openSettings() async {
    await Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final l = L.of(context);
      return SettingsScreen(
        monetization: widget.monetization,
        onOpenPremium: _openPremium,
        sourceLabels: [l.source1, l.source2],
        appSection: [_LuzSettings(settings: _settings, onReminderChanged: _setReminder)],
      );
    }));
    // Volver a la pantalla principal es una pausa natural para un intersticial.
    widget.monetization.maybeShowInterstitial();
  }

  @override
  Widget build(BuildContext context) {
    return PricesScreen(
      controller: widget.controller,
      monetization: widget.monetization,
      onEnableReminder: () => _setReminder(true),
      onOpenSettings: _openSettings,
      onOpenPremium: _openPremium,
    );
  }
}

/// Zona del PVPC y aviso de los precios de mañana.
class _LuzSettings extends StatelessWidget {
  const _LuzSettings({required this.settings, required this.onReminderChanged});

  final SettingsStore settings;
  final ValueChanged<bool> onReminderChanged;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle(l.zoneTitle),
        RadioGroup<PvpcZone>(
          groupValue: settings.zone,
          onChanged: (z) {
            if (z != null) settings.setZone(z);
          },
          child: Column(children: [
            for (final zone in PvpcZone.values)
              RadioListTile<PvpcZone>(value: zone, title: Text(zoneName(l, zone)), contentPadding: EdgeInsets.zero),
          ]),
        ),
        const Divider(height: 32),
        SectionTitle(l.notificationsTitle),
        SwitchListTile(
          value: settings.notifyTomorrow,
          onChanged: onReminderChanged,
          title: Text(l.notifyTomorrow),
          subtitle: Text(l.notifyTomorrowDetail),
          contentPadding: EdgeInsets.zero,
        ),
      ]),
    );
  }
}
