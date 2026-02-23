import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String type; // BUYING or SELLING
  final Timestamp createdAt;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.type,
    required this.createdAt,
  });

  factory Listing.fromMap(Map<String, dynamic> data, String documentId) {
    return Listing(
      id: documentId,
      title: data['title'] ?? 'No title',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Other',
      type: data['type'] ?? 'SELLING',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'type': type,
      'createdAt': createdAt,
    };
  }
}
