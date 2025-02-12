
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holdwise/app/utils/api_path.dart';
import 'package:holdwise/features/auth/data/models/user_model.dart';
import 'package:holdwise/common/services/firestore_services.dart';

class AuthServices {
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreServices = FirestoreServices.instance;

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> signUpWithEmailAndPassword(String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null) {
      final user = userCredential.user;
      // load about from claims
      final claims = await user!.getIdTokenResult();
      final about = claims.claims!['about'] ?? '';
      
      final userData = UserData(
        uid: user!.uid,
        email: user.email ?? '',
        photoURL: user.photoURL ?? '',
        name: user.displayName ?? '',
        about: about ?? '',
        createdAt: DateTime.now().toIso8601String(),
        isOnline: true,
        lastActive: DateTime.now().toIso8601String(),
        pushToken: '',        
        phoneNumber: user.phoneNumber ?? '',
      );
      await firestoreServices.setData(
        path: ApiPath.user(userData.uid),
        data: userData.toMap(),
      );
      return true;
    } else {
      return false;
    }
  }

  User? get currentUser {
    return firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}