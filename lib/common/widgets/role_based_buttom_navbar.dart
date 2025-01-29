import 'package:flutter/material.dart';
import 'package:holdwise/features/appointments/presentation/pages/appointments_screen.dart';
import 'package:holdwise/features/dashboard/presentation/pages/dashboard.dart';
import 'package:holdwise/features/help_screen/presentation/pages/help_screen.dart';
import 'package:holdwise/features/manage_specialist/presentation/pages/manage_specialists.dart';
import 'package:holdwise/features/medical_records/presentation/pages/medical_records.dart';
import 'package:holdwise/features/messages_screen/presentation/pages/messages_screen.dart';
import 'package:holdwise/features/profile/presentation/pages/profile_screen.dart';
import 'package:holdwise/features/schedule_screen/presentation/pages/schedule_screen.dart';
import 'package:holdwise/features/settings_screen/presentation/pages/settings_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class RoleBasedNavBar extends StatelessWidget {
  final String role; // Role: admin, patient, specialist

  const RoleBasedNavBar({Key? key, required this.role}) : super(key: key);

  List<PersistentTabConfig> _getTabs(String role) {
    switch (role) {
      case 'admin':
        return [
          PersistentTabConfig(
            screen: DashboardScreen(),
            item: ItemConfig(
              icon: Icon(Icons.dashboard),
              title: "Dashboard",
            ),
          ),
          PersistentTabConfig(
            screen: ManageSpecialistsScreen(),
            item: ItemConfig(
              icon: Icon(Icons.manage_accounts),
              title: "Users",
            ),
          ),
          PersistentTabConfig(
            screen: SettingsScreen(),
            item: ItemConfig(
              icon: Icon(Icons.settings),
              title: "Settings",
            ),
          ),
        ];
      case 'patient':
        return [
          PersistentTabConfig(
            screen: ProfileScreen(),
            item: ItemConfig(
              icon: Icon(Icons.person),
              title: "Profile",
            ),
          ),
          PersistentTabConfig(
            screen: AppointmentsScreen(),
            item: ItemConfig(
              icon: Icon(Icons.calendar_today),
              title: "Appointments",
            ),
          ),
          PersistentTabConfig(
            screen: MedicalRecordsScreen(),
            item: ItemConfig(
              icon: Icon(Icons.medical_services),
              title: "Records",
            ),
          ),
        ];
      case 'specialist':
        return [
          PersistentTabConfig(
            screen: ScheduleScreen(),
            item: ItemConfig(
              icon: Icon(Icons.schedule),
              title: "Schedule",
            ),
          ),
          PersistentTabConfig(
            screen: ProfileScreen(),
            item: ItemConfig(
              icon: Icon(Icons.person),
              title: "Profile",
            ),
          ),
          PersistentTabConfig(
            screen: MessagesScreen(),
            item: ItemConfig(
              icon: Icon(Icons.message),
              title: "Messages",
            ),
          ),
        ];
      default:
        return [
          PersistentTabConfig(
            screen: HelpScreen(),
            item: ItemConfig(
              icon: Icon(Icons.help),
              title: "Help",
            ),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _getTabs(role),
      navBarBuilder: (navBarConfig) => Style13BottomNavBar(
        navBarConfig: navBarConfig,
      ),
    );
  }
}
