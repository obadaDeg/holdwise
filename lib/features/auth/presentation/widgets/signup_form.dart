import 'package:flutter/material.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/common/widgets/custom_input_field.dart';

/// A signup form widget for the authentication page.
/// Includes fields for email, phone number, password, and password confirmation.
class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _signup() {
    if (_formKey.currentState?.validate() ?? false) {
      // Handle signup logic (e.g., call FirebaseAuth or AuthCubit)
      print('Signup with email: ${_emailController.text}, phone: ${_phoneController.text}, password: ${_passwordController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenPadding = MediaQuery.of(context).size.width * 0.005;
    print("${screenPadding} ${screenHeight}");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenPadding),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email input field
            CustomTextField(
              controller: _emailController,
              hintText: 'Enter your email',
              icon: Icons.email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            // Phone number input field
            CustomTextField(
              controller: _phoneController,
              hintText: 'Enter your phone number',
              icon: Icons.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (!RegExp(r'^\+?[0-9]{10,13}$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            // Password input field
            CustomTextField(
              controller: _passwordController,
              hintText: 'Enter your password',
              icon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.02),
            // Confirm password input field
            CustomTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm your password',
              icon: Icons.lock_outline,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                } else if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: screenHeight * 0.03),
            // Signup button
            ElevatedButton(
              onPressed: _signup,
              child: const Text('Sign Up'),
            ),
            SizedBox(height: screenHeight * 0.01),
            // Redirect to login page
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.login);
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                print('Sign up with Google');
              },
              icon: const Icon(Icons.g_mobiledata),
              label: const Text('Sign up with Google'),
            ),
          ],
        ),
      ),
    );
  }
}
