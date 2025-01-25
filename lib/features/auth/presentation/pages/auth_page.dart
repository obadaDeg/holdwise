import 'package:flutter/material.dart';
import 'package:holdwise/features/auth/presentation/widgets/login_card.dart';
import 'package:holdwise/features/auth/presentation/widgets/signup_card.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('data'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  } 
}