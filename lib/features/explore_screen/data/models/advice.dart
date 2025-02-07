import 'package:cloud_firestore/cloud_firestore.dart';

enum AdviceType { text, image, video }

class AdviceModel {
  final String id;
  final String title;
  final String content;
  final AdviceType type;
  final String? mediaUrl;
  final String author;
  final String category;
  final DateTime timestamp;

  const AdviceModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.mediaUrl,
    required this.author,
    required this.category,
    required this.timestamp,
  });

  /// Convert Firestore document to AdviceModel
  factory AdviceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return AdviceModel(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      type: _mapAdviceType(data['type']),
      mediaUrl: data['mediaUrl'],
      author: data['author'] ?? 'Unknown',
      category: data['category'] ?? 'General',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  /// Convert AdviceModel to Firestore-compatible format
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'type': _adviceTypeToString(type),
      'mediaUrl': mediaUrl,
      'author': author,
      'category': category,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  static AdviceType _mapAdviceType(String? type) {
    switch (type?.toLowerCase()) {
      case 'video':
        return AdviceType.video;
      case 'image':
        return AdviceType.image;
      default:
        return AdviceType.text;
    }
  }

  static String _adviceTypeToString(AdviceType type) {
    switch (type) {
      case AdviceType.video:
        return 'video';
      case AdviceType.image:
        return 'image';
      default:
        return 'text';
    }
  }
}
