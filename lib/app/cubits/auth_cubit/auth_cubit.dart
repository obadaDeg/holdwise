import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:holdwise/app/config/constants.dart';
import 'package:holdwise/app/utils/api_path.dart';
import 'package:holdwise/features/auth/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:holdwise/common/services/firestore_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final firestoreServices = FirestoreServices.instance;
  StreamSubscription<User?>? _authSubscription;
  Timer? _tokenValidationTimer;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage(
    aOptions: _getAndroidOptions(),
  );
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  AuthCubit() : super(AuthInitial()) {
    _authSubscription = _auth.authStateChanges().listen(_authStateListener);
  }

  Future<void> _saveToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
    await _secureStorage.write(
        key: 'auth_token_timestamp', value: DateTime.now().toIso8601String());
    await _secureStorage.write(
        key: 'auth_token_expiry',
        value: DateTime.now().add(Duration(days: 30)).toIso8601String());
    await _secureStorage.write(key: 'user', value: _auth.currentUser!.uid);
  }

  Future<String?> _loadToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  Future<String?> _loadUser() async {
    return await _secureStorage.read(key: 'user');
  }

  Future<void> _removeAll() async {
    await _secureStorage.deleteAll();
  }

  Future<void> _removeToken() async {
    await _secureStorage.delete(key: 'auth_token');
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

      // Save the token
      await _saveToken(idTokenResult.token!);

      // Emit authenticated state based on the role
      final role = idTokenResult.claims?['role'] ?? AppRoles.patient;
      emit(AuthAuthenticated(user, idTokenResult.token!,
          role: AppRoles.specialist));
      // emit(AuthAuthenticated(user, idTokenResult.token!, role: role));
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

  void checkAuthStatus() async {
    final String? token = await _loadToken();
    if (token != null) {
      final user = _auth.currentUser;
      if (user != null) {
        // Validate token
        _validateToken(user);
      } else {
        emit(AuthLoggedOut());
      }
    } else {
      emit(AuthLoggedOut());
    }
  }

  Future<void> updateProfile(
      String name, String phoneNumber, String about) async {
    emit(AuthLoading());
    try {
      final user = _auth.currentUser;
      if (user == null) {
        emit(AuthError("User not found"));
        return;
      }

      final token = await user.getIdToken();
      if (token == null) {
        emit(AuthError("Token not found"));
        return;
      }

      await http.post(
        Uri.parse('http://localhost:5000/updateProfile'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'uid': user.uid,
          'name': name,
          'phoneNumber': phoneNumber,
          'about': about,
        }),
      );

      emit(AuthSuccess("Profile updated successfully."));
      emit(AuthAuthenticated(user, token, role: AppRoles.patient));
    } catch (e) {
      emit(AuthError("Error updating profile: ${e.toString()}"));
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
        final role = idTokenResult.claims?['role'] ?? AppRoles.patient;
        final lastSignInTime = user.metadata.lastSignInTime;
        final creationTime = user.metadata.creationTime;

        // if user data is not assigned, fetch them from user collection for the specific id

        // Update metadata in Firestore
        await firestoreServices.setData(
          path: ApiPath.user(user.uid),
          data: {
            'lastSignInTime': lastSignInTime?.toIso8601String(),
            'creationTime': creationTime?.toIso8601String(),
          },
        );

        emit(AuthAuthenticated(user, idTokenResult.token!, role: role));

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

        final claims = await user!.getIdTokenResult();
        final about = claims.claims!['about'] ?? '';

        final userData = UserData(
          uid: user!.uid,
          email: user.email ?? '',
          photoURL: user.photoURL ?? '',
          name: user.displayName ?? '',
          phoneNumber: user.phoneNumber ?? '',
          about: about ?? '',
          createdAt: DateTime.now().toIso8601String(),
          isOnline: true,
          lastActive: DateTime.now().toIso8601String(),
          pushToken: '',
        );
        await firestoreServices.setData(
          path: ApiPath.user(userData.uid),
          data: userData.toMap(),
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
    await _removeToken(); // Clear token from storage
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
      print('User is $user');
      if (user != null) {
        final token = await user.getIdToken();
        print('Token is $token');
        emit(AuthAuthenticated(user, token!, role: AppRoles.patient));
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
