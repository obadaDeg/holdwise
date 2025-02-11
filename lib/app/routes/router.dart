import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/routes/protected_routes.dart';
import 'package:holdwise/app/routes/routes.dart';
import 'package:holdwise/common/widgets/role_based_buttom_navbar.dart';
import 'package:holdwise/features/appointments/presentation/pages/appointments_screen.dart';
import 'package:holdwise/features/auth/presentation/pages/auth_page.dart';
import 'package:holdwise/features/auth/presentation/widgets/forgot_password_email_input_card.dart';
import 'package:holdwise/features/auth/presentation/widgets/login_form.dart';
import 'package:holdwise/features/auth/presentation/widgets/otp_card.dart';
import 'package:holdwise/features/auth/presentation/widgets/signup_form.dart';
import 'package:holdwise/features/chat/data/models/chat_user.dart';
import 'package:holdwise/features/chat/presentation/pages/chat_screen.dart';
import 'package:holdwise/features/chat/presentation/pages/home_screen.dart';
import 'package:holdwise/features/info/presentation/pages/about_screen.dart';
import 'package:holdwise/features/info/presentation/pages/help_screen.dart';
import 'package:holdwise/features/notifications/presentation/pages/notification_screen.dart';
import 'package:holdwise/features/profile/presentation/pages/profile_screen.dart';
import 'package:holdwise/features/profile/presentation/pages/settings_screen_dialog.dart';
import 'package:holdwise/features/appointments/presentation/pages/specialist_appointments_page.dart';
import 'package:holdwise/features/records/presentation/pages/personal_records.dart';
import 'package:holdwise/features/subscription/presentation/pages/subscription.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAuthPage: true,
            child: AuthPage(
              title: 'Login',
              cardContent: LoginForm(),
            ),
          ),
        );

      case AppRoutes.signup:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAuthPage: true,
            child: AuthPage(
              title: 'Sign Up',
              cardContent: SignupForm(),
            ),
          ),
        );

      case AppRoutes.forgotPassword:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAuthPage: true,
            child: AuthPage(
              title: 'Forgot Password',
              cardContent: ForgotPasswordEmailInputCard(),
            ),
          ),
        );

      case AppRoutes.resetPassword:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAuthPage: true,
            child: AuthPage(
              title: 'Reset Password',
              cardContent: OTPCard(
                title: 'Reset Password',
                description: "Please enter the code sent to your email.",
                onResend: () => print('Resend code'),
                onSubmit: (String s) => print('Submit code'),
              ),
            ),
          ),
        );

      case AppRoutes.dashboard:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAdmin: true,
            isPatient: true,
            isSpecialist: true,
            child: RoleBasedNavBar(),
          ),
        );

      case AppRoutes.profile:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
              isAdmin: true,
              isPatient: true,
              isSpecialist: true,
              child: ProfileScreen()),
        );

      case AppRoutes.notifications:
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (_) => ProtectedRoute(
              isAdmin: true,
              isPatient: true,
              isSpecialist: true,
              child: NotificationsScreen()),
        );

      // case AppRoutes.chat:
      //   final arg = settings.arguments;

      //   if (arg is Future<ChatUser>) {
      //     return CupertinoPageRoute(
      //       builder: (_) => FutureBuilder<ChatUser>(
      //         future: arg,
      //         builder: (context, snapshot) {
      //           if (snapshot.connectionState == ConnectionState.waiting) {
      //             return Scaffold(
      //                 body: Center(child: CircularProgressIndicator()));
      //           } else if (snapshot.hasError || !snapshot.hasData) {
      //             return Scaffold(
      //               body: Center(
      //                 child: Text('Error loading user data for Chat Screen'),
      //               ),
      //             );
      //           }
      //           return ProtectedRoute(
      //             isAdmin: true,
      //             isPatient: true,
      //             isSpecialist: true,
      //             child: ChatScreen(user: snapshot.data!),
      //           );
      //         },
      //       ),
      //     );
      //   }

      //   if (arg is ChatUser) {
      //     return CupertinoPageRoute(
      //       builder: (_) => ProtectedRoute(
      //         isAdmin: true,
      //         isPatient: true,
      //         isSpecialist: true,
      //         child: ChatScreen(user: arg),
      //       ),
      //     );
      //   }

      //   return CupertinoPageRoute(
      //     builder: (_) => Scaffold(
      //       body: Center(
      //         child: Text('User data is missing for Chat Screen'),
      //       ),
      //     ),
      //   );

      case AppRoutes.chat:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAdmin: true,
            isPatient: true,
            isSpecialist: true,
            child: HomeScreen(),
          ),
        );

      case AppRoutes.profileSettings:
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (_) => ProtectedRoute(
            isAdmin: true,
            isPatient: true,
            isSpecialist: true,
            child: SettingsScreen(),
          ),
        );

      case AppRoutes.subscription:
        return CupertinoPageRoute(
          fullscreenDialog: true,
          builder: (_) => ProtectedRoute(
            isAdmin: false,
            isPatient: true,
            isSpecialist: false,
            child: Subscription(),
          ),
        );

      case AppRoutes.billing:
        return CupertinoPageRoute(
          builder: (_) => const BillingPage(),
        );

      case AppRoutes.schedule:
        // Expecting patientId to be passed as a String in settings.arguments.
        if (settings.arguments is String) {
          final patientId = settings.arguments as String;
          return CupertinoPageRoute(
            builder: (_) => ProtectedRoute(
              isAdmin: true,
              isPatient: true,
              isSpecialist: true,
              child: PatientAppointmentsPage(patientId: patientId),
            ),
          );
        } else {
          return CupertinoPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text('Missing patient ID for Schedule Screen'),
              ),
            ),
          );
        }

      case AppRoutes.specialistAppointments:
        // Expecting specialistId to be passed as a String.
        if (settings.arguments is String) {
          final specialistId = settings.arguments as String;
          return CupertinoPageRoute(
            builder: (_) => ProtectedRoute(
              isAdmin: true,
              isPatient: true,
              isSpecialist: true,
              child: SpecialistAppointmentsPage(specialistId: specialistId),
            ),
          );
        } else {
          return CupertinoPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                child: Text(
                    'Missing specialist ID for Specialist Appointments Page'),
              ),
            ),
          );
        }

      case AppRoutes.personalRecords:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAdmin: true,
            isPatient: true,
            isSpecialist: true,
            child: PersonalRecords(),
          ),
        );

      case AppRoutes.about:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAdmin: true,
            isPatient: true,
            isSpecialist: true,
            child: AboutScreen(),
          ),
        );

      case AppRoutes.help:
        return CupertinoPageRoute(
          builder: (_) => ProtectedRoute(
            isAdmin: true,
            isPatient: true,
            isSpecialist: true,
            child: HelpScreen(),
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
