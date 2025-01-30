import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/utils/role_based_nav_items.dart';
import 'package:holdwise/common/widgets/general_dialog.dart';

class RoleBasedDrawer extends StatelessWidget {
  final String role; // User role (admin, patient, specialist)

  const RoleBasedDrawer({super.key, required this.role});

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
                style: const TextStyle(
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
                  onTap: () {
                    if (item['label'] == 'Logout') {
                      _confirmLogout(context);
                    } else {
                      item['onTap']?.call();
                    }
                  },
                );
              },
            ),
          ),
          const Divider(
            color: AppColors.gray200,
            height: 1,
          ), // Visual separation before logout
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.danger),
            title:
                const Text('Logout', style: TextStyle(color: AppColors.danger)),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  /// Logout Confirmation Dialog
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => GeneralDialog(
        title: 'Confirm Logout',
        message: 'Are you sure you want to log out?',
        icon: Icons.warning_amber_rounded, // Floating icon
        onCancel: () => Navigator.pop(ctx), // Cancel
        onConfirm: () {
          Navigator.pop(ctx); // Close dialog
          context.read<AuthCubit>().logout(); // Trigger logout
        },
      ),
    );
  }
}
