import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:holdwise/features/notifications/data/cubits/notification_cubit.dart';
import 'package:holdwise/features/notifications/data/models/notification_item.dart';

class FirebaseNotificationService {
  final NotificationsCubit notificationsCubit;

  FirebaseNotificationService(this.notificationsCubit);

  Future<void> initialize() async {
    // Request permissions
    await FirebaseMessaging.instance.requestPermission();

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notificationItem = NotificationItem(
          title: message.notification?.title ?? 'No Title',
          message: message.notification?.body ?? 'No Message',
          dateTime: DateTime.now(),
        );
        notificationsCubit.addNotification(notificationItem);
      }
    });

    // When user taps on a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notificationItem = NotificationItem(
          title: message.notification?.title ?? 'No Title',
          message: message.notification?.body ?? 'No Message',
          dateTime: DateTime.now(),
        );
        notificationsCubit.addNotification(notificationItem);
      }
    });

    // Optional: Handle background messages.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background message if needed.
}
