import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/features/chat/data/models/chat_user.dart';

class RoleBasedActions {
  static Map<String, List<Widget>> getAppBarActions(String role, BuildContext context, User user) {
    switch (role) {
      case AppRoles.admin:
        return {
          'actions': [
            IconButton(
              icon: Icon(Icons.dashboard),
              onPressed: () {
                // Navigate to dashboard
              },
            ),
            IconButton(
              icon: Icon(Icons.manage_accounts),
              onPressed: () {
                // Navigate to manage users
              },
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Logout logic
              },
            ),
          ],
        };
      case AppRoles.patient:
        return {
          'actions': [
            IconButton(
              icon: Icon(Icons.calendar_today),
              tooltip: 'Book an appointment',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.appointments, arguments: user.uid);
              },
            ),
            IconButton(
              icon: Icon(Icons.chat),
              tooltip: 'Chat with specialist',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.chat, arguments: ChatUser.fromFirebase(user));
              },
            ),
          ],
        };
      case AppRoles.specialist:
        return {
          'actions': [
            IconButton(
              icon: Icon(Icons.schedule),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.appointments, arguments: user.uid);
              },
            ),
            IconButton(
              icon: Icon(Icons.chat),
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.chat, arguments: ChatUser.fromFirebase(user));
              },
            ),
          ],
        };
      default:
        return {
          'actions': [
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {
                // Default action
              },
            ),
          ],
        };
    }
  }
}
