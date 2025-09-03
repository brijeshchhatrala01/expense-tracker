

import 'package:expence_tracker/constant/icons.dart';
import 'package:expence_tracker/screens/homescreen/homescreen.dart';
import 'package:expence_tracker/screens/profilescreen/profilescreen.dart';
import 'package:flutter/material.dart';

import '../../widgets/custombottomnav.dart';

class TabPage extends StatefulWidget {
  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _selectedIndex = 0;

  final List<String> _icons = [
    'assets/svgicon/home-03.svg',
    'assets/svgicon/add-square.svg',
    'assets/svgicon/reverse-withdrawal-01 (1).svg',
  ];

  final List<Widget> _pages = [
     HomeScreen(),
    ProfileScreen()
  ];

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        icons: iconsList,
        selectedIndex: _selectedIndex,
        onTap: _onTabSelected,
      ),
    );
  }
}
