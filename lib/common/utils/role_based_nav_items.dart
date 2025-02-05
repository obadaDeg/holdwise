import 'package:flutter/material.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/routes/routes.dart';

class RoleBasedNavItems {
  /// Common drawer items available to all users
  static List<Map<String, dynamic>> _getSharedDrawerItems(BuildContext context) {
    return [
      {
        'icon': Icons.settings,
        'label': 'Settings',
        'onTap': () => Navigator.pushNamed(context, AppRoutes.profileSettings),
      },
      {
        'icon': Icons.help,
        'label': 'Help',
        'onTap': () => Navigator.pushNamed(context, AppRoutes.help),
      },
      {
        'icon': Icons.info,
        'label': 'About',
        'onTap': () => Navigator.pushNamed(context, AppRoutes.about),
      }
    ];
  }

  /// Role-based drawer items
  static List<Map<String, dynamic>> getDrawerItems(String role, BuildContext context) {
    List<Map<String, dynamic>> roleSpecificItems = [];

    switch (role) {
      case AppRoles.admin:
        roleSpecificItems = [
          {
            'icon': Icons.dashboard,
            'label': 'Dashboard',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.dashboard),
          },
          {
            'icon': Icons.manage_accounts,
            'label': 'Manage Users',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.manageUsers),
          },
          {
            'icon': Icons.receipt,
            'label': 'Reports',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.reports),
          },
        ];
        break;

      case AppRoles.patient:
        roleSpecificItems = [
          {
            'icon': Icons.calendar_today,
            'label': 'Appointments',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.appointments),
          },
          {
            'icon': Icons.chat,
            'label': 'Chat',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.chat),
          },
          {
            'icon': Icons.subscriptions,
            'label': 'Subscription',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.subscription),
          },
        ];
        break;

      case AppRoles.specialist:
        roleSpecificItems = [
          {
            'icon': Icons.schedule,
            'label': 'Schedule',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.schedule),
          },
          {
            'icon': Icons.people,
            'label': 'Patients',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.patients),
          },
          {
            'icon': Icons.message,
            'label': 'Messages',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.chat),
          },
        ];
        break;

      default:
        roleSpecificItems = [
          {
            'icon': Icons.help,
            'label': 'Help',
            'onTap': () => Navigator.pushNamed(context, AppRoutes.help),
          },
        ];
    }

    return [...roleSpecificItems, ..._getSharedDrawerItems(context)];
  }
}