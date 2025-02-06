import 'package:flutter/material.dart';
import 'package:holdwise/common/widgets/role_based_appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: RoleBasedAppBar(title: 'About HoldWise', displayActions: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Icon or Illustration
            Icon(Icons.health_and_safety, size: 80, color: Colors.blueAccent),
            const SizedBox(height: 20),

            // Title
            Text(
              'HoldWise: Smart Posture Assistant',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Description
            Text(
              'HoldWise helps you maintain a healthy posture while using mobile devices. '
              'Using advanced pose estimation technology, the app monitors your device usage, '
              'provides real-time feedback, and generates posture reports to prevent long-term health issues.',
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Features Section
            _buildFeatureItem(Icons.analytics, 'Real-time Posture Monitoring'),
            _buildFeatureItem(Icons.report, 'Detailed Posture Reports'),
            _buildFeatureItem(Icons.settings, 'Customizable Alerts'),
            _buildFeatureItem(Icons.fitness_center, 'Posture Correction Exercises'),
            _buildFeatureItem(Icons.security, 'Parental Controls'),

            const SizedBox(height: 20),

            // Footer
            Text(
              'Developed by Obada Daghlas\n© 2025 HoldWise',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each feature item
  Widget _buildFeatureItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title, style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
