import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:holdwise/features/appointments/data/models/appointment.dart';
import 'package:timezone/timezone.dart';

class AppointmentNotificationService {
  final FirebaseFirestore _firestore;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _localNotifications;

  AppointmentNotificationService({
    FirebaseFirestore? firestore,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _messaging = messaging ?? FirebaseMessaging.instance,
        _localNotifications = localNotifications ?? FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for notifications
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // Initialize local notifications
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );
      await _localNotifications.initialize(initializationSettings);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    }
  }

  Future<void> scheduleAppointmentReminders(Appointment appointment) async {
    // Schedule reminders at different intervals
    final appointmentTime = appointment.appointmentTime;
    
    // 24 hours before
    _scheduleReminder(
      appointment,
      appointmentTime.subtract(const Duration(hours: 24)),
      'Upcoming Appointment Tomorrow',
      'You have an appointment scheduled for tomorrow at ${_formatTime(appointmentTime)}',
    );

    // 1 hour before
    _scheduleReminder(
      appointment,
      appointmentTime.subtract(const Duration(hours: 1)),
      'Appointment in 1 Hour',
      'Your appointment is starting in 1 hour at ${_formatTime(appointmentTime)}',
    );

    // 15 minutes before
    _scheduleReminder(
      appointment,
      appointmentTime.subtract(const Duration(minutes: 15)),
      'Appointment Soon',
      'Your appointment is starting in 15 minutes',
    );
  }

  Future<void> _scheduleReminder(
    Appointment appointment,
    DateTime scheduledTime,
    String title,
    String body,
  ) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    // Schedule local notification
    await _localNotifications.zonedSchedule(
      appointment.id.hashCode + scheduledTime.millisecondsSinceEpoch.hashCode,
      title,
      body,
      TZDateTime.from(scheduledTime, local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'appointment_reminders',
          'Appointment Reminders',
          channelDescription: 'Notifications for upcoming appointments',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exact,
      // androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Store reminder in Firestore for backup
    await _firestore.collection('appointment_reminders').add({
      'appointmentId': appointment.id,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'title': title,
      'body': body,
      'status': 'scheduled',
    });
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    // Show local notification for foreground messages
    final notification = message.notification;
    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'appointment_updates',
            'Appointment Updates',
            channelDescription: 'Notifications for appointment updates',
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
      );
    }
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Cancel all reminders for a specific appointment
  Future<void> cancelAppointmentReminders(String appointmentId) async {
    // Cancel local notifications
    final reminders = await _firestore
        .collection('appointment_reminders')
        .where('appointmentId', isEqualTo: appointmentId)
        .get();

    for (var reminder in reminders.docs) {
      await _localNotifications.cancel(
        appointmentId.hashCode + reminder.id.hashCode,
      );
      await reminder.reference.update({'status': 'cancelled'});
    }
  }
}

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message
  print('Handling background message: ${message.messageId}');
}