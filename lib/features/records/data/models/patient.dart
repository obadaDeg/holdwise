class Patient {
  final String id;
  final String name;
  final String imageUrl = 'assets/placeholders/user.png';

  Patient({required this.id, required this.name, String? imageUrl});

  factory Patient.fromJson(Map<String, dynamic> json, String id) {
    return Patient(
      id: id,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }
}