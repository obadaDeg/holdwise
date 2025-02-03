import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatUser {
  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.id,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });

  late String image;
  late String about;
  late String name;
  late String createdAt;
  late bool isOnline;
  late String id;
  late String lastActive;
  late String email;
  late String pushToken;

  ChatUser.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    about = json['about'] ?? '';
    name = json['name'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'] ?? false;
    id = json['id'] ?? '';
    lastActive = json['last_active'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'about': about,
      'name': name,
      'created_at': createdAt,
      'is_online': isOnline,
      'id': id,
      'last_active': lastActive,
      'email': email,
      'push_token': pushToken,
    };
  }

  /// Convert Firebase User to ChatUser
  static Future<ChatUser> fromFirebase(User user) async {
    String pushToken = await getPushToken(); // Fetch push token
    return ChatUser(
      id: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
      image: user.photoURL ?? '',
      about: '', // Default about message
      createdAt: user.metadata.creationTime!.toIso8601String(),
      isOnline: true, // This should be updated dynamically in Firestore
      lastActive: user.metadata.lastSignInTime?.toIso8601String() ?? '',
      pushToken: pushToken,
    );
  }
}

/// Function to retrieve Firebase Cloud Messaging (FCM) push token
Future<String> getPushToken() async {
  try {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    return token ?? '';
  } catch (e) {
    print("Error getting push token: $e");
    return '';
  }
}
