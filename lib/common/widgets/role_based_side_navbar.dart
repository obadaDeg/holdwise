import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/common/utils/role_based_nav_items.dart';
import 'package:holdwise/common/widgets/general_dialog.dart';
import 'package:holdwise/features/notifications/data/cubits/notification_cubit.dart';

class RoleBasedDrawer extends StatelessWidget {
  final String role;

  const RoleBasedDrawer({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final navItems = RoleBasedNavItems.getDrawerItems(role, context);
    final themeMode = context.watch<ThemeCubit>().state;
    final isDarkMode = themeMode == ThemeMode.dark;

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(context, isDarkMode),
          Expanded(
            child: ListView.builder(
              itemCount: navItems.length,
              itemBuilder: (context, index) {
                final item = navItems[index];
                return ListTile(
                  leading: Icon(item['icon'],
                      color:
                          isDarkMode ? AppColors.tertiary100 : AppColors.tertiary500),
                  title: Text(item['label']),
                  onTap: item['onTap'],
                );
              },
            ),
          ),
          Divider(
            color: isDarkMode ? AppColors.gray700 : AppColors.gray200,
            height: 1,
          ),
          ListTile(
            leading: Icon(
              isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDarkMode ? AppColors.tertiary100 : AppColors.tertiary500,
            ),
            title: Text(
              isDarkMode ? "Light Mode" : "Dark Mode",
              style: TextStyle(
                color: !isDarkMode ? AppColors.gray700 : AppColors.gray200,
              ),
            ),
            onTap: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          ListTile(
            leading: Icon(Icons.logout,
                color: isDarkMode ? AppColors.error : AppColors.danger),
            title: Text('Logout',
                style: TextStyle(
                    color: isDarkMode ? AppColors.error : AppColors.danger)),
            onTap: () => _confirmLogout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, bool isDarkMode) {
    final authState = context.watch<AuthCubit>().state;
    String? imageURL;
    if (authState is AuthAuthenticated) {
      imageURL = authState.user.photoURL;
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        gradient: Gradients.tertiaryGradient,
        borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Row to align avatar, name, and notification icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Profile Avatar & Name
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.profile);
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: AppColors.tertiary100,
                      backgroundImage:
                          imageURL != null ? NetworkImage(imageURL) : null,
                      child: imageURL == null
                          ? Icon(Icons.person,
                              size: 25, color: AppColors.tertiary500)
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      authState is AuthAuthenticated
                          ? authState.user.displayName!
                          : 'Guest',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              // Notification icon with badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.notifications);
                    },
                  ),
                  // Use BlocBuilder to update the badge count dynamically.
                  BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) {
                      final count = state.notifications.length;
                      return Positioned(
                        right: 6,
                        top: 6,
                        child: count > 0
                            ? Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary500,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : const SizedBox(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => GeneralDialog(
        title: 'Confirm Logout',
        message: 'Are you sure you want to log out?',
        icon: Icons.warning_amber_rounded,
        onCancel: () => Navigator.pop(ctx),
        onConfirm: () {
          Navigator.pop(ctx);
          context.read<AuthCubit>().logout();
        },
      ),
    );
  }
}
