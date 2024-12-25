import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isDarkMode = false; // Dark mode state
  String _displayName = '';
  String _photoURL = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Fetch user data (name and photoURL)
  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          setState(() {
            _displayName = userDoc.data()?['name'] ?? 'No Name';
            _photoURL = userDoc.data()?['photoURL'] ??
                'https://via.placeholder.com/150'; // Default image
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch user data: $e')),
        );
      }
    }
  }

  /// Update user name in Firestore
  Future<void> _updateUserName(String newName) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'name': newName,
        });
        setState(() {
          _displayName = newName;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update name: $e')),
        );
      }
    }
  }

  /// Upload profile picture to Firebase Storage and update Firestore
  Future<void> _uploadProfilePicture() async {
    // Önceden tanımlanmış avatar resimleri
    final List<String> avatars = [
      'https://via.placeholder.com/150?text=Avatar1',
      'https://via.placeholder.com/150?text=Avatar2',
      'https://via.placeholder.com/150?text=Avatar3',
      'https://via.placeholder.com/150?text=Avatar4',
    ];

    // Dialog ile avatar seçimi yapılır
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select an Avatar'),
          content: SizedBox(
            height: 200,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: avatars.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    Navigator.pop(context); // Dialogu kapat
                    final selectedAvatar = avatars[index];
                    await _updateSelectedAvatar(selectedAvatar);
                  },
                  child: Image.network(
                    avatars[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Seçilen avatarı Firestore'a kaydetme
  Future<void> _updateSelectedAvatar(String avatarURL) async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Kullanıcı belgesini güncelle
        await _firestore.collection('users').doc(user.uid).update({
          'photoURL': avatarURL,
        });

        // Ekranı güncelle
        setState(() {
          _photoURL = avatarURL;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _uploadProfilePicture,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(_photoURL),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Display Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name: $_displayName',
                  style: const TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String newName = '';
                        return AlertDialog(
                          title: const Text('Edit Name'),
                          content: TextField(
                            onChanged: (value) {
                              newName = value;
                            },
                            decoration: const InputDecoration(
                              hintText: 'Enter new name',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _updateUserName(newName);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
