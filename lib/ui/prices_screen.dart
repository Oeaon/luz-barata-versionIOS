import 'package:flutter/material.dart';

import '../app_info.dart';
import '../core/prices.dart';
import '../data/settings_store.dart';
import '../l10n/app_localizations.dart';
import '../monetization/monetization.dart';
import '../monetization/monetization_ui.dart';
import 'components.dart';
import 'format.dart';
import 'main_controller.dart';

class PricesScreen extends StatelessWidget {
  const PricesScreen({
    super.key,
    required this.controller,
    required this.monetization,
    required this.onEnableReminder,
    required this.onOpenSettings,
    required this.onOpenPremium,
  });

  final MainController controller;
  final Monetization monetization;
  final VoidCallback onEnableReminder;
  final VoidCallback onOpenSettings;
  final VoidCallback onOpenPremium;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([controller, monetization]),
      builder: (context, _) {
        final isToday = controller.selection == DaySelection.today;
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text(AppInfo.name),
            actions: [
              PremiumAction(monetization: monetization, onPressed: onOpenPremium),
              IconButton(onPressed: onOpenSettings, icon: const Icon(Icons.settings), tooltip: l.settings),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Choice(
                  options: [(DaySelection.today, l.today), (DaySelection.tomorrow, l.tomorrow)],
                  selected: controller.selection,
                  onSelect: controller.select,
                ),
                const SizedBox(height: 12),
                ...switch (controller.selected) {
                  DayLoading() => [const Padding(padding: EdgeInsets.all(48), child: Center(child: CircularProgressIndicator()))],
                  DayUnpublished() => [_NotPublishedCard(enabled: controller.settings.notifyTomorrow, onEnable: onEnableReminder)],
                  DayFailed(:final network) => [_MessageCard(network ? l.errorNetwork : l.errorServer, controller.refresh)],
                  DayReady(:final prices) => _dayContent(context, prices, isToday),
                },
                const SizedBox(height: 12),
                Text(l.dataSource, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          bottomNavigationBar: AdBanner(monetization: monetization),
        );
      },
    );
  }

  List<Widget> _dayContent(BuildContext context, DayPrices prices, bool isToday) {
    final l = L.of(context);
    final now = isToday ? controller.now : null;
    final current = now == null ? null : prices.hourAt(now);
    final settings = controller.settings;
    const gap = SizedBox(height: 12);
    return [
      if (current != null) ...[_CurrentPriceCard(current, prices.levelOf(current)), gap],
      _SummaryRow(prices),
      gap,
      _BestWindowCard(prices: prices, notBefore: now, settings: settings),
      gap,
      LockedFeature(
        monetization: monetization,
        title: l.applianceTitle,
        description: l.applianceLocked,
        onGoPremium: onOpenPremium,
        child: _ApplianceCard(prices: prices, now: now, settings: settings),
      ),
      gap,
      _PriceChart(prices: prices, current: current, now: now),
      gap,
      Text(l.allHours, style: Theme.of(context).textTheme.titleMedium),
      for (final hour in prices.hours)
        _HourRow(
          hour: hour,
          level: prices.levelOf(hour),
          isCurrent: hour == current,
          isPast: now != null && !hour.endUtc.isAfter(now),
        ),
    ];
  }
}

class _CurrentPriceCard extends StatelessWidget {
  const _CurrentPriceCard(this.hour, this.level);

  final HourPrice hour;
  final PriceLevel level;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final color = levelColor(context, level);
    return Card(
      // Opaco: con transparencia la sombra de la tarjeta oscurece el color.
      color: Color.alphaBlend(color.withValues(alpha: 0.14), theme.colorScheme.surface),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l.nowLabel(hourRange(hour)), style: theme.textTheme.titleSmall),
          Text(formatPrice(l.localeName, hour.eurPerKwh), style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
          Row(children: [
            _LevelDot(color),
            const SizedBox(width: 6),
            Text(levelLabel(l, level), style: theme.textTheme.labelLarge?.copyWith(color: color)),
          ]),
        ]),
      ),
    );
  }
}

class _LevelDot extends StatelessWidget {
  const _LevelDot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) =>
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.prices);

  final DayPrices prices;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final locale = l.localeName;
    return Row(spacing: 8, crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: _Tile(l.cheapest, formatPriceNumber(locale, prices.cheapest.eurPerKwh), formatHour(prices.cheapest.localStart))),
      Expanded(child: _Tile(l.average, formatPriceNumber(locale, prices.average), '')),
      Expanded(
        child: _Tile(l.mostExpensive, formatPriceNumber(locale, prices.mostExpensive.eurPerKwh), formatHour(prices.mostExpensive.localStart)),
      ),
    ]);
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.label, this.value, this.detail);

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          Text(priceUnit, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          Text(detail, style: theme.textTheme.labelSmall),
        ]),
      ),
    );
  }
}

class _BestWindowCard extends StatelessWidget {
  const _BestWindowCard({required this.prices, required this.notBefore, required this.settings});

