import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/typography.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final bool isAdmin;
  final bool isSpecialist;
  final bool isPatient;

  const ProtectedRoute(
      {required this.child,
      this.isAdmin = false,
      this.isSpecialist = false,
      this.isPatient = false,
      Key? key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.4;

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          if (((isAdmin && state.isAdmin) ||
              (isSpecialist && state.isSpecialist) ||
              (isPatient && state.isPatient))) {
            return child;
          }
        }

        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/not_authinticated.png',
                    height: imageSize,
                    width: imageSize,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Authentication Required',
                    style: AppTypography.header4(context).copyWith(
                      color: AppColors.gray400,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You need to log in to access this page.',
                    style: AppTypography.body1(context).copyWith(
                      color: AppColors.gray600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.login,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 32,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppColors.primary500,
                    ),
                    child: Text(
                      'Go to Login',
                      style: AppTypography.button(context).copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
