import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/features/notifications/data/cubits/notification_cubit.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check current theme mode
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    // Determine screen size for responsiveness
    final mediaQuery = MediaQuery.of(context);
    final isLargeScreen = mediaQuery.size.width > 600;
    final horizontalPadding = isLargeScreen ? 32.0 : 16.0;

    return Scaffold(
      appBar: const RoleBasedAppBar(title: 'Notifications', displayActions: false),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state.notifications.isEmpty) {
            return Center(
              child: Text(
                'No notifications yet.',
                style: TextStyle(
                  fontSize: isLargeScreen ? 22 : 18,
                  color: isDarkMode ? AppColors.gray200 : AppColors.gray900,
                ),
              ),
            );
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16.0),
            child: ListView.separated(
              itemCount: state.notifications.length,
              separatorBuilder: (context, index) => SizedBox(height: isLargeScreen ? 16 : 12),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];
                final formattedTime = DateFormat('hh:mm a').format(notification.dateTime);
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    // Make the card navigable when tapped
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailScreen(notification: notification),
                        ),
                      );
                    },
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 24 : 16,
                      vertical: isLargeScreen ? 16 : 8,
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isLargeScreen ? 18 : 16,
                        color: AppColors.secondary500,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        notification.message,
                        style: TextStyle(fontSize: isLargeScreen ? 16 : 14),
                      ),
                    ),
                    trailing: Text(
                      formattedTime,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isLargeScreen ? 14 : 12,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  // Change the type of `notification` to match your model if available.
  final dynamic notification;
  const NotificationDetailScreen({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 600;
    final formattedDateTime = DateFormat('dd MMM yyyy, hh:mm a').format(notification.dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(notification.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 32.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: TextStyle(
                fontSize: isLargeScreen ? 24 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isLargeScreen ? 24 : 16),
            Text(
              notification.message,
              style: TextStyle(
                fontSize: isLargeScreen ? 20 : 16,
              ),
            ),
            SizedBox(height: isLargeScreen ? 24 : 16),
            Text(
              'Received at: $formattedDateTime',
              style: TextStyle(
                fontSize: isLargeScreen ? 18 : 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
