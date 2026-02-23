// lib/models/listing.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String category;
  final String type; // SELLING or BUYING
  final String sellerEmail;
  final Timestamp createdAt;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.type,
    required this.sellerEmail,
    required this.createdAt,
    required String sellerId,
  });

  // Factory to create a Listing from Firestore data safely
  factory Listing.fromMap(Map<String, dynamic> data, String documentId) {
    return Listing(
      id: documentId,
      title: data['title'] ?? 'No title',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? 'Other',
      type: data['type'] ?? 'SELLING',
      sellerEmail: data['sellerEmail'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      sellerId: '',
    );
  }

  // Convert Listing to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'type': type,
      'sellerEmail': sellerEmail,
      'createdAt': createdAt,
    };
  }
}
