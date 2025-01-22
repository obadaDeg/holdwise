import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/cubit/auth_cubit.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Auth Screen")),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );

            // modal in future
          }
        },
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Logged in as: ${state.user.email}"),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().logout(),
                    child: const Text("Logout"),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                if (state is AuthLoading)
                  const CircularProgressIndicator()
                else ...[
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                    child: const Text("Login"),
                  ),
                  ElevatedButton(
                    onPressed: () => context.read<AuthCubit>().signup(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        ),
                    child: const Text("Sign Up"),
                  ),
                ]
              ],
            ),
          );
        },
      ),
    );
  }
}
