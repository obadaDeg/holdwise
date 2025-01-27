import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    emit(AuthLoggingOut());
    await _auth.signOut();
    emit(AuthLoggedOut());
  }

  // Reset Password Method
  // Send Password Reset Email
  Future<void> sendPasswordReset(String email) async {
    try {
      emit(AuthLoading());
      await _auth.sendPasswordResetEmail(email: email);
      emit(PasswordResetEmailSent());
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('Code is${e}');
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unexpected error occurred.'));
      }
    }
  }

  // Send Email Verification
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        emit(AuthLoading());
        await user.sendEmailVerification();
        emit(EmailVerificationSent());
      } else {
        emit(AuthError('Email is already verified or user is null.'));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unexpected error occurred.'));
      }
    }
  }

// Check Email Verification
  Future<void> checkEmailVerification() async {
    try {
      emit(AuthLoading());
      await _auth.currentUser?.reload(); // Refresh user instance
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        // Ensure token is non-null
        final token = await user.getIdToken() ?? '';
        emit(AuthAuthenticated(user, token));
      } else {
        emit(AuthError('Email not yet verified.'));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unexpected error occurred.'));
      }
    }
  }

// Resend Password Reset Email (with debounce or delay)
  Future<void> resendPasswordReset(String email) async {
    try {
      emit(AuthLoading());
      // Optional: Check time delay or use a timer
      await _auth.sendPasswordResetEmail(email: email);
      emit(AuthSuccess('Password reset email resent!'));
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unexpected error occurred.'));
      }
    }
  }

  // Google Signup
  Future<void> googleSignup() async {
    emit(AuthLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(AuthError('Google Sign-in cancelled.'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      emit(AuthSuccess('Signup with Google successful!'));
      _validateToken(userCredential.user!);
    } catch (e) {
      emit(AuthError('Google Signup failed: ${e.toString()}'));
    }
  }

// Phone Signup
  Future<void> phoneSignup(
      String phoneNumber, Function(String) onCodeSent) async {
    emit(AuthLoading());
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-retrieval case
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);
          emit(AuthSuccess('Phone Signup successful!'));
          _validateToken(userCredential.user!);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthError(_getErrorMessage(e)));
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
          emit(AuthSuccess('Verification code sent.'));
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          emit(AuthError('Verification code timeout.'));
        },
      );
    } catch (e) {
      emit(AuthError('Phone Signup failed: ${e.toString()}'));
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
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'email-not-verified':
        return 'Email not yet verified. Please check your inbox.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
