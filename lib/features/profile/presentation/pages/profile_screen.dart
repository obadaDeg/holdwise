import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/typography.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final role = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).role
        : AppRoles.patient;

    final user = context.read<AuthCubit>().state is AuthAuthenticated
        ? (context.read<AuthCubit>().state as AuthAuthenticated).user
        : null;

    return Scaffold(
      appBar: RoleBasedAppBar(
        title: "${user?.displayName?.split(" ")[0]}'s Profile",
        selectedActions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(user: user, role: role),
            SizedBox(height: 10),
            ProfileActions(role: role),
            SizedBox(height: 10),
            ProfileContent(role: role),
          ],
        ),
      ),
    );
  }
}

// ProfileHeader Widget
class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final String role;

  const ProfileHeader({Key? key, required this.user, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary500, AppColors.primary700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL) : null,
            child: user?.photoURL == null
                ? Icon(Icons.person, size: 50, color: AppColors.white)
                : null,
          ),
          SizedBox(height: 10),
          Text(
            user?.displayName ?? 'User',
            style: AppTypography.header5(context).copyWith(color: AppColors.white),
          ),
          Text(
            role.toUpperCase(),
            style: AppTypography.body2(context).copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}

// ProfileActions Widget
class ProfileActions extends StatelessWidget {
  final String role;

  const ProfileActions({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(context, 'Edit Profile', Icons.edit, () {}),
          if (role == AppRoles.specialist)
            _buildButton(context, 'View Patients', Icons.people, () {}),
          if (role == AppRoles.admin)
            _buildButton(context, 'Manage Users', Icons.admin_panel_settings, () {}),
        ],
      ),
    );
  }

  Widget _buildButton(BuildContext context, String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(text, style: AppTypography.button(context)),
      onPressed: onPressed,
    );
  }
}

// ProfileContent Widget
class ProfileContent extends StatelessWidget {
  final String role;

  const ProfileContent({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _getProfileContent(role),
        ),
      ),
    );
  }

  Widget _getProfileContent(String role) {
    switch (role) {
      case AppRoles.specialist:
        return SpecialistProfileContent();
      case AppRoles.admin:
        return AdminProfileContent();
      default:
        return PatientProfileContent();
    }
  }
}

// SpecialistProfileContent Widget
class SpecialistProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildContent([
      'Qualifications: Certified Physiotherapist with 10 years of experience.',
      'Posts: 5 posts published.',
      'Current Patients: 25 patients currently under care.',
    ]);
  }
}

// AdminProfileContent Widget
class AdminProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildContent([
      'User Management: Manage user accounts and permissions.',
      'System Analytics: View system usage and performance metrics.',
    ]);
  }
}

// PatientProfileContent Widget
class PatientProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildContent([
      'Consultation History: 5 consultations completed.',
      'Posture Reports: 3 posture reports available.',
      'Recommendations: Follow the recommended exercises daily.',
    ]);
  }
}

Widget _buildContent(List<String> items) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: items.map((item) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        item,
      ),
    )).toList(),
  );
}
