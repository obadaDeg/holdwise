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
  NotificationsCubit() : super(const NotificationsState());

  /// Adds a new notification to the list.
  void addNotification(NotificationItem notification) {
    final updatedNotifications = List<NotificationItem>.from(state.notifications)
      ..insert(0, notification); // Insert at the beginning
    emit(state.copyWith(notifications: updatedNotifications));
  }

  /// Optionally, you can clear all notifications.
  void clearNotifications() {
    emit(const NotificationsState(notifications: []));
  }
}
