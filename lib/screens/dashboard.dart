// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/chats.dart';
import 'package:bidhouse/screens/home.dart';
import 'package:bidhouse/screens/plotInfo.dart';
import 'package:bidhouse/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Color color = AppConstants.appColor;
  AuthenticationModel authenticationModel = AuthenticationModel(
      name: "", email: "", phoneNo: "", userType: "", password: "");
  int _selectedIndex = 0;
  late List<Widget> _pages;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      authenticationModel.id = prefs.getString('id') ?? '';
      authenticationModel.email = prefs.getString('email') ?? '';
      authenticationModel.name = prefs.getString('name') ?? '';
      authenticationModel.phoneNo = prefs.getString('phoneNo') ?? '';
      authenticationModel.userType = prefs.getString('userType') ?? '';
      authenticationModel.imageUrl = prefs.getString('imageUrl') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _pages = [
      HomeScreen(userData: authenticationModel),
      PlotInfoScreen(userData: authenticationModel),
      ChatsScreen(),
      ProfileScreen(userData: authenticationModel),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.isNotEmpty
            ? _pages[_selectedIndex]
            : Center(child: CircularProgressIndicator()),
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
