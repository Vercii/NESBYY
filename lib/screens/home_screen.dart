import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing.dart';
import '../widgets/listing_card.dart';
import 'create_listing_screen.dart'; // Import the CreateListingScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final listingsRef = FirebaseFirestore.instance.collection('listings');

    return Scaffold(
      appBar: AppBar(title: const Text('NESBYY'), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: listingsRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No listings yet.'));
          }

          // Map Firestore docs to Listing objects
          final listings = snapshot.data!.docs
              .map(
                (doc) =>
                    Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();

          return ListView.builder(
            itemCount: listings.length,
            itemBuilder: (context, index) {
              final listing = listings[index];
              return ListingCard(listing: listing);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateListingScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
