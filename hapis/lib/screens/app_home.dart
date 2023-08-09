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
import 'package:hapis/services/db_services/donations_db_services.dart';
import 'package:hapis/services/db_services/matchings_db_services.dart';
import 'package:hapis/services/db_services/requests_db_services.dart';
import 'package:hapis/utils/drawer.dart';
import 'package:badges/badges.dart' as badges;

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
          fontSize: 25,
          subHeadFontSize: 28,
          editSize: 40,
          deleteSize: 45,
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

  late String userId;
  int totalRequestsCount = 0;
  int totalMatchingsCount = 0;
  int totalDonationsCount = 0;

  @override
  void initState() {
    super.initState();
    if (GoogleSignInApi().isUserSignedIn() == true ||
        LoginSessionSharedPreferences.getLoggedIn() == true) {
      final user = GoogleSignInApi().getCurrentUser();
      if (user != null) {
        userId = user.id;
      } else {
        userId = LoginSessionSharedPreferences.getUserID()!;
      }
    } else {
      userId = '0';
    }
  }

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
    return FutureBuilder<List<int>>(
        future: Future.wait([
          RequestsServices().getRequestsSentCount(userId),
          RequestsServices().getRequestsReceivedCount(userId),
          MatchingsServices().getMatchingsCount(userId),
          DonationsServices().getInProgressDonationsCount(userId)
        ]),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //    return CircularProgressIndicator();
          // } else
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<int> counts = snapshot.data ?? [0, 0, 0, 0];
            int sentRequestsCount = counts[0];
            int receivedRequestsCount = counts[1];
            totalMatchingsCount = counts[2];
            totalDonationsCount = counts[3];

            totalRequestsCount = sentRequestsCount + receivedRequestsCount;

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
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                      backgroundColor: HapisColors.lgColor1),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.assignment_outlined),
                      label: 'My Forms',
                      backgroundColor: HapisColors.lgColor2),
                  if (totalRequestsCount != 0)
                    BottomNavigationBarItem(
                      icon: badges.Badge(
                        badgeContent: Text(
                          totalRequestsCount.toString(),
                          style: TextStyle(color: HapisColors.lgColor2),
                        ),
                        badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                        child: Icon(Icons.person_add_alt_1_rounded),
                      ),
                      label: 'Requests',
                      backgroundColor: HapisColors.lgColor3,
                    ),
                  if (totalRequestsCount == 0)
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add_alt_1_rounded),
                      label: 'Requests',
                      backgroundColor: HapisColors.lgColor3,
                    ),
                  if (totalMatchingsCount != 0)
                    BottomNavigationBarItem(
                        icon: badges.Badge(
                          badgeContent: Text(
                            totalMatchingsCount.toString(),
                            style: TextStyle(color: HapisColors.lgColor2),
                          ),
                          badgeStyle:
                              badges.BadgeStyle(badgeColor: Colors.white),
                          child: Icon(Icons.compare_arrows),
                        ),
                        label: 'Matchings',
                        backgroundColor: HapisColors.lgColor4),
                  if (totalMatchingsCount == 0)
                    BottomNavigationBarItem(
                        icon: Icon(Icons.compare_arrows),
                        label: 'Matchings',
                        backgroundColor: HapisColors.lgColor4),
                  if (totalDonationsCount != 0)
                    BottomNavigationBarItem(
                        icon: badges.Badge(
                          badgeContent: Text(
                            totalDonationsCount.toString(),
                            style: TextStyle(color: HapisColors.lgColor2),
                          ),
                          badgeStyle:
                              badges.BadgeStyle(badgeColor: Colors.white),
                          child: Icon(Icons.favorite),
                        ),
                        label: 'Donations',
                        backgroundColor: HapisColors.lgColor1),
                  if (totalDonationsCount == 0)
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Donations',
                        backgroundColor: HapisColors.lgColor1),
                ]);
          }
        });
  }

  Widget buildTabletLayout() {
    return FutureBuilder<List<int>>(
        future: Future.wait([
          RequestsServices().getRequestsSentCount(userId),
          RequestsServices().getRequestsReceivedCount(userId),
          MatchingsServices().getMatchingsCount(userId),
          DonationsServices().getInProgressDonationsCount(userId)
        ]),
        builder: (context, snapshot) {
          // if (snapshot.connectionState == ConnectionState.waiting) {
          //    return CircularProgressIndicator();
          // } else
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<int> counts = snapshot.data ?? [0, 0, 0, 0];
            int sentRequestsCount = counts[0];
            int receivedRequestsCount = counts[1];
            totalMatchingsCount = counts[2];
            totalDonationsCount = counts[3];

            totalRequestsCount = sentRequestsCount + receivedRequestsCount;

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
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                      backgroundColor: HapisColors.lgColor1),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.assignment_outlined),
                      label: 'My Forms',
                      backgroundColor: HapisColors.lgColor2),
                  if (totalRequestsCount != 0)
                    BottomNavigationBarItem(
                      icon: badges.Badge(
                        badgeContent: Text(
                          totalRequestsCount.toString(),
                          style: TextStyle(color: HapisColors.lgColor2),
                        ),
                        badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                        child: Icon(Icons.person_add_alt_1_rounded),
                      ),
                      label: 'Requests',
                      backgroundColor: HapisColors.lgColor3,
                    ),
                  if (totalRequestsCount == 0)
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add_alt_1_rounded),
                      label: 'Requests',
                      backgroundColor: HapisColors.lgColor3,
                    ),
                  if (totalMatchingsCount != 0)
                    BottomNavigationBarItem(
                        icon: badges.Badge(
                          badgeContent: Text(
                            totalMatchingsCount.toString(),
                            style: TextStyle(color: HapisColors.lgColor2),
                          ),
                          badgeStyle:
                              badges.BadgeStyle(badgeColor: Colors.white),
                          child: Icon(Icons.compare_arrows),
                        ),
                        label: 'Matchings',
                        backgroundColor: HapisColors.lgColor4),
                  if (totalMatchingsCount == 0)
                    BottomNavigationBarItem(
                        icon: Icon(Icons.compare_arrows),
                        label: 'Matchings',
                        backgroundColor: HapisColors.lgColor4),
                  if (totalDonationsCount != 0)
                    BottomNavigationBarItem(
                        icon: badges.Badge(
                          badgeContent: Text(
                            totalDonationsCount.toString(),
                            style: TextStyle(color: HapisColors.lgColor2),
                          ),
                          badgeStyle:
                              badges.BadgeStyle(badgeColor: Colors.white),
                          child: Icon(Icons.favorite),
                        ),
                        label: 'Donations',
                        backgroundColor: HapisColors.lgColor1),
                  if (totalDonationsCount == 0)
                    BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Donations',
                        backgroundColor: HapisColors.lgColor1),
                ]);
          }
        });
  }
}


/*
BottomNavigationBar(
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
            icon: badges.Badge(
              badgeContent: Text('3'),
              badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
              child: Icon(Icons.person_add_alt_1_rounded),
            ),
            label: 'Requests',
            backgroundColor: HapisColors.lgColor3,
          ),
          BottomNavigationBarItem(
              icon: badges.Badge(
                badgeContent: Text(
                  '3',
                  style: TextStyle(color: HapisColors.lgColor2),
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                child: Icon(Icons.compare_arrows),
              ),
              label: 'Matchings',
              backgroundColor: HapisColors.lgColor4),
          BottomNavigationBarItem(
              icon: badges.Badge(
                badgeContent: Text(
                  '3',
                  style: TextStyle(color: HapisColors.lgColor2),
                ),
                badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                child: Icon(Icons.favorite),
              ),
              label: 'Donations',
              backgroundColor: HapisColors.lgColor1),
        ]);
*/