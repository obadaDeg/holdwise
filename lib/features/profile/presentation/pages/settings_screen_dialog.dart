import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/cubits/preferences_cubit/preferences_cubit.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/features/profile/presentation/widgets/accordion.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _showSimpleDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Close", style: Theme.of(context).textTheme.labelLarge),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<PreferencesCubit, PreferencesState>(
      builder: (context, state) {
        return Scaffold(
          appBar: const RoleBasedAppBar(
            title: "Settings",
            displayActions: false,
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ========= Account Section =========
              Accordion(
                leadingIcon: Icons.person,
                title: "Account",
                children: [
                  ListTile(
                    title: Text("Change Password"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSimpleDialog(context, "Change Password", "Change your password here."),
                  ),
                  ListTile(
                    title: Text("Content Settings"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSimpleDialog(context, "Content Settings", "Adjust your content settings."),
                  ),
                  ListTile(
                    title: Text("Social"),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSimpleDialog(context, "Social", "Manage your social connections."),
                  ),
                  ListTile(
                    title: Text("Language"),
                    trailing: DropdownButton<String>(
                      value: state.selectedLanguage,
                      underline: Container(),
                      items: const [
                        DropdownMenuItem(value: "English", child: Text("English")),
                        DropdownMenuItem(value: "Arabic", child: Text("Arabic")),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          context.read<PreferencesCubit>().updateSelectedLanguage(value);
                        }
                      },
                    ),
                  ),
                  // Nested Privacy and Security section
                  Accordion(
                    title: "Privacy and Security",
                    children: [
                      ListTile(
                        title: Text("Two-Factor Authentication"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showSimpleDialog(context, "Two-Factor Authentication", "Configure 2FA."),
                      ),
                      ListTile(
                        title: Text("Login Alerts"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showSimpleDialog(context, "Login Alerts", "Manage your login alerts."),
                      ),
                    ],
                  ),
                ],
              ),

              // ========= Notifications Section =========
              Accordion(
                leadingIcon: Icons.notifications,
                title: "Notifications",
                children: [
                  SwitchListTile(
                    title: Text("New for you"),
                    value: state.notifNewForYou,
                    onChanged: (bool value) => context.read<PreferencesCubit>().updateNotifNewForYou(value),
                  ),
                  SwitchListTile(
                    title: Text("Account activity"),
                    value: state.notifAccountActivity,
                    onChanged: (bool value) => context.read<PreferencesCubit>().updateNotifAccountActivity(value),
                  ),
                ],
              ),

              // ========= Appearance Section =========
              Accordion(
                leadingIcon: Icons.color_lens,
                title: "Appearance",
                children: [
                  SwitchListTile(
                    title: Text("Dark Mode"),
                    value: state.darkMode,
                    onChanged: (bool value) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ],
              ),

              // ========= Sign Out Button =========
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => BlocProvider.of<AuthCubit>(context).logout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "SIGN OUT",
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.onPrimary,
                      letterSpacing: 2.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
