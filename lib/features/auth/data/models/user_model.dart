class UserData {
  late String uid;
  late String email;
  late String name;
  late String photoURL;
  late String about;
  late String createdAt;
  late bool isOnline;
  late String lastActive;
  late String pushToken;
  late String phoneNumber;

  UserData({
    required this.uid,
    required this.email,
    required this.name,
    required this.photoURL,
    required this.about,
    required this.phoneNumber,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uid': uid});
    result.addAll({'email': email});
    result.addAll({'name': name});
    result.addAll({'photoURL': photoURL});
    result.addAll({'about': about});

    result.addAll({'createdAt': createdAt});

    result.addAll({'isOnline': isOnline});

    result.addAll({'lastActive': lastActive});

    result.addAll({'pushToken': pushToken});

    result.addAll({'phoneNumber': phoneNumber});

    return result;
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'],
      photoURL: map['photoURL'],
      about: map['about'] ?? '',
      createdAt: map['createdAt'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastActive: map['lastActive'] ?? '',
      pushToken: map['pushToken'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
}
