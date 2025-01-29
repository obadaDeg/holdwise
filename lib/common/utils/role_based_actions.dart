import 'package:flutter/material.dart';

class RoleBasedActions {
  static Map<String, List<Widget>> getAppBarActions(String role) {
    switch (role) {
      case 'admin':
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
      case 'patient':
        return {
          'actions': [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Navigate to profile
              },
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                // Navigate to appointments
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
      case 'specialist':
        return {
          'actions': [
            IconButton(
              icon: Icon(Icons.schedule),
              onPressed: () {
                // Navigate to schedule
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                // Navigate to profile
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
