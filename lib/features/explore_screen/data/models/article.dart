import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String url;
  final String author;
  final String category;
  final DateTime timestamp;

  const ArticleModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
    required this.author,
    required this.category,
    required this.timestamp,
  });

  /// Convert Firestore document to ArticleModel
  factory ArticleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ArticleModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? 'Click to read more',
      imageUrl: data['imageUrl'] ?? '',
      url: data['url'] ?? '',
      author: data['author'] ?? 'Unknown',
      category: data['category'] ?? 'General',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert ArticleModel to Firestore-compatible format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'url': url,
      'author': author,
      'category': category,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
