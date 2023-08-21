import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';

/// This is a widget responsible for showing the user some instruction that might help while using the app
class HowItWorksPage extends StatelessWidget {
  final bool isLg;
  const HowItWorksPage({super.key, required this.isLg});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ResponsiveLayout(
          mobileBody: mobileBody(context), tabletBody: tabletBody(context)),
    );
  }

  Widget mobileBody(BuildContext context) {
    return Scaffold(
      appBar: HAPISAppBar(isLg: isLg, appBarText: ''),
      drawer: buildDrawer(context, isLg, 18, 16),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HowToSection(
              isTablet: false,
              title: 'How to Connect?',
              color: HapisColors.lgColor1,
              fontSize: 20,
              content:
                  'On the home page, you can see all users using HAPIS who have filled forms as donors or seekers. Filter or search for users who interest you. Expand their title to view their info and send them a request.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Requests',
              color: HapisColors.lgColor2,
              fontSize: 20,
              content:
                  'In the requests tab of the bottom navigation, you can view sent and received requests. Delete sent requests or accept/reject received requests. Accepted requests trigger the donation process automatically and can be viewed in the donations tab.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Matchings',
              color: HapisColors.lgColor3,
              fontSize: 20,
              content:
                  'HAPIS helps you find matches with similar needs. Check the matchings tab in the bottom navigation. Ignore or accept matches. When both users accept, the donation process starts, visible in the donations tab.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Donations',
              color: HapisColors.lgColor4,
              fontSize: 20,
              content:
                  'Track ongoing donations in the donations tab. Upon delivering the item, both users must accept the request. Cancel donations in case of issues, requiring confirmation from the other user.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Creating Forms',
              color: HapisColors.lgColor1,
              fontSize: 20,
              content:
                  'Easily create forms as a donor or seeker from the (+) icon. See your forms in the forms tab. View, delete, or edit forms in the forms tab, but not for forms linked to ongoing donations.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Notifications',
              color: HapisColors.lgColor2,
              fontSize: 20,
              content:
                  'Access notifications by opening the side menu, selecting settings, and clicking on notifications.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Editing/Deleting Profile',
              color: HapisColors.lgColor3,
              fontSize: 20,
              content:
                  'Edit or delete your profile by opening the side menu, selecting settings, and choosing edit profile for editing or delete account to remove your account.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Signing Out & Signing In',
              color: HapisColors.lgColor4,
              fontSize: 20,
              content:
                  'To access forms, matchings, and donations, sign in first. Do this from the side menu by selecting settings and clicking on sign in. Sign out similarly.',
            ),
            HowToSection(
              isTablet: false,
              title: 'Liquid Galaxy',
              color: HapisColors.lgColor1,
              fontSize: 20,
              content:
                  'If you have a Liquid Galaxy setup, try the Liquid Galaxy view!',
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Enjoy HAPIS! ❤️🌍😄',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabletBody(BuildContext context) {
    return Scaffold(
      appBar: HAPISAppBar(isLg: isLg, appBarText: ''),
      drawer: buildDrawer(context, isLg, 24, 20),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HowToSection(
              isTablet: true,
              title: 'How to Connect?',
              color: HapisColors.lgColor1,
              fontSize: 30,
              content:
                  'On the home page, you can see all users using HAPIS who have filled forms as donors or seekers. Filter or search for users who interest you. Expand their title to view their info and send them a request.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Requests',
              color: HapisColors.lgColor2,
              fontSize: 30,
              content:
                  'In the requests tab of the bottom navigation, you can view sent and received requests. Delete sent requests or accept/reject received requests. Accepted requests trigger the donation process automatically and can be viewed in the donations tab.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Matchings',
              color: HapisColors.lgColor3,
              fontSize: 30,
              content:
                  'HAPIS helps you find matches with similar needs. Check the matchings tab in the bottom navigation. Ignore or accept matches. When both users accept, the donation process starts, visible in the donations tab.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Donations',
              color: HapisColors.lgColor4,
              fontSize: 30,
              content:
                  'Track ongoing donations in the donations tab. Upon delivering the item, both users must accept the request. Cancel donations in case of issues, requiring confirmation from the other user.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Creating Forms',
              color: HapisColors.lgColor1,
              fontSize: 30,
              content:
                  'Easily create forms as a donor or seeker from the (+) icon. See your forms in the forms tab. View, delete, or edit forms in the forms tab, but not for forms linked to ongoing donations.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Notifications',
              color: HapisColors.lgColor2,
              fontSize: 30,
              content:
                  'Access notifications by opening the side menu, selecting settings, and clicking on notifications.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Editing/Deleting Profile',
              color: HapisColors.lgColor3,
              fontSize: 30,
              content:
                  'Edit or delete your profile by opening the side menu, selecting settings, and choosing edit profile for editing or delete account to remove your account.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Signing Out & Signing In',
              color: HapisColors.lgColor4,
              fontSize: 30,
              content:
                  'To access forms, matchings, and donations, sign in first. Do this from the side menu by selecting settings and clicking on sign in. Sign out similarly.',
            ),
            HowToSection(
              isTablet: true,
              title: 'Liquid Galaxy',
              color: HapisColors.lgColor1,
              fontSize: 30,
              isLG: true,
              content:
                  'If you have a Liquid Galaxy setup, try the Liquid Galaxy view now by switching to the liquid galaxy view from the app bar. Remember to connect to your LG first before trying it out!',
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                'Enjoy HAPIS! ❤️🌍😄',
                style: TextStyle(fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HowToSection extends StatelessWidget {
  final String title;
  final String content;
  final Color color;
  final double fontSize;
  final bool isTablet;
  bool? isLG = false;

  HowToSection(
      {required this.title,
      required this.content,
      required this.color,
      required this.fontSize,
      required this.isTablet,
      this.isLG});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: fontSize + 3,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(content,
              style: TextStyle(color: Colors.white, fontSize: fontSize)),
        ],
      ),
    );
  }
}
