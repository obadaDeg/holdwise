import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/cubits/preferences_cubit/preferences_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/typography.dart';

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

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        content: Text(content, style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: Theme.of(context).textTheme.labelLarge),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm();
            },
            child: Text("Confirm", style: Theme.of(context).textTheme.labelLarge),
          )
        ],
      ),
    );
  }

  void _logout(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).logout();
    Navigator.of(context).pop();
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
              // ========= Header =========
              Text("Settings", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 20),

              // ========= Account Section =========
              ExpansionTile(
                leading: Icon(Icons.person, color: colorScheme.primary),
                title: Text("Account", style: Theme.of(context).textTheme.headlineSmall),
                children: [
                  ListTile(
                    title: Text("Change Password", style: Theme.of(context).textTheme.bodyLarge),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSimpleDialog(context, "Change Password", "Change your password here."),
                  ),
                  ListTile(
                    title: Text("Content Settings", style: Theme.of(context).textTheme.bodyLarge),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSimpleDialog(context, "Content Settings", "Adjust your content settings."),
                  ),
                  ListTile(
                    title: Text("Social", style: Theme.of(context).textTheme.bodyLarge),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSimpleDialog(context, "Social", "Manage your social connections."),
                  ),
                  ListTile(
                    title: Text("Language", style: Theme.of(context).textTheme.bodyLarge),
                    trailing: DropdownButton<String>(
                      value: state.selectedLanguage,
                      underline: Container(), // Removes the default underline
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
                  ExpansionTile(
                    title: Text("Privacy and Security", style: Theme.of(context).textTheme.bodyLarge),
                    children: [
                      ListTile(
                        title: Text("Two-Factor Authentication", style: Theme.of(context).textTheme.bodyLarge),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showSimpleDialog(context, "Two-Factor Authentication", "Configure 2FA."),
                      ),
                      ListTile(
                        title: Text("Login Alerts", style: Theme.of(context).textTheme.bodyLarge),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showSimpleDialog(context, "Login Alerts", "Manage your login alerts."),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ========= Notifications Section =========
              ExpansionTile(
                leading: Icon(Icons.notifications, color: colorScheme.primary),
                title: Text("Notifications", style: Theme.of(context).textTheme.headlineSmall),
                children: [
                  SwitchListTile(
                    title: Text("New for you", style: Theme.of(context).textTheme.bodyLarge),
                    value: state.notifNewForYou,
                    onChanged: (bool value) => context.read<PreferencesCubit>().updateNotifNewForYou(value),
                  ),
                  SwitchListTile(
                    title: Text("Account activity", style: Theme.of(context).textTheme.bodyLarge),
                    value: state.notifAccountActivity,
                    onChanged: (bool value) => context.read<PreferencesCubit>().updateNotifAccountActivity(value),
                  ),
                  SwitchListTile(
                    title: Text("Opportunity", style: Theme.of(context).textTheme.bodyLarge),
                    value: state.notifOpportunity,
                    onChanged: (bool value) => context.read<PreferencesCubit>().updateNotifOpportunity(value),
                  ),
                  SwitchListTile(
                    title: Text("Promotional", style: Theme.of(context).textTheme.bodyLarge),
                    value: state.notifPromotional,
                    onChanged: (bool value) => context.read<PreferencesCubit>().updateNotifPromotional(value),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ========= Appearance Section =========
              ExpansionTile(
                leading: Icon(Icons.color_lens, color: colorScheme.primary),
                title: Text("Appearance", style: Theme.of(context).textTheme.headlineSmall),
                children: [
                  SwitchListTile(
                    title: Text("Dark Mode", style: Theme.of(context).textTheme.bodyLarge),
                    value: state.darkMode,
                    onChanged: (bool value) {
                      context.read<PreferencesCubit>().updateDarkMode(value);
                      // Optionally, notify your ThemeCubit to change the app theme.
                    },
                  ),
                  // Nested theme customization options
                  ExpansionTile(
                    title: Text("Customize Theme", style: Theme.of(context).textTheme.bodyLarge),
                    children: [
                      ListTile(
                        title: Text("Primary Color", style: Theme.of(context).textTheme.bodyLarge),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showSimpleDialog(context, "Primary Color", "Select a primary color."),
                      ),
                      ListTile(
                        title: Text("Accent Color", style: Theme.of(context).textTheme.bodyLarge),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => _showSimpleDialog(context, "Accent Color", "Select an accent color."),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ========= Holdwise Settings Section =========
              ExpansionTile(
                leading: Icon(Icons.settings, color: colorScheme.primary),
                title: Text("Holdwise Settings", style: Theme.of(context).textTheme.headlineSmall),
                children: [
                  SwitchListTile(
                    title: Text("Auto-Sync Data", style: Theme.of(context).textTheme.bodyLarge),
                    subtitle: Text("Automatically sync your data with Holdwise servers", style: Theme.of(context).textTheme.bodyMedium),
                    value: state.holdwiseAutoSync,
                    onChanged: (bool value) => context.read<PreferencesCubit>().updateHoldwiseAutoSync(value),
                  ),
                  ListTile(
                    title: Text("Sync Now", style: Theme.of(context).textTheme.bodyLarge),
                    trailing: const Icon(Icons.sync),
                    onTap: () {
                      _showConfirmationDialog(
                        context,
                        title: "Sync Settings",
                        content: "Do you want to sync your data now?",
                        onConfirm: () {
                          // Insert your sync functionality here.
                          _showSimpleDialog(context, "Sync", "Data sync initiated.");
                        },
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Data Backup", style: Theme.of(context).textTheme.bodyLarge),
                    trailing: const Icon(Icons.backup),
                    onTap: () {
                      _showConfirmationDialog(
                        context,
                        title: "Data Backup",
                        content: "Do you want to backup your data?",
                        onConfirm: () {
                          // Insert your backup functionality here.
                          _showSimpleDialog(context, "Backup", "Data backup started.");
                        },
                      );
                    },
                  ),
                  // Nested advanced options
                  ExpansionTile(
                    title: Text("Advanced Options", style: Theme.of(context).textTheme.bodyLarge),
                    children: [
                      SwitchListTile(
                        title: Text("Enable Developer Mode", style: Theme.of(context).textTheme.bodyLarge),
                        value: state.developerMode,
                        onChanged: (bool value) => context.read<PreferencesCubit>().updateDeveloperMode(value),
                      ),
                      ListTile(
                        title: Text("Reset API Keys", style: Theme.of(context).textTheme.bodyLarge),
                        trailing: const Icon(Icons.refresh),
                        onTap: () {
                          _showConfirmationDialog(
                            context,
                            title: "Reset API Keys",
                            content: "Are you sure you want to reset your API keys?",
                            onConfirm: () {
                              // Insert your API key reset functionality here.
                              _showSimpleDialog(context, "API Keys", "Your API keys have been reset.");
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // ========= Sign Out Button =========
              Center(
                child: ElevatedButton(
                  onPressed: () => _logout(context),
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
