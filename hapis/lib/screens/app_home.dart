import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/users.dart';
import 'package:hapis/utils/drawer.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int currentIndex = 0;
  final screens = const [
    UsersPage(),
    Center(
      child: Text('bla'),
    ),
    Center(
      child: Text('blaa'),
    ),
    Center(
      child: Text('blaaaaaa'),
    ),
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
        bottomNavigationBar: BottomNavigationBar(
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
            ]));
  }
}
