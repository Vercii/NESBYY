import 'package:cloud_firestore/cloud_firestore.dart';

enum ListingType { buy, sell }

class ListingModel {
  final String id;
  final String userId;
  final ListingType type;
  final String title;
  final String description;
  final String category;
  final double? price; // optional for buy posts
  final List<String>? images;
  final Timestamp timestamp;

  ListingModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.description,
    required this.category,
    this.price,
    this.images,
    required this.timestamp,
  });

  factory ListingModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ListingModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      type: data['type'] == 'sell' ? ListingType.sell : ListingType.buy,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      price: data['price'] != null ? (data['price'] as num).toDouble() : null,
      images: data['images'] != null ? List<String>.from(data['images']) : null,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type == ListingType.sell ? 'sell' : 'buy',
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'images': images,
      'timestamp': timestamp,
    };
  }
}
