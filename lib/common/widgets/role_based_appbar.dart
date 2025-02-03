import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/utils/role_based_actions.dart';

class RoleBasedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool displayActions;
  final List<Widget>? selectedActions;

  const RoleBasedAppBar({
    super.key,
    required this.title,
    this.selectedActions,
    this.displayActions = true,
  });

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient; // Default role if not authenticated

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;

    final actions = RoleBasedActions.getAppBarActions(role, context, user!)['actions'] ?? [];

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        decoration: const BoxDecoration(
          gradient: Gradients.tertiaryGradient,
        ),
        child: AppBar(
          title: Text(title),
          actions: displayActions?  selectedActions ?? actions : null,
          backgroundColor: Colors.transparent,
          elevation: 0, // Optional: removes shadow for a cleaner gradient look
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
