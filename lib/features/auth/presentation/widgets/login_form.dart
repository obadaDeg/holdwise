import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/app/utils/form_validators.dart';
import 'package:holdwise/common/widgets/custom_input_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _onLogin(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      // Trigger the login method in AuthCubit
      context.read<AuthCubit>().login(
            _emailController.text,
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenPadding = MediaQuery.of(context).size.width * .005;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        }
      },
      child: Padding(
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
                  } else if (!isValidEmail(value)) {
                    return 'Please enter a valid email';
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
                  } else if (!isValidPassword(value)) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              // Login button
              ElevatedButton(
                onPressed: () => _onLogin(context),
                child: const Text('Login'),
              ),
              // text to navigate to signup page
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.signup);
                    },
                    child: const Text('Sign up'),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Forgot password link
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                },
                child: Text(
                  'Forgot your password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.01),
              Divider(
                indent: screenPadding * 0.5,
                color: AppColors.gray600,
              ),
              SizedBox(height: screenHeight * 0.01),
              // Google Sign-In button
              ElevatedButton.icon(
                onPressed: () {
                  print('Sign in with Google');
                },
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Sign in with Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
