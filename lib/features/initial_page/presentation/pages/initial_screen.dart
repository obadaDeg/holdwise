import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/typography.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HoldWise Logo with Dynamic Theme Support
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                final backgroundColor =
                    themeMode == ThemeMode.light ? Colors.transparent : Colors.white;

                return CircleAvatar(
                  radius: 50,
                  backgroundColor: backgroundColor,
                  child: Image.asset(
                    'assets/icons/holdwise_icon.png',
                    fit: BoxFit.contain,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // HoldWise Title
            Text(
              'HoldWise',
              style: AppTypography.header3(context).copyWith(
                color: AppColors.primary500,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Tagline
            Text(
              'Smart Posture, Healthy Future',
              style: AppTypography.header5(context).copyWith(
                color: AppColors.gray600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
            ),
          ],
        ),
      ),
    );
  }
}
