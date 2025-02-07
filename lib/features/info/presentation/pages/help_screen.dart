import 'package:flutter/material.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/features/info/presentation/widgets/faq_accordion.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final String supportEmail = 'animayoloteer@gmail.com';
  final String whatsappNumber = '+970594408329';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Frequently Asked Questions'),
            const SizedBox(height: 10),

            const FaqAccordion(
              question: 'How do I create an account?',
              answer: 'Go to the sign-up page and enter your name, email, and password. Then, verify your email to activate your account.',
            ),
            const FaqAccordion(
              question: 'How can I reset my password?',
              answer: 'On the login screen, tap "Forgot Password?" and follow the steps to reset it via email.',
            ),
            const FaqAccordion(
              question: 'How do I contact support?',
              answer: 'Go to "Help & Support" in the settings menu, where you’ll find multiple ways to reach us.',
            ),
            const FaqAccordion(
              question: 'Can I use the app on multiple devices?',
              answer: 'Yes, you can log in to your account on different devices and sync your data.',
            ),

            const SizedBox(height: 20),
            _buildSectionTitle('Need More Help?'),
            const SizedBox(height: 8),
            const Text(
              'If you have additional questions or need further assistance, feel free to reach out to our support team.',
              style: TextStyle(fontSize: 14, color: AppColors.black),
            ),
            const SizedBox(height: 10),

            _buildContactButton(
              icon: Icons.email,
              color: Colors.blue,
              title: 'Email Support',
              subtitle: supportEmail,
              onTap: () => _launchEmail(),
            ),
            _buildContactButton(
              icon: Icons.phone,
              color: AppColors.success,
              title: 'Call Support',
              subtitle: '+970 594 408 329',
              onTap: () {
                final Uri phoneUri = Uri(scheme: 'tel', path: '+970594408329');
                launchUrl(phoneUri);
              },
            ),
            _buildContactButton(
              icon: Icons.chat,
              color: AppColors.success,
              title: 'WhatsApp Support',
              subtitle: whatsappNumber,
              onTap: () => _launchWhatsApp(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildContactButton({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: supportEmail,
      queryParameters: {'subject': 'Support Request', 'body': 'Hello, I need help with...'},
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  void _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse(
        "https://wa.me/${whatsappNumber.replaceAll('+', '')}?text=Hello, I need support.");

    try {
      await launchUrl(whatsappUri);
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }
}
