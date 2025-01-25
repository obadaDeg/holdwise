import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthPage extends StatelessWidget {
  final Widget card;

  const AuthPage({required this.card, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor, // Dynamic theme color
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent, // Transparent background
                child: SvgPicture.asset(
                  "assets/icons/holdwise_icon.svg",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "HoldWise",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "Smart Posture, Healthy Future",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),
              card,
            ],
          ),
        ),
      ),
    );
  }
}
