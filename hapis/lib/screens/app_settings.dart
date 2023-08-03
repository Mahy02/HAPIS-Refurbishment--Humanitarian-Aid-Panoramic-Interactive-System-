import 'package:flutter/material.dart';
import 'package:hapis/helpers/login_session_shared_preferences.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/utils/drawer.dart';

import '../helpers/google_signin_api.dart';
import '../responsive/responsive_layout.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HAPISAppBar(isLg: false, appBarText: ''),
      drawer:  ResponsiveLayout(
          mobileBody: buildDrawer(context, false, 18, 16),
          tabletBody: buildDrawer(context, false, 24, 20)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                String id;
                final user = GoogleSignInApi().getCurrentUser();
                if (user != null) {
                  GoogleSignInApi.logout();
                } else {
                  LoginSessionSharedPreferences.removeNormalUserID();
                  LoginSessionSharedPreferences.setLoggedIn(false);
                }

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AppHomePage()));
              },
              iconSize: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Sign Out',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
