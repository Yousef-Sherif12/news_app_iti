import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:iti_news_app/home_nav/screens/home_screen.dart';
import 'package:iti_news_app/home_nav/screens/search_screen.dart';

class HomeNav extends StatefulWidget {
  const HomeNav({super.key});

  @override
  State<HomeNav> createState() => _HomeNavState();
}

class _HomeNavState extends State<HomeNav> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List pages = [
      HomeScreen(
        onSearchTap: () {
          setState(() {
            currentIndex = 1;
          });
        },
      ),
      SearchScreen(),
    ];

    return Scaffold(
      body: pages[currentIndex],

      backgroundColor: Color(0xffFFFFFF),
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.transparent,
        color: const Color(0xff001F3F),
        buttonBackgroundColor: Color(0xffFFA500),
        height: 55,
        items: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: currentIndex == 0 ? 0.0 : 20),
            child: Icon(Icons.home, size: 35, color: Colors.white),
          ),
          Padding(
            padding: EdgeInsets.only(top: currentIndex == 1 ? 0.0 : 20),
            child: Icon(Icons.search, size: 35, color: Colors.white),
          ),
        ],
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
