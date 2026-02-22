import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      avatarUrl: data['avatarUrl'],
      bio: data['bio'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'bio': bio,
    };
  }
}
