part of 'auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  final String token;
  AuthAuthenticated(this.user, this.token);
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


