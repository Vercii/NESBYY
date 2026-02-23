import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/listing.dart';
import '../widgets/listing_card.dart';
import 'create_listing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // AuthGate will automatically redirect to LoginScreen
  }

  @override
  Widget build(BuildContext context) {
    final listingsRef = FirebaseFirestore.instance.collection('listings');
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NESBYY'),
        centerTitle: true,
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  user.email ?? '',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: "Logout",
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: listingsRef.orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ❌ No listings
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No listings yet.'));
          }

          // 🔄 Convert Firestore docs → Listing objects
          final listings = snapshot.data!.docs
              .map(
                (doc) =>
                    Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id),
              )
              .toList();

          // 📜 Display feed
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
        tooltip: "Create Listing",
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
