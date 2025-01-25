import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/features/auth/presentation/pages/auth_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.auth:
        return CupertinoPageRoute(
          builder: (_) => const AuthPage(
            card: Text('Auth Card'),
          ),
        );
      // case AppRoutes.signup:
      //   return CupertinoPageRoute(
      //     builder: (_) => const AuthPage(),
      //   );
      case AppRoutes.forgotPassword:
        return CupertinoPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Forgot Password Page'),
            ),
          ),
        );
      case AppRoutes.home:
        return CupertinoPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Home Page'),
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
