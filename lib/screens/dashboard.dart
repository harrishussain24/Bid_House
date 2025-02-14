// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:bidhouse/constants.dart';
import 'package:bidhouse/models/authenticationModel.dart';
import 'package:bidhouse/screens/favourites.dart';
import 'package:bidhouse/screens/home.dart';
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
    name: "",
    email: "",
    phoneNo: "",
    userType: "",
  );
  int _selectedIndex = 0;
  late List<Widget> _pages;
  bool isLoading = true;
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
      isLoading = false;
      _initializePages();
    });
  }

  void _initializePages() {
    _pages = [
      HomeScreen(userData: authenticationModel),
      FavouritesScreen(userData: authenticationModel),
      ProfileScreen(userData: authenticationModel),
    ];
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: _pages.isNotEmpty
                  ? _pages[_selectedIndex]
                  : Center(child: Text('No pages available')),
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
              Icons.favorite,
              color: Color(0xFF607d8b),
            ),
            label: 'Favourite',
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
