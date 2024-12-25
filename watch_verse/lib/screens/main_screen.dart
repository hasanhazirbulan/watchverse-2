import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:watch_verse/screens/home_screen.dart';
import 'package:watch_verse/screens/watchlist_screen.dart';
import 'package:watch_verse/screens/profile_screen.dart';
import 'package:watch_verse/screens/search_screen.dart'; // SearchScreen'i ekledik

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Varsayılan sekme

  final List<Widget> _screens = [
    const HomeScreen(), // Ana ekran
    const WatchlistScreen(), // İzleme listesi
    const SearchScreen(), // Arama ekranı
    const ProfileScreen(), // Profil ekranı
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.orange,
        buttonBackgroundColor: Colors.orangeAccent,
        height: 60,
        index: _selectedIndex,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white), // Home sekmesi
          Icon(Icons.list, size: 30, color: Colors.white), // Watchlist sekmesi
          Icon(Icons.search, size: 30, color: Colors.white), // Search sekmesi
          Icon(Icons.person, size: 30, color: Colors.white), // Profile sekmesi
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Seçili sekmeyi güncelle
          });
        },
      ),
    );
  }
}
