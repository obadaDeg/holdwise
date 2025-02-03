import 'package:flutter/material.dart';
import 'package:holdwise/app/utils/form_validators.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';
import 'package:holdwise/common/widgets/custom_input_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _darkMode = false;
  List<bool> _expanded = [true, false, false];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _darkMode = prefs.getBool('dark_mode') ?? false;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text);
    await prefs.setString('user_email', _emailController.text);
    await prefs.setBool('dark_mode', _darkMode);
  }

  void _logout(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).logout();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RoleBasedAppBar(title: 'Settings', displayActions: false),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildAccordionSection(
              index: 0,
              title: 'Profile Settings',
              icon: Icons.person,
              content: _buildProfileSettings(),
            ),
            const SizedBox(height: 10),
            _buildAccordionSection(
              index: 1,
              title: 'Account Preferences',
              icon: Icons.settings,
              content: _buildAccountPreferences(),
            ),
            const SizedBox(height: 10),
            _buildAccordionSection(
              index: 2,
              title: 'Security',
              icon: Icons.security,
              content: _buildSecuritySection(),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Reusable Accordion Builder
  Widget _buildAccordionSection({
    required int index,
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: ExpansionPanelList(
        elevation: 0,
        expansionCallback: (int i, bool isExpanded) {
          setState(() => _expanded[index] = !_expanded[index]);
        },
        children: [
          ExpansionPanel(
            backgroundColor: Theme.of(context).colorScheme.surface,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
                title: Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _expanded[index] ? content : const SizedBox.shrink(),
              ),
            ),
            isExpanded: _expanded[index],
            canTapOnHeader: true,
          ),
        ],
      ),
    );
  }

  /// 🔹 Profile Settings Content
  Widget _buildProfileSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          controller: _nameController,
          icon: Icons.person,
          hintText: 'Full Name',
        ),
        const SizedBox(height: 10),
        CustomTextField(
          controller: _emailController,
          hintText: 'Email Address',
          icon: Icons.email,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email address';
            } else if (!isValidEmail(value)) {
              return 'Enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _savePreferences,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  /// 🔹 Account Preferences Content
  Widget _buildAccountPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SwitchListTile(
          title: const Text('Dark Mode'),
          value: _darkMode,
          onChanged: (bool value) {
            setState(() => _darkMode = value);
            _savePreferences();
          },
        ),
      ],
    );
  }

  /// 🔹 Security Section Content
  Widget _buildSecuritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
