import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'prayer_timing.dart';
import 'qibla_homepage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    const QiblaHomepage(),
    const PrayerTimesPage(),
  ];
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _pages,
      ),
      bottomNavigationBar: Container(
        color: Colors.blue,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GNav(
            backgroundColor: Colors.blue,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.blueAccent,
            gap: 8,
            padding: EdgeInsetsGeometry.all(16),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            tabs: [
              GButton(icon:
              Icons.explore, text: 'Qiblah'),
              GButton(icon:
              Icons.alarm, text: 'Prayer Times'),
            ]
            ),
        ),
      ),
    );
  }
}