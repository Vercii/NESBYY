// lib/screens/create_listing_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nesbyy/widgets/listing_card.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({Key? key}) : super(key: key);

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  final picker = ImagePicker();

  // ⭐ CATEGORY & TYPE
  String _selectedCategory = 'Electronics';
  String _listingType = 'SELLING';

  final List<String> _categories = [
    'Electronics',
    'Books',
    'Clothing',
    'Furniture',
    'Other',
  ];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    final storageRef = FirebaseStorage.instance.ref().child(
      'listing_images/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You must be logged in')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Upload image
      String imageUrl = '';
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!) ?? '';
      }

      // ⭐ Create Listing WITH USER INFO
      final listing = Listing(
        id: '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        imageUrl: imageUrl,
        category: _selectedCategory,
        type: _listingType,
        sellerId: user.uid,
        sellerEmail: user.email ?? '',
        createdAt: Timestamp.now(),
      );

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('listings')
          .add(listing.toMap());

      // Clear form
      _titleController.clear();
      _descriptionController.clear();

      setState(() {
        _imageFile = null;
        _selectedCategory = 'Electronics';
        _listingType = 'SELLING';
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Listing created!')));

      Navigator.pop(context); // Go back to Home
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during listing creation: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // IMAGE PREVIEW
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),

              const SizedBox(height: 12),

              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image),
                label: const Text('Pick Image'),
              ),

              const SizedBox(height: 12),

              // TITLE
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter title' : null,
              ),

              const SizedBox(height: 12),

              // DESCRIPTION
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter description' : null,
              ),

              const SizedBox(height: 12),

              // CATEGORY
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
                decoration: const InputDecoration(labelText: 'Category'),
              ),

              const SizedBox(height: 16),

              // BUYING / SELLING
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('SELLING'),
                    selected: _listingType == 'SELLING',
                    onSelected: (_) => setState(() => _listingType = 'SELLING'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text('BUYING'),
                    selected: _listingType == 'BUYING',
                    onSelected: (_) => setState(() => _listingType = 'BUYING'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Create Listing'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
