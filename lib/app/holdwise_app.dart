import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:holdwise/app/config/themes.dart';
import 'package:holdwise/app/cubits/auth_cubit/auth_cubit.dart';
import 'package:holdwise/app/cubits/preferences_cubit/preferences_cubit.dart';
import 'package:holdwise/app/cubits/theme_cubit/theme_cubit.dart';
import 'package:holdwise/app/routes/router.dart';
import 'package:holdwise/app/routes/routes.dart';

class HoldWiseApp extends StatelessWidget {
  const HoldWiseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Only provide additional cubits that haven't been provided at the root.
        BlocProvider(
          create: (context) {
            final authCubit = AuthCubit();
            authCubit.checkAuthStatus();
            return authCubit;
          },
        ),
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => PreferencesCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return MaterialApp(
                title: 'HoldWise',
                theme: AppTheme.lightTheme(context),
                darkTheme: AppTheme.darkTheme(context),
                themeMode: themeMode,
                initialRoute: state is AuthAuthenticated
                    ? AppRoutes.dashboard
                    : AppRoutes.login,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          );
        },
      ),
    );
  }
}
