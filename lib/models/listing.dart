class Listing {
  final String id;
  final String title;
  final String description;
  final String imageUrl;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  // Factory to create from Firestore
  factory Listing.fromMap(Map<String, dynamic> data, String documentId) {
    return Listing(
      id: documentId,
      title: data['title'] ?? 'No title',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
