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
  final PreferredSizeWidget? bottom;

  const RoleBasedAppBar({
    super.key,
    required this.title,
    this.selectedActions,
    this.displayActions = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    final role = state is AuthAuthenticated ? state.role : AppRoles.patient;
    final user = state is AuthAuthenticated ? state.user : null;

    final actions =
        RoleBasedActions.getAppBarActions(role, context, user!)['actions'] ?? [];

    return PreferredSize(
      preferredSize: Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: Gradients.tertiaryGradient,
        ),
        child: AppBar(
          title: Text(title),
          actions: displayActions ? selectedActions ?? actions : null,
          backgroundColor: Colors.transparent,
          elevation: 0,
          bottom: bottom,
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
