import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instgram_clone/models/user.dart' as model;
import 'package:instgram_clone/providers/user_provider.dart';
import 'package:instgram_clone/utils/colors.dart';
import 'package:instgram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _pageIndex = 0;
  late PageController pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
    pageController.jumpToPage(index);
  }

  void handlePageChange(int pageIndex) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: handlePageChange,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        onTap: navigationTapped,
        currentIndex: _pageIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              backgroundColor: _pageIndex == 0 ? primaryColor : secondaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              backgroundColor: _pageIndex == 1 ? primaryColor : secondaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              backgroundColor: _pageIndex == 2 ? primaryColor : secondaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              backgroundColor: _pageIndex == 3 ? primaryColor : secondaryColor,
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              backgroundColor: _pageIndex == 4 ? primaryColor : secondaryColor,
              label: '')
        ],
      ),
    );
  }
}
