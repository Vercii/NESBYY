import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp createdAt; // store createdAt as a field

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });

  // Factory to create from Firestore document
  factory Listing.fromMap(Map<String, dynamic> data, String documentId) {
    return Listing(
      id: documentId,
      title: data['title'] ?? 'No title',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(), // fallback if missing
    );
  }

  // Convert Listing object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'createdAt': createdAt,
    };
  }
}