  final DayPrices prices;
  final DateTime? notBefore;
  final SettingsStore settings;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final theme = Theme.of(context);
    final window = prices.cheapestWindow(settings.windowHours, notBefore: notBefore);
    final saving = window == null ? 0 : ((1 - window.average / prices.average) * 100).round();
    return ResultCard(children: [
      Text(l.bestWindowTitle, style: theme.textTheme.titleMedium),
      Wrap(spacing: 8, children: [
        for (var h = SettingsStore.minWindow; h <= SettingsStore.maxWindow; h++)
          FilterChip(label: Text(l.hoursShort(h)), selected: h == settings.windowHours, onSelected: (_) => settings.setWindowHours(h)),
      ]),
      if (window == null)
        Text(l.bestWindowNone)
      else ...[
        Text(windowRange(window), style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(l.bestWindowAverage(formatPrice(l.localeName, window.average))),
        if (saving > 0) Text(l.bestWindowSaving(saving), style: TextStyle(color: levelColor(context, PriceLevel.low))),
      ],
    ]);
  }
}

/// Función Premium: cuánto cuesta una puesta ahora y en la mejor franja.
class _ApplianceCard extends StatelessWidget {
  const _ApplianceCard({required this.prices, required this.now, required this.settings});

  final DayPrices prices;
  final DateTime? now;
  final SettingsStore settings;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final locale = l.localeName;
    final estimate = ApplianceCost.estimate(prices, settings.appliance, now);
    return ResultCard(children: [
      Text(l.applianceTitle, style: Theme.of(context).textTheme.titleMedium),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(spacing: 8, children: [
          for (final a in Appliance.values)
            FilterChip(label: Text(applianceName(l, a)), selected: a == settings.appliance, onSelected: (_) => settings.setAppliance(a)),
        ]),
      ),
      if (estimate == null)
        Text(l.bestWindowNone)
      else ...[
        if (estimate.costNow != null) Text(l.applianceCostNow(formatEuros(estimate.costNow!, locale))),
        Text(l.applianceCostBest(formatEuros(estimate.bestCost, locale), windowRange(estimate.bestWindow)),
            style: const TextStyle(fontWeight: FontWeight.w600)),
        if (estimate.saving >= 0.01)
          Text(l.applianceSaving(formatEuros(estimate.saving, locale)), style: TextStyle(color: levelColor(context, PriceLevel.low))),
        Note(l.applianceNote),
      ],
    ]);
  }
}

class _PriceChart extends StatelessWidget {
  const _PriceChart({required this.prices, required this.current, required this.now});

  final DayPrices prices;
  final HourPrice? current;
  final DateTime? now;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant);
    final max = prices.mostExpensive.eurPerKwh <= 0 ? 0.0001 : prices.mostExpensive.eurPerKwh;
    return Card(
      child: Semantics(
        label: L.of(context).chartDescription,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 148,
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              for (final hour in prices.hours)
                Expanded(
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      height: (hour.eurPerKwh / max * 120).clamp(2, 120).toDouble(),
                      margin: const EdgeInsets.symmetric(horizontal: 1.5),
                      decoration: BoxDecoration(
                        color: levelColor(context, prices.levelOf(hour)).withValues(
                          alpha: hour == current ? 1 : (now != null && !hour.endUtc.isAfter(now!) ? 0.3 : 0.8),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    SizedBox(
                      height: 16,
                      child: hour.localStart.hour % 6 == 0
                          ? OverflowBox(maxWidth: 40, child: Text(formatHour(hour.localStart).substring(0, 2), style: label))
                          : null,
                    ),
                  ]),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

class _HourRow extends StatelessWidget {
  const _HourRow({required this.hour, required this.level, required this.isCurrent, required this.isPast});

  final HourPrice hour;
  final PriceLevel level;
  final bool isCurrent;
  final bool isPast;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    final weight = isCurrent ? FontWeight.bold : FontWeight.normal;
    return Opacity(
      opacity: isPast ? 0.45 : 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          _LevelDot(levelColor(context, level)),
          const SizedBox(width: 12),
          Expanded(child: Text(hourRange(hour), style: TextStyle(fontWeight: weight))),
          if (isCurrent)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Text(l.nowTag,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary)),
            ),
          Text(formatPrice(l.localeName, hour.eurPerKwh), style: TextStyle(fontWeight: weight)),
        ]),
      ),
    );
  }
}

class _NotPublishedCard extends StatelessWidget {
  const _NotPublishedCard({required this.enabled, required this.onEnable});

  final bool enabled;
  final VoidCallback onEnable;

  @override
  Widget build(BuildContext context) {
    final l = L.of(context);
    return ResultCard(children: [
      Text(l.tomorrowNotPublished, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 6),
      if (enabled) Text(l.tomorrowWillNotify) else FilledButton(onPressed: onEnable, child: Text(l.notifyMe)),
    ]);
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard(this.message, this.onRetry);

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return ResultCard(children: [
      Text(message, style: Theme.of(context).textTheme.bodyLarge),
      const SizedBox(height: 6),
      OutlinedButton(onPressed: onRetry, child: Text(L.of(context).retry)),
    ]);
  }
}
