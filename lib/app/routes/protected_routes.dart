import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/app/config/colors.dart';
import 'package:holdwise/app/config/typography.dart';
import 'package:holdwise/features/initial_page/presentation/pages/initial_screen.dart';

class ProtectedRoute extends StatelessWidget {
  final Widget child;
  final bool isAdmin;
  final bool isSpecialist;
  final bool isPatient;
  final bool isAuthPage;

  const ProtectedRoute({
    required this.child,
    this.isAdmin = false,
    this.isSpecialist = false,
    this.isPatient = false,
    this.isAuthPage = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        debugPrint('Auth state: $state');

        if (state is AuthInitial) {
          BlocProvider.of<AuthCubit>(context).checkAuthStatus();
          return const InitialScreen();
        }

        if (state is AuthAuthenticated) {
          // Prevent authenticated users from accessing auth pages (e.g., Login, Signup)
          if (isAuthPage) {
            _navigateToDashboard(context);
            return const SizedBox();
          }

          // Grant access if role matches
          if ((isAdmin && state.role == AppRoles.admin) ||
              (isSpecialist && state.role == AppRoles.specialist) ||
              (isPatient && state.role == AppRoles.patient)) {
            return child;
          } else {
            _navigateToDashboard(context);
            return const SizedBox();
          }
        }

        if (state is AuthLoading || state is AuthLoggingOut) {
          return _loadingScreen(context);
        }

        if (state is AuthLoggedOut) {
          // If user is on an authentication page, allow access
          if (isAuthPage) {
            return child;
          } else {
            // Otherwise, redirect to login
            _navigateToLogin(context);
            return const SizedBox();
          }
        }

        return _authRequiredScreen(context);
      },
    );
  }

  /// Navigates to Dashboard safely
  void _navigateToDashboard(BuildContext context) {
    Future.microtask(() {
      if (context.mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      }
    });
  }

  /// Navigates to Login safely
  void _navigateToLogin(BuildContext context) {
    Future.microtask(() {
      if (context.mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  /// Loading screen with optional text
  Widget _loadingScreen(BuildContext context, {String? message}) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (message != null)
              Text(
                message,
                style: AppTypography.body1(context)
                    .copyWith(color: AppColors.gray600),
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary500),
            ),
          ],
        ),
      ),
    );
  }

  /// Screen shown when authentication is required
  Widget _authRequiredScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/icons/not_authenticated.png',
                height: 150,
                width: 150,
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
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                  style: AppTypography.button(context)
                      .copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
