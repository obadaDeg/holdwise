import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/typography.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';

/// ---------------------
/// Profile Screen
/// ---------------------
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get role and user data from AuthCubit.
    final state = context.read<AuthCubit>().state;
    final role = state is AuthAuthenticated ? state.role : AppRoles.patient;
    final user = state is AuthAuthenticated ? state.user : null;

    return Scaffold(
      appBar: RoleBasedAppBar(
        title: "${user?.displayName?.split(" ")[0] ?? 'User'}'s Profile",
        selectedActions: [
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.white),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.profileSettings);
            },
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
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}

/// ---------------------
/// Profile Header
/// ---------------------
class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final String role;

  const ProfileHeader({Key? key, required this.user, required this.role})
      : super(key: key);

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
            backgroundImage: user?.photoURL != null
                ? NetworkImage(user!.photoURL)
                : null,
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

/// ---------------------
/// Profile Actions Widget
/// ---------------------
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
            _buildButton(
                context, 'Manage Users', Icons.admin_panel_settings, () {}),
        ],
      ),
    );
  }

  Widget _buildButton(
      BuildContext context, String text, IconData icon, VoidCallback onPressed) {
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

/// ---------------------
/// Profile Content Widget
/// ---------------------
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

  // Choose which content widget to display based on the role.
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

/// ---------------------
/// Specialist Profile Content Widget
/// ---------------------
class SpecialistProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Certificates Section
        Text(
          'Certificates',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.school, color: AppColors.primary500),
          title: Text('Board Certified in Neurology'),
          subtitle: Text('Certified by XYZ Board, 2018'),
        ),
        SizedBox(height: 16),
        // Advices/Posts Section
        Text(
          'Advices & Posts',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.edit, color: AppColors.primary500),
          title: Text('Improving Patient Care'),
          subtitle: Text('5 advices/posts published'),
        ),
        ListTile(
          // 
          leading: Icon(Icons.edit, color: AppColors.primary500),
          title: Text('New Treatment Methods'),
          subtitle: Text('3 advices/posts published'),
        ),
      ],
    );
  }
}

/// ---------------------
/// Admin Profile Content Widget (Optional)
/// ---------------------
class AdminProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Management Section
        Text(
          'User Management',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.admin_panel_settings, color: AppColors.primary500),
          title: Text('Manage user accounts and permissions'),
        ),
        SizedBox(height: 16),
        // System Analytics Section
        Text(
          'System Analytics',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.bar_chart, color: AppColors.primary500),
          title: Text('View system usage and performance metrics'),
        ),
      ],
    );
  }
}

/// ---------------------
/// Patient Profile Content Widget with Enhanced Features
/// ---------------------
class PatientProfileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing Preferences Section
        Text(
          'Preferences',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.favorite, color: AppColors.primary500),
          title: Text('Dietary Preferences'),
          subtitle: Text('Vegetarian, Gluten-Free'),
        ),
        SizedBox(height: 16),
        // Existing Medical Data Section
        Text(
          'Medical Data',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.medical_services, color: AppColors.primary500),
          title: Text('Health Information'),
          subtitle: Text('Blood Type: O, No known allergies'),
        ),
        SizedBox(height: 16),
        // Existing Saved Posts Section
        Text(
          'Saved Posts',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ListTile(
          leading: Icon(Icons.bookmark, color: AppColors.primary500),
          title: Text('Healthy Living Tips'),
          subtitle: Text('Saved on 10/02/2025'),
        ),
        ListTile(
          leading: Icon(Icons.bookmark, color: AppColors.primary500),
          title: Text('Exercise Routines'),
          subtitle: Text('Saved on 09/02/2025'),
        ),
        SizedBox(height: 16),
        // ---------------
        // New Feature: Posture Statistics
        // ---------------
        Text(
          'Posture Statistics',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        PostureStatisticsCard(),
        SizedBox(height: 16),
        // ---------------
        // New Feature: Activity Breakdown
        // ---------------
        Text(
          'Activity Breakdown',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        ActivityBreakdownCard(),
        SizedBox(height: 16),
        // ---------------
        // New Feature: Posture Improvement Tips
        // ---------------
        Text(
          'Posture Improvement Tips',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        PostureImprovementTipsCard(),
        SizedBox(height: 16),
        // ---------------
        // New Feature: Achievements and Badges
        // ---------------
        Text(
          'Achievements & Badges',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        AchievementsBadgesCard(),
        SizedBox(height: 16),
        // ---------------
        // New Feature: Device Usage Insights
        // ---------------
        Text(
          'Device Usage Insights',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        DeviceUsageInsightsCard(),
        SizedBox(height: 16),
        // ---------------
        // New Feature: Health Risk Assessment
        // ---------------
        Text(
          'Health Risk Assessment',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        HealthRiskAssessmentCard(),
        SizedBox(height: 16),
        // ---------------
        // New Feature: Goals & Challenges
        // ---------------
        Text(
          'Goals & Challenges',
          style: AppTypography.header6(context),
        ),
        SizedBox(height: 8),
        GoalsChallengesCard(),
        SizedBox(height: 16),
      ],
    );
  }
}

/// ---------------------
/// New Widgets for Enhanced Features
/// ---------------------

/// Posture Statistics Card
class PostureStatisticsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Integrate your chart widget (e.g., from posture_score_card.dart)
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Posture Score History', style: AppTypography.header6(context)),
            SizedBox(height: 8),
            // Replace this container with your chart widget.
            Container(
              height: 150,
              color: AppColors.primary100,
              child: Center(child: Text('Chart goes here')),
            ),
          ],
        ),
      ),
    );
  }
}

