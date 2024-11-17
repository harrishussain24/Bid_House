// ignore_for_file: prefer_const_constructors

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/screens/chats.dart';
import 'package:bidhouse/screens/home.dart';
import 'package:bidhouse/screens/plotInfo.dart';
import 'package:bidhouse/screens/profile.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color color = AppConstants.appColor;
  int _selectedIndex = 0;
  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    PlotInfoScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xFF607d8b),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.info,
              color: Color(0xFF607d8b),
            ),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Color(0xFF607d8b),
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color(0xFF607d8b),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF607d8b),
        onTap: _onItemTapped,
      ),
    );
  }
}
