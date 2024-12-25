import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watch_verse/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false; // State for dark mode toggle
  String _displayName = ''; // Placeholder for Firestore name

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch Firestore name on init
  }

  /// Fetch the user's name from Firestore
  Future<void> _fetchUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists && userDoc.data()?['name'] != null) {
          setState(() {
            _displayName = userDoc.data()?['name'] ?? 'No Name Provided';
          });
        } else {
          setState(() {
            _displayName = 'No Name Provided';
          });
        }
      } catch (e) {
        setState(() {
          _displayName = 'Error Fetching Name';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Center(child: Text('No user logged in.'));
    }

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300), // Smooth transition duration
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Profile picture
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(
                  user.email?.substring(0, 1).toUpperCase() ?? '',
                  style: const TextStyle(fontSize: 32, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

              // Display Name
              Text(
                _displayName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Email
              Text(
                user.email ?? 'No Email Provided',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 8),

              // User ID
              Text(
                'User ID: ${user.uid}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Dark Mode Toggle with Smooth Transition
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dark Mode',
                    style: TextStyle(fontSize: 18),
                  ),
                  Switch(
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Settings Button
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to a settings page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.settings),
                label: const Text('Settings'),
              ),

              // Sign Out Button
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut(); // Kullanıcıyı çıkış yap
                    Navigator.of(context).pushNamed('/login');

                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign out failed: $e')),
                    );
                  }
                },
                child: const Text('Sign Out'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

