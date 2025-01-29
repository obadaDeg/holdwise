import 'package:flutter/material.dart';
import 'package:holdwise/common/utils/role_based_nav_items.dart';

class RoleBasedSideNavBar extends StatelessWidget {
  final String role; // User role (admin, patient, specialist)

  const RoleBasedSideNavBar({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final navItems = RoleBasedNavItems.getDrawerItems(role);

    return Drawer(
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                'Welcome, $role',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Dynamic Menu Items
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                return ListTile(
                  leading: Icon(item['icon']),
                  title: Text(item['label']),
                  onTap: item['onTap'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
