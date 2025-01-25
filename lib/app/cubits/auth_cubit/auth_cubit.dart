import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  StreamSubscription<User?>? _authSubscription;

  AuthCubit() : super(AuthInitial()) {
    _authSubscription = _auth.authStateChanges().listen(_authStateListener);
  }

  // Check if user is already logged in
  void _authStateListener(User? user) {
    if (user != null) {
      _validateToken(user);
    } else {
      emit(AuthLoggedOut());
    }
  }

  void checkAuthStatus() {
    final User? user = _auth.currentUser;
    if (user != null) {
      _validateToken(user);
    } else {
      emit(AuthLoggedOut());
    }
  }

  // Validate token based on a custom expiration (1 month)
  void _validateToken(User user) async {
    final idTokenResult = await user.getIdTokenResult();
    final DateTime lastAuthTime =
        idTokenResult.issuedAtTime!; // Directly use as DateTime

    final DateTime oneMonthAgo =
        DateTime.now().subtract(const Duration(days: 30));
    if (lastAuthTime.isBefore(oneMonthAgo)) {
      await logout();
    } else {
      emit(AuthAuthenticated(user, idTokenResult.token!));
    }
  }

  // Login Method
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _validateToken(credential.user!);
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unknown error occurred.'));
      }
    }
  }

  // Signup Method
  Future<void> signup(String email, String password) async {
    emit(AuthLoading());
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess('Signup successful! Welcome to HoldWise!'));
      _validateToken(credential.user!);
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unknown error occurred.'));
      }
    }
  }

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthLoggedOut());
  }

  // Reset Password Method
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(AuthSuccess('Password reset email sent! Check your inbox.'));
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unknown error occurred.'));
      }
    }
  }

  // Cleanup subscription
  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
