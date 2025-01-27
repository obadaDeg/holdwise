part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final String token;
  final bool isAdmin;
  final bool isSpecialist;
  final bool isPatient;

  AuthAuthenticated(
    this.user,
    this.token, {
    this.isAdmin = false,
    this.isSpecialist = false,
    this.isPatient = false,
  });
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}

class AuthLoggingOut extends AuthState {}

class AuthLoggedOut extends AuthState {}

class PasswordResetEmailSent extends AuthState {}

class EmailVerificationSent extends AuthState {}
