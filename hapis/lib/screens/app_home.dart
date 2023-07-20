import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/donations.dart';
import 'package:hapis/screens/requests.dart';
import 'package:hapis/screens/users.dart';
import 'package:hapis/utils/drawer.dart';

import 'matchings.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int currentIndex = 0;
  final screens = const [
    //UsersPage(),
    ResponsiveLayout(
        mobileBody: UsersPage(
          fontSize: 20,
        ),
        tabletBody: UsersPage(
          fontSize: 30,
        )),
    Requests(),
    Matchings(),
    Donations(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(
        appBarText: '',
        isLg: false,
      ),
      drawer: buildDrawer(context, false),
      body: screens[currentIndex],
      bottomNavigationBar: ResponsiveLayout(
          mobileBody: buildMobileLayout(), tabletBody: buildTabletLayout()),
      floatingActionButton: ResponsiveLayout(
          mobileBody: buildMobileFloatLayout(),
          tabletBody: buildTabletFloatLayout()),
    );
  }

  Widget buildMobileFloatLayout() {
    return FloatingActionButton(
      backgroundColor: HapisColors.primary,
      onPressed: () {},
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }

  Widget buildTabletFloatLayout() {
    return FloatingActionButton(
      backgroundColor: HapisColors.primary,
      onPressed: () {},
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  Widget buildMobileLayout() {
    return BottomNavigationBar(
        //selectedFontSize
        //unselectedFontSize
        //iconSize
        //selectedItemColor:,
        //unselectedItemColor

        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: HapisColors.lgColor1),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_rounded),
              label: 'Requests',
              backgroundColor: HapisColors.lgColor2),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'Matchings',
              backgroundColor: HapisColors.lgColor3),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Donations',
              backgroundColor: HapisColors.lgColor4),
        ]);
  }

  Widget buildTabletLayout() {
    return BottomNavigationBar(
        //selectedFontSize
        //unselectedFontSize
        //iconSize
        //selectedItemColor:,
        //unselectedItemColor
        selectedFontSize: 25,
        unselectedFontSize: 24,
        iconSize: 40,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: HapisColors.lgColor1),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_rounded),
              label: 'Requests',
              backgroundColor: HapisColors.lgColor2),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'Matchings',
              backgroundColor: HapisColors.lgColor3),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Donations',
              backgroundColor: HapisColors.lgColor4),
        ]);
  }
}
