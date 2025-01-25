import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'auth_state.dart';
// Authentication States

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthCubit() : super(AuthInitial());

  // Check if user is already logged in
  void checkUser() {
    final user = _auth.currentUser;
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(AuthLoggedOut());
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
      emit(AuthAuthenticated(credential.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
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
      emit(AuthAuthenticated(credential.user!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // Logout Method
  Future<void> logout() async {
    await _auth.signOut();
    emit(AuthLoggedOut());
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'Password reset email sent! Check your inbox.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser!.delete();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> updatePhoneNumber(PhoneAuthCredential phoneNumber) async {
    try {
      await _auth.currentUser!.updatePhoneNumber(phoneNumber);
      emit(AuthAuthenticated(_auth.currentUser!));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(AuthError(e.message!));
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(AuthError('Code sent!'));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
