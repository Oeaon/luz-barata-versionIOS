import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Recordatorio diario a las 20:30 (hora peninsular), cuando REE ya ha publicado los precios de mañana.
/// En iOS no se puede descargar nada a una hora fija en segundo plano, así que el aviso solo invita a
/// abrir la app, que muestra directamente el día siguiente.
class TomorrowReminder {
  TomorrowReminder({required this.onOpenTomorrow});

  static const _id = 1;
  static const payload = 'tomorrow';

  final void Function() onOpenTomorrow;
  final _plugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _plugin.initialize(
      settings: const InitializationSettings(
        // Los permisos se piden al activar el aviso, no al abrir la app.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestSoundPermission: false,
          requestBadgePermission: false,
        ),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (response) {
        if (response.payload == payload) onOpenTomorrow();
      },
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp == true && launch?.notificationResponse?.payload == payload) onOpenTomorrow();
  }

  /// Devuelve false si el usuario no da permiso para notificaciones.
  Future<bool> enable({required String title, required String body, required String channelName, required String channelDescription}) async {
    final granted = await _plugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
            ?.requestPermissions(alert: true, sound: true) ??
        await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission() ??
        false;
    if (!granted) return false;
    final madrid = tz.getLocation('Europe/Madrid');
    final now = tz.TZDateTime.now(madrid);
    var next = tz.TZDateTime(madrid, now.year, now.month, now.day, 20, 30);
    if (!next.isAfter(now)) next = next.add(const Duration(days: 1));
    await _plugin.zonedSchedule(
      id: _id,
      scheduledDate: next,
      title: title,
      body: body,
      payload: payload,
      notificationDetails: NotificationDetails(
        iOS: const DarwinNotificationDetails(),
        android: AndroidNotificationDetails('tomorrow_prices', channelName, channelDescription: channelDescription),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    return true;
  }

  Future<void> disable() => _plugin.cancel(id: _id);
}
