import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/helpers/google_signin_api.dart';
import 'package:hapis/helpers/login_session_shared_preferences.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/donations.dart';
import 'package:hapis/screens/requests.dart';
import 'package:hapis/screens/user_forms.dart';
import 'package:hapis/screens/users.dart';
import 'package:hapis/utils/drawer.dart';

import '../utils/signup_popup.dart';
import 'form_page.dart';
import 'matchings.dart';

class AppHomePage extends StatefulWidget {
  const AppHomePage({super.key});

  @override
  State<AppHomePage> createState() => _AppHomePageState();
}

class _AppHomePageState extends State<AppHomePage> {
  int currentIndex = 0;
  final screens = [
    ResponsiveLayout(
        mobileBody: UsersPage(
          fontSize: 20,
        ),
        tabletBody: UsersPage(
          fontSize: 30,
        )),
    ResponsiveLayout(
        mobileBody: UserForms(
          fontSize: 18,
          subHeadFontSize: 20,
          editSize: 20,
          deleteSize: 25,
        ),
        tabletBody: UserForms(
          fontSize: 24,
          subHeadFontSize: 28,
          editSize: 20,
          deleteSize: 25,
        )),
    ResponsiveLayout(
        mobileBody: Requests(
          fontSize: 18,
          subHeadFontSize: 20,
          buttonFontSize: 14,
        ),
        tabletBody: Requests(
          fontSize: 24,
          subHeadFontSize: 28,
          buttonFontSize: 20,
        )),
    ResponsiveLayout(
      mobileBody: Matchings(
        fontSize: 18,
        subHeadFontSize: 22,
        buttonFontSize: 14,
      ),
      tabletBody: Matchings(
        fontSize: 24,
        subHeadFontSize: 28,
        buttonFontSize: 20,
      ),
    ),
    ResponsiveLayout(
      mobileBody: Donations(
        fontSize: 18,
        subHeadFontSize: 22,
        buttonFontSize: 14,
      ),
      tabletBody: Donations(
        fontSize: 24,
        subHeadFontSize: 28,
        buttonFontSize: 20,
      ),
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(
        appBarText: '',
        isLg: false,
      ),
      drawer: ResponsiveLayout(
          mobileBody: buildDrawer(context, false, 18, 16),
          tabletBody: buildDrawer(context, false, 24, 20)),
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
      onPressed: () {
        if (GoogleSignInApi().isUserSignedIn() == true ||
            LoginSessionSharedPreferences.getLoggedIn() == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateForm(
                        type: null,
                        selectedDates: [],
                        update: false,
                        formID: 0,
                      )));
        } else {
          showDialogSignUp(context);
        }
      },
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }

  Widget buildTabletFloatLayout() {
    return FloatingActionButton(
      backgroundColor: HapisColors.primary,
      onPressed: () {
        if (GoogleSignInApi().isUserSignedIn() == true ||
            LoginSessionSharedPreferences.getLoggedIn() == true) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CreateForm(
                        type: null,
                        selectedDates: [],
                        update: false,
                        formID: 0,
                      )));
        } else {
          showDialogSignUp(context);
        }
      },
      child: const Icon(
        Icons.add,
        size: 40,
      ),
    );
  }

  Widget buildMobileLayout() {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (GoogleSignInApi().isUserSignedIn() == true ||
              LoginSessionSharedPreferences.getLoggedIn() == true) {
            setState(() {
              currentIndex = index;
            });
          } else {
            showDialogSignUp(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: HapisColors.lgColor1),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'My Forms',
              backgroundColor: HapisColors.lgColor2),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_rounded),
              label: 'Requests',
              backgroundColor: HapisColors.lgColor3),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'Matchings',
              backgroundColor: HapisColors.lgColor4),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Donations',
              backgroundColor: HapisColors.lgColor1),
        ]);
  }

  Widget buildTabletLayout() {
    return BottomNavigationBar(
        selectedFontSize: 25,
        unselectedFontSize: 24,
        iconSize: 40,
        currentIndex: currentIndex,
        onTap: (index) {
          if (GoogleSignInApi().isUserSignedIn() == true ||
              LoginSessionSharedPreferences.getLoggedIn() == true) {
            setState(() {
              currentIndex = index;
            });
          } else {
            showDialogSignUp(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
              backgroundColor: HapisColors.lgColor1),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              label: 'My Forms',
              backgroundColor: HapisColors.lgColor2),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add_alt_1_rounded),
              label: 'Requests',
              backgroundColor: HapisColors.lgColor3),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows),
              label: 'Matchings',
              backgroundColor: HapisColors.lgColor4),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Donations',
              backgroundColor: HapisColors.lgColor1),
        ]);
  }
}
