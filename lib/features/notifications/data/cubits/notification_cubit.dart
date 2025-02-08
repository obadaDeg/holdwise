import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:holdwise/features/notifications/data/models/notification_item.dart';

class NotificationsState extends Equatable {
  final List<NotificationItem> notifications;

  const NotificationsState({this.notifications = const []});

  NotificationsState copyWith({List<NotificationItem>? notifications}) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  List<Object?> get props => [notifications];
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState()) {
    _initFirebaseMessaging();
  }

  /// Adds a new notification to the list.

  void addNotification(NotificationItem notification) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not authenticated. Cannot save notification.");
      return;
    }

    final userNotificationsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications');

    // Save to Firestore
    try {
      await userNotificationsCollection.add({
        'title': notification.title,
        'message': notification.message,
        'dateTime': notification.dateTime.toIso8601String(),
      });
    } catch (e) {
      print("Error saving notification: $e");
    }

    // Update local state
    final updatedNotifications =
        List<NotificationItem>.from(state.notifications)
          ..insert(0, notification);
    emit(state.copyWith(notifications: updatedNotifications));
  }

  /// Optionally, you can clear all notifications.
  void clearNotifications() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not authenticated. Cannot clear notifications.");
      return;
    }

    final userNotificationsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications');

    // Delete all notifications for the current user
    final batch = FirebaseFirestore.instance.batch();
    final querySnapshot = await userNotificationsCollection.get();

    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();

    emit(const NotificationsState(notifications: []));
  }

  /// Initialize Firebase Messaging to listen for messages.
  void _initFirebaseMessaging() async {
    // Request permission on iOS (and optionally on Android)
    await FirebaseMessaging.instance.requestPermission();

    // Handle foreground messages.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notificationItem = NotificationItem(
          title: message.notification?.title ?? 'No Title',
          message: message.notification?.body ?? 'No Message',
          dateTime: DateTime.now(),
        );
        addNotification(notificationItem);
      }
    });

    // Handle when the user taps on a notification to open the app.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        final notificationItem = NotificationItem(
          title: message.notification?.title ?? 'No Title',
          message: message.notification?.body ?? 'No Message',
          dateTime: DateTime.now(),
        );
        addNotification(notificationItem);
        // Optionally: Navigate directly to a detail screen
      }
    });

    // Optionally, handle background messages.
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void fetchUserNotifications() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("User not authenticated. Cannot fetch notifications.");
      return;
    }

    final userNotificationsCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications');

    final querySnapshot = await userNotificationsCollection.get();
    final notifications = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return NotificationItem(
        title: data['title'],
        message: data['message'],
        dateTime: DateTime.parse(data['dateTime']),
      );
    }).toList();

    emit(state.copyWith(notifications: notifications));
  }
}

/// This top-level function is required to handle background messages.
/// Make sure to annotate it with `@pragma('vm:entry-point')` if needed.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Note: You cannot update your cubit or UI directly in a background handler.
  // Instead, you might want to store data or trigger a local notification.
  // For example, you could use the flutter_local_notifications package here.
}
