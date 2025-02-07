import 'package:equatable/equatable.dart';

class NotificationItem extends Equatable {
  final String title;
  final String message;
  final DateTime dateTime;

  const NotificationItem({
    required this.title,
    required this.message,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [title, message, dateTime];
}
