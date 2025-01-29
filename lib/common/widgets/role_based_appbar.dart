import 'package:flutter/material.dart';
import 'package:holdwise/common/utils/role_based_actions.dart';

class RoleBasedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role; // User role (admin, patient, specialist)
  final String title;

  const RoleBasedAppBar({super.key, required this.role, required this.title});

  @override
  Widget build(BuildContext context) {
    final actions = RoleBasedActions.getAppBarActions(role)['actions'] ?? [];

    return AppBar(
      title: Text(title),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