/// Activity Breakdown Card
class ActivityBreakdownCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Integrate your activity breakdown chart (e.g., from activity_breakdown.dart)
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Activity Breakdown', style: AppTypography.header6(context)),
            SizedBox(height: 8),
            // Replace with your pie chart or percentage summary.
            Container(
              height: 150,
              color: AppColors.primary100,
              child: Center(child: Text('Pie chart goes here')),
            ),
          ],
        ),
      ),
    );
  }
}

/// Posture Improvement Tips Card
class PostureImprovementTipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Provide tips and a navigation option to exercises or the camera screen.
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Posture Improvement Tips', style: AppTypography.header6(context)),
            SizedBox(height: 8),
            Text('Tip: Take regular breaks and adjust your posture during prolonged device usage.'),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.dashboard, arguments: 2);
              },
              child: Text('View Exercises'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Achievements & Badges Card
class AchievementsBadgesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Display achievements and badges (e.g., data from streak_badges.dart).
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.emoji_events, color: AppColors.primary500, size: 40),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Good Posture Streak', style: AppTypography.header6(context)),
                Text('7 days', style: AppTypography.body2(context)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Device Usage Insights Card
class DeviceUsageInsightsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Integrate your device usage insights (e.g., using violation_scatter_chart.dart).
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Usage Insights', style: AppTypography.header6(context)),
            SizedBox(height: 8),
            // Replace with your scatter chart.
            Container(
              height: 150,
              color: AppColors.primary100,
              child: Center(child: Text('Scatter chart goes here')),
            ),
          ],
        ),
      ),
    );
  }
}

/// Health Risk Assessment Card
class HealthRiskAssessmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Integrate your health risk graph (e.g., from health_risk_graph.dart).
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Health Risk Assessment', style: AppTypography.header6(context)),
            SizedBox(height: 8),
            // Replace with your health risk graph.
            Container(
              height: 150,
              color: AppColors.primary100,
              child: Center(child: Text('Health risk graph goes here')),
            ),
          ],
        ),
      ),
    );
  }
}

/// Goals & Challenges Card
class GoalsChallengesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // A simple progress tracker for setting and tracking posture goals.
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Goals & Challenges', style: AppTypography.header6(context)),
            SizedBox(height: 8),
            Text('Daily Posture Goal Progress:'),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: 0.5, // Example progress value
              backgroundColor: AppColors.primary100,
              valueColor: AlwaysStoppedAnimation(AppColors.primary500),
            ),
            SizedBox(height: 8),
            Text('Keep up the good work!'),
          ],
        ),
      ),
    );
  }
}
