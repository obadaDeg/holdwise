import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holdwise/app/routes/protected_routes.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/features/auth/presentation/pages/auth_page.dart';
import 'package:holdwise/features/auth/presentation/widgets/forgot_password_email_input_card.dart';
import 'package:holdwise/features/auth/presentation/widgets/login_form.dart';
import 'package:holdwise/features/auth/presentation/widgets/otp_card.dart';
import 'package:holdwise/features/auth/presentation/widgets/signup_form.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return CupertinoPageRoute(
          builder: (_) => AuthPage(
            title: 'Login',
            cardContent: LoginForm(),
          ),
        );
      case AppRoutes.signup:
        return CupertinoPageRoute(
          builder: (_) => const AuthPage(
            title: 'Sign Up',
            cardContent: SignupForm(),
          ),
        );
      case AppRoutes.forgotPassword:
        return CupertinoPageRoute(
          builder: (_) => AuthPage(
            title: 'Forgot Password',
            cardContent: ForgotPasswordEmailInputCard(),
          ),
        );
      case AppRoutes.resetPassword:
        return CupertinoPageRoute(
          builder: (_) => AuthPage(
            title: 'Reset Password',
            cardContent: OTPCard(
              title: 'Reset Password',
              description: "Please enter the code sent to your email.",
              onResend: () => print('Resend code'),
              onSubmit: (String s) => print('Submit code'),
            ),
          ),
        );
      case AppRoutes.home:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            child: const Scaffold(
              body: Center(
                child: Text('Home Page'),
              ),
            ),
          ),
        );

      default:
        return CupertinoPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
