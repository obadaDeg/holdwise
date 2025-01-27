import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/features/auth/presentation/widgets/auth_card.dart';

/// The AuthPage is a generalized scaffold for authentication.
/// It takes a title and a child widget, which can be a login form, signup form,
/// password reset form, or any other auth-related content.
class AuthPage extends StatelessWidget {
  final String title;
  final Widget cardContent;

  const AuthPage({required this.title, required this.cardContent, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        automaticallyImplyLeading: false,
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isLightMode = themeMode == ThemeMode.light;
              return IconButton(
                icon: Icon(
                  isLightMode ? Icons.light_mode : Icons.dark_mode,
                  color: isLightMode ? AppColors.primary500 : AppColors.gray500,
                ),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.getPadding(context) * .6,
            vertical: Constants.getPadding(context),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App logo or branding
              BlocBuilder<ThemeCubit, ThemeMode>(
                builder: (context, themeMode) {
                  final backgroundColor = themeMode == ThemeMode.light
                      ? Colors.transparent
                      : Colors.white;

                  return CircleAvatar(
                    radius: 50,
                    backgroundColor: backgroundColor,
                    child: Image.asset('assets/icons/holdwise_icon.png'),
                  );
                },
              ),
              const SizedBox(height: 20),
              // Title of the current page
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Auth card that will render specific content
              AuthCard(child: cardContent),
            ],
          ),
        ),
      ),
    );
  }
}
