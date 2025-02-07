import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/common/widgets/role_based_side_navbar.dart';
import 'package:holdwise/features/appointments/presentation/pages/appointments_screen.dart';
import 'package:holdwise/features/camera_screen/presentation/pages/camera_screen.dart';
import 'package:holdwise/features/chat/data/models/chat_user.dart';
import 'package:holdwise/features/chat/presentation/pages/chat_screen.dart';
import 'package:holdwise/features/dashboard/presentation/pages/dashboard.dart';
import 'package:holdwise/features/explore_screen/presentation/pages/explore_screen.dart';
import 'package:holdwise/features/info/presentation/pages/help_screen.dart';
import 'package:holdwise/features/manage_specialist/presentation/pages/manage_specialists.dart';
import 'package:holdwise/features/profile/presentation/pages/settings_screen_dialog.dart';
import 'package:holdwise/features/records/presentation/pages/personal_records.dart';
import 'package:holdwise/features/records/presentation/pages/records.dart';
import 'package:holdwise/features/profile/presentation/pages/profile_screen.dart';
import 'package:holdwise/features/schedule_screen/presentation/pages/schedule_screen.dart';
import 'package:holdwise/features/sensors/presentation/pages/sensors_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/constants.dart';

class RoleBasedNavBar extends StatelessWidget {
  const RoleBasedNavBar({Key? key}) : super(key: key);

  ItemConfig _buildNavItem({
    required IconData icon,
    required String title,
  }) {
    return ItemConfig(
      icon: Icon(icon),
      title: title,
      activeColorSecondary: const Color.fromARGB(255, 187, 151, 240),
      // activeColorSecondary: AppColors.tertiary500,
      activeForegroundColor: const Color.fromARGB(255, 187, 151, 240),
      // activeForegroundColor: AppColors.tertiary500,
      inactiveForegroundColor: AppColors.gray100,
    );
  }

  List<PersistentTabConfig> _getTabs(String role, User user) {
    return switch (role) {
      AppRoles.admin => [
          PersistentTabConfig(
            screen: DashboardScreen(),
            item: _buildNavItem(
              icon: Icons.dashboard,
              title: "Dashboard",
            ),
          ),
          PersistentTabConfig(
            screen: ManageSpecialistsScreen(),
            item: _buildNavItem(
              icon: Icons.manage_accounts,
              title: "Users",
            ),
          ),
          PersistentTabConfig(
            screen: SettingsScreen(),
            item: _buildNavItem(
              icon: Icons.settings,
              title: "Settings",
            ),
          ),
        ],
      AppRoles.patient => [
          PersistentTabConfig(
            screen: DashboardScreen(),
            item: _buildNavItem(
              icon: Icons.home,
              title: "Dashboard",
            ),
          ),
          PersistentTabConfig(
            screen: RecordsScreen(),
            item: _buildNavItem(
              icon: Icons.medical_services,
              title: "Records",
            ),
          ),
          PersistentTabConfig(
            screen: FullScreenCamera(),
            item: _buildNavItem(
              icon: Icons.camera,
              title: "Camera",
            ),
          ),
          PersistentTabConfig(
            screen: ExplorePage(),
            item: _buildNavItem(
              icon: Icons.explore,
              title: "Explore",
            ),
          ),
          PersistentTabConfig(
            screen: ProfileScreen(),
            item: _buildNavItem(
              icon: Icons.person,
              title: "Profile",
            ),
          ),
        ],
      AppRoles.specialist => [
          PersistentTabConfig(
            screen: DashboardScreen(),
            item: _buildNavItem(
              icon: Icons.dashboard,
              title: "Dashboard",
            ),
          ),
          PersistentTabConfig(
            screen: ScheduleScreen(),
            item: _buildNavItem(
              icon: Icons.schedule,
              title: "Schedule",
            ),
          ),
          PersistentTabConfig(
            screen: PersonalRecords(),
            item: _buildNavItem(
              icon: Icons.calendar_today,
              title: "Sensor",
            ),
          ),
          PersistentTabConfig(
            screen: ProfileScreen(),
            item: _buildNavItem(
              icon: Icons.person,
              title: "Profile",
            ),
          ),
          PersistentTabConfig(
            screen: FutureBuilder<ChatUser>(
              future: ChatUser.fromFirebase(user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error loading user"));
                } else if (!snapshot.hasData) {
                  return Center(child: Text("No user data"));
                }
                return ChatScreen(user: snapshot.data!);
              },
            ),
            item: _buildNavItem(
              icon: Icons.message,
              title: "Messages",
            ),
          ),
        ],
      _ => [
          PersistentTabConfig(
            screen: HelpScreen(),
            item: _buildNavItem(
              icon: Icons.help,
              title: "Help",
            ),
          ),
        ]
    };
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current theme mode
    final isDarkMode = context.watch<ThemeCubit>().state == ThemeMode.dark;

    // Apply app colors based on the theme
    final Color backgroundColor =
        isDarkMode ? AppColors.primary700 : AppColors.primary500;
    final Gradient? backgroundGradient = Gradients.tertiaryGradient;

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;

    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;

    return PersistentTabView(
      drawer: RoleBasedDrawer(role: role),
      tabs: _getTabs(role, user!),
      navBarBuilder: (navBarConfig) => Style13BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: backgroundColor, // Fallback color
          gradient: backgroundGradient, // Apply gradient if needed
          // add a border radius to the top left and top right corners of the navbar
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .2),
              blurRadius: 8,
              spreadRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
      backgroundColor:
          Colors.transparent, // Allows gradient or custom color to show
      navBarHeight: 70, // Adjust height if needed
      popAllScreensOnTapOfSelectedTab: true, // Optional behavior
    );
  }
}
