import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/common/utils/role_based_actions.dart';

class RoleBasedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String role;
  final String title;

  const RoleBasedAppBar({super.key, required this.role, required this.title});

  @override
  Widget build(BuildContext context) {
    final actions = RoleBasedActions.getAppBarActions(role)['actions'] ?? [];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: Gradients.tertiaryGradient,
        ),
        child: AppBar(
          title: Text(title),
        actions: actions,
          backgroundColor: Colors.transparent,
          elevation: 0, // Optional: removes shadow for a cleaner gradient look
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
