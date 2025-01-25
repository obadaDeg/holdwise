import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/common/widgets/custom_input_field.dart';

class SignupCard extends StatelessWidget {
  const SignupCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushNamed(context, '/home');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              CustomTextField(
                controller: emailController,
                hintText: 'Email',
                icon: Icons.email,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: passwordController,
                hintText: 'Password',
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: state is AuthLoading
                    ? null
                    : () {
                        context.read<AuthCubit>().login(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                            );
                      },
                child: state is AuthLoading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Text("Sign up"),
              ),
            ],
          ),
        );
      },
    );
  }
}
