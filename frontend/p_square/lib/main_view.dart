import 'package:flutter/material.dart';
import 'package:p_square/app/features/marketplace/views/marketplace_view.dart';
import 'package:p_square/app/features/plant/views/plant_view.dart';
import 'package:p_square/app/features/profile/views/profile_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    
    final List<Widget> tabs = [PlantView(), MarketplaceScreen(), ProfileView()];
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (int index) {
            setState(() => currentIndex = index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.local_florist),
              label: "Plant",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
              label: "Marketplace",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
        body: tabs[currentIndex],
      ),
    );
  }
}
