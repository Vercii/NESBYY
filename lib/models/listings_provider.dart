import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/listing_model.dart';

final listingsCollectionProvider = Provider((ref) {
  return FirebaseFirestore.instance.collection('listings');
});

// Stream of all listings
final listingsProvider = StreamProvider<List<ListingModel>>((ref) {
  final col = ref.watch(listingsCollectionProvider);
  return col
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromFirestore(doc))
            .toList(),
      );
});

// Filter by type (buy/sell) example
final sellListingsProvider = StreamProvider<List<ListingModel>>((ref) {
  final col = ref.watch(listingsCollectionProvider);
  return col
      .where('type', isEqualTo: 'sell')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map((doc) => ListingModel.fromFirestore(doc))
            .toList(),
      );
});
