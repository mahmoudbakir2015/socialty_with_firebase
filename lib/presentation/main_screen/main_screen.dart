import 'package:flutter/material.dart';
import 'package:socialty_with_firebase/constants/constants.dart';
import 'package:socialty_with_firebase/presentation/home/home_view.dart';
import '../chat/chat.dart';
import '../profile/profile.dart';
import '../search/search.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  List<Widget> screens = const [
    Home(),
    Chat(),
    Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Search(),
              ),
            );
          },
          child: const Icon(
            Icons.search,
          ),
        ),
        actions: const [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Constants.appPadding,
              ),
              child: Text(
                'Sociality',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int value) {
          setState(() {
            currentIndex = value;
          });
        },
        currentIndex: currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'MainScreen',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
