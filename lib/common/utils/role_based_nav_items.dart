// role_based_nav_items.dart
import 'package:flutter/material.dart';

class RoleBasedNavItems {
  static List<Map<String, dynamic>> getDrawerItems(String role) {
    switch (role) {
      case 'admin':
        return [
          {
            'icon': Icons.settings,
            'label': 'Settings',
            'onTap': () {
              // Navigate to dashboard
            },
          },
          {
            'icon': Icons.manage_accounts,
            'label': 'Manage Users',
            'onTap': () {
              // Navigate to manage users
            },
          },
          {
            'icon': Icons.settings,
            'label': 'Settings',
            'onTap': () {
              // Navigate to settings
            },
          },
        ];
      case 'patient':
        return [
          {
            'icon': Icons.person,
            'label': 'Profile',
            'onTap': () {
              // Navigate to profile
            },
          },
          {
            'icon': Icons.calendar_today,
            'label': 'Appointments',
            'onTap': () {
              // Navigate to appointments
            },
          },
          {
            'icon': Icons.medical_services,
            'label': 'Medical Records',
            'onTap': () {
              // Navigate to medical records
            },
          },
        ];
      case 'specialist':
        return [
          {
            'icon': Icons.schedule,
            'label': 'Schedule',
            'onTap': () {
              // Navigate to schedule
            },
          },
          {
            'icon': Icons.person,
            'label': 'Profile',
            'onTap': () {
              // Navigate to profile
            },
          },
          {
            'icon': Icons.message,
            'label': 'Messages',
            'onTap': () {
              // Navigate to messages
            },
          },
        ];
      default:
        return [
          {
            'icon': Icons.help,
            'label': 'Help',
            'onTap': () {
              // Navigate to help
            },
          },
        ];
    }
  }

  static List<Map<String, dynamic>> getBottomNavItems(String role) {
    switch (role) {
      case 'admin':
        return [
          {
            'icon': Icons.dashboard,
            'label': 'Dashboard',

            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Dashboard'),
              ),
              body: Center(
                child: Text('Dashboard Screen'),
              ),
            ),
          },
          {
            'icon': Icons.manage_accounts,
            'label': 'Manage Users',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Manage Users'),
              ),
              body: Center(
                child: Text('Manage Users Screen'),
              ),
            ),
          },
          {
            'icon': Icons.settings,
            'label': 'Settings',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Settings'),
              ),
              body: Center(
                child: Text('Settings Screen'),
              ),
            ),
          },
        ];
      case 'patient':
        return [
          {
            'icon': Icons.person,
            'label': 'Profile',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: Text('Profile Screen'),
              ),
            ),
          },
          {
            'icon': Icons.calendar_today,
            'label': 'Appointments',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Appointments'),
              ),
              body: Center(
                child: Text('Appointments Screen'),
              ),
            ),
          },
          {
            'icon': Icons.medical_services,
            'label': 'Medical Records',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Medical Records'),
              ),
              body: Center(
                child: Text('Medical Records Screen'),
              ),
            ),
          },
        ];
      case 'specialist':
        return [
          {
            'icon': Icons.schedule,
            'label': 'Schedule',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Schedule'),
              ),
              body: Center(
                child: Text('Schedule Screen'),
              ),
            ),
          },
          {
            'icon': Icons.person,
            'label': 'Profile',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Profile'),
              ),
              body: Center(
                child: Text('Profile Screen'),
              ),
            ),
          },
          {
            'icon': Icons.message,
            'label': 'Messages',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Messages'),
              ),
              body: Center(
                child: Text('Messages Screen'),
              ),
            ),
          },
        ];
      default:
        return [
          {
            'icon': Icons.help,
            'label': 'Help',
            'screen': Scaffold(
              appBar: AppBar(
                title: Text('Help'),
              ),
              body: Center(
                child: Text('Help Screen'),
              ),
            ),
          },
        ];
    }
  }
}