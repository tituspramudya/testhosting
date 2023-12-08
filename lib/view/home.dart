import 'package:example/view/gridview.dart';
import 'package:example/view/listAdd.dart';
import 'package:example/view/profile.dart';
import 'package:flutter/material.dart';
// import 'dart:ffi';
import 'package:example/model/user.dart';
import 'package:example/api/userClient.dart';
import 'package:example/repository/register_repository.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void refresh() async {
    List<User> data = await userClient.fetchAll();
    setState(() {
      users = data;
    });
  }

  void printAllUsers() {
    for (User userData in users) {
      print(userData.toString());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _widgetOptions = <Widget>[
    gridView(),
    Center(
      child: Text(
        'Index 2: Navigation',
      ),
    ),
    listAdd(),
    ProfilHalaman(),
  ];

  @override
  Widget build(BuildContext context) {
    printAllUsers();
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category_rounded), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chrome_reader_mode), label: 'My Course'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black, // Set the selected icon color
        selectedLabelStyle: const TextStyle(color: Colors.black),
        unselectedItemColor: Colors.black, // Set the selected icon color
        unselectedLabelStyle: const TextStyle(color: Colors.black),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
