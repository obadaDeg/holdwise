import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:holdwise/app/utils/api_path.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:holdwise/common/services/firestore_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreServices = FirestoreServices.instance;
  StreamSubscription<User?>? _authSubscription;
  Timer? _tokenValidationTimer;

  AuthCubit() : super(AuthInitial()) {
    _authSubscription = _auth.authStateChanges().listen(_authStateListener);
  }

  void _authStateListener(User? user) {
    if (user != null) {
      _validateToken(user);
    } else {
      emit(AuthLoggedOut());
    }
  }

  // Check if user is already logged in
  void _validateToken(User user) async {
    try {
      final idTokenResult = await user.getIdTokenResult();
      final tokenValidAfter =
          DateTime.parse(idTokenResult.claims!['tokensValidAfterTime']);

      // check disabled user
      if (user.emailVerified == false) {
        emit(AuthError('Email is not verified. Please verify your email.'));
        return;
      }

      // if (await user.disabled == null) {
      //   emit(AuthError('Token is invalid. Please log in again.'));
      //   return;
      // }

      // Check if the token is expired
      if (DateTime.now().isAfter(tokenValidAfter)) {
        await logout(); // Automatically log the user out
        emit(AuthError('Session expired. Please log in again.'));
      } else {
        final role = idTokenResult.claims?['role'] ?? 'patient';
        if (role == 'admin') {
          emit(AuthAuthenticated(user, idTokenResult.token!, isAdmin: true));
        } else if (role == 'specialist') {
          emit(AuthAuthenticated(user, idTokenResult.token!,
              isSpecialist: true));
        } else if (role == 'patient') {
          emit(AuthAuthenticated(user, idTokenResult.token!, isPatient: true));
        }
      }
    } catch (e) {
      debugPrint('Token validation failed: ${e.toString()}');
      emit(AuthError('Something went wrong. Please log in again.'));
    }
  }

  void startTokenValidationTimer() {
    _tokenValidationTimer =
        Timer.periodic(const Duration(minutes: 10), (_) async {
      final user = _auth.currentUser;
      if (user != null) {
        _validateToken(user);
      }
    });
  }

  void stopTokenValidationTimer() {
    _tokenValidationTimer?.cancel();
  }

  void checkAuthStatus() {
    final User? user = _auth.currentUser;
    if (user != null) {
      _validateToken(user);
    } else {
      emit(AuthLoggedOut());
    }
  }

  // Login Method
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        final idTokenResult = await user.getIdTokenResult();
        final lastSignInTime = user.metadata.lastSignInTime;
        final creationTime = user.metadata.creationTime;

        // Update metadata in Firestore
        await firestoreServices.setData(
          path: ApiPath.user(user.uid),
          data: {
            'lastSignInTime': lastSignInTime?.toIso8601String(),
            'creationTime': creationTime?.toIso8601String(),
          },
        );

        _validateToken(user);
      } else {
        emit(AuthError('Login failed. User not found.'));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unexpected error occurred.'));
      }
    }
  }

  // Signup Method
  Future<void> signup(String email, String password) async {
    emit(AuthLoading());
    try {
      final UserCredential credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // Send email verification
        await user.sendEmailVerification();

        // Save metadata to Firestore
        final creationTime = user.metadata.creationTime;
        await firestoreServices.setData(
          path: ApiPath.user(user.uid),
          data: {
            'uid': user.uid,
            'email': user.email,
            'creationTime': creationTime?.toIso8601String(),
            'lastSignInTime': null,
          },
        );

        emit(AuthSuccess('Signup successful! Please verify your email.'));
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        emit(AuthError(_getErrorMessage(e)));
      } else {
        emit(AuthError('An unexpected error occurred.'));
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
      emit(AuthLoading());
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        emit(AuthSuccess('Verification email sent successfully.'));
      } else {
        emit(AuthError('Email is already verified.'));
      }
    } catch (e) {
      emit(AuthError('Failed to send verification email.'));
    }
  }

// Check Email Verification
  Future<void> checkEmailVerification() async {
    try {
      emit(AuthLoading());
      await _auth.currentUser?.reload();
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        emit(AuthSuccess('Email verified successfully.'));
      } else {
        emit(AuthError('Email is not yet verified.'));
      }
    } catch (e) {
      emit(AuthError('Failed to check email verification status.'));
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
      debugPrint('Google Sign-in initiated...');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      debugPrint('Google Sign-in completed...');
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
      final User? user = userCredential.user;

      if (user != null) {
        final token = await user.getIdToken();
        emit(AuthAuthenticated(user, token!, isPatient: true));
        print(
            '#################################################################');
        print(user);
        print(user.uid);
        print(
            '#################################################################');

      //   final response = await http.post(
      //     Uri.parse('http://172.24.16.1:5000/setCustomClaims'),
      //     headers: {
      //       'Content-Type': 'application/json',
      //     },
      //     body: jsonEncode({'uid': user.uid}),
      //   );

      //   print('==================================');
      //   if (response.statusCode == 200) {
      //     emit(AuthSuccess('Signup with Google successful!'));
      //     print('Custom claims set successfully.');
      //     _validateToken(user);
      //   } else {
      //     print('Error: ${response.body}');
      //     emit(AuthError('Google Signup failed, please try again.'));
      //   }
      }
    } catch (e) {
      print('Error: $e here is the error');
      emit(AuthError('Google Signup failed, please try again.'));
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

  void calculateSessionDuration() {
    final user = _auth.currentUser;
    if (user != null) {
      final lastSignInTime = user.metadata.lastSignInTime;
      if (lastSignInTime != null) {
        final duration = DateTime.now().difference(lastSignInTime);
        print('Session duration: ${duration.inMinutes} minutes');
      }
    }
  }

  Future<void> checkSessionExpiry() async {
    final user = _auth.currentUser;
    if (user != null) {
      final lastSignInTime = user.metadata.lastSignInTime;
      if (lastSignInTime != null) {
        final duration = DateTime.now().difference(lastSignInTime);
        if (duration.inDays > 30) {
          emit(AuthError('Session expired. Please re-authenticate.'));
          await logout(); // Log the user out
        }
      }
    }
  }

  Future<void> fetchUserMetadata(String uid) async {
    final userDoc = await firestoreServices.getDocument(
      path: ApiPath.user(uid),
      builder: (data, documentId) => data,
    );

    final creationTime = DateTime.parse(userDoc['creationTime']);
    final lastSignInTime = DateTime.parse(userDoc['lastSignInTime']);

    print('Account created on: ${creationTime.toLocal()}');
    print('Last signed in on: ${lastSignInTime.toLocal()}');
  }

  // Cleanup subscription
  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found for this email. Please sign up.';
      case 'wrong-password':
        return 'The password is incorrect. Please try again.';
      case 'email-already-in-use':
        return 'This email is already registered. Please log in or use a different email.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
