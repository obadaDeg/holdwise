import 'package:firebase_auth/firebase_auth.dart';

Map<String, dynamic> userToJson(User user) {
  return {
    'uid': user.uid,
    'email': user.email,
    'displayName': user.displayName,
    'photoURL': user.photoURL,
    'phoneNumber': user.phoneNumber,
    'emailVerified': user.emailVerified,
    'providerId': user.providerData.isNotEmpty ? user.providerData[0].providerId : null,
  };
}
