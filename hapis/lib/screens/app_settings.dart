import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/helpers/login_session_shared_preferences.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/screens/sign_up_page.dart';
import 'package:hapis/utils/drawer.dart';
import 'package:settings_ui/settings_ui.dart';

import '../helpers/google_signin_api.dart';
import '../models/db_models/user_model.dart';
import '../responsive/responsive_layout.dart';
import '../services/db_services/users_services.dart';
import '../utils/signup_popup.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HAPISAppBar(isLg: false, appBarText: ''),
      drawer: ResponsiveLayout(
          mobileBody: buildDrawer(context, false, 18, 16),
          tabletBody: buildDrawer(context, false, 24, 20)),
      body: Align(
        alignment: Alignment.center,
        child: SettingsList(
          sections: [
            // SettingsSection(tiles: [
            //   SettingsTile(
            //     title: Center(
            //       child: Align(
            //         alignment: Alignment.center,
            //         child: UserAccountsDrawerHeader(
            //           decoration: BoxDecoration(
            //             color: Colors.transparent,
            //           ),
            //           accountName: Text('Your Name'),
            //           accountEmail: Text('user@example.com'),
            //           currentAccountPicture: CircleAvatar(
            //             backgroundImage: AssetImage('assets/images/donorpin.png'),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ]),
            SettingsSection(
              title: Text(
                'Account',
                style: TextStyle(color: HapisColors.lgColor1, fontSize: 18),
              ),
              tiles: [
                SettingsTile(
                  title: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.edit,
                    color: HapisColors.lgColor1,
                  ),
                  onPressed: (BuildContext context) async {
                    if (GoogleSignInApi().isUserSignedIn() == true ||
                        LoginSessionSharedPreferences.getLoggedIn() == true) {
                      String id;
                      bool isGoogle;
                      final googleUser = GoogleSignInApi().getCurrentUser();
                      if (googleUser != null) {
                        id = googleUser.id;
                        isGoogle = true;
                      } else {
                        id = LoginSessionSharedPreferences.getUserID()!;
                        isGoogle = false;
                      }
                      print(id);
                      UserModel user = await UserServices().getUser(id);
                      print(user.firstName);
                      print(user.userID);
                      print(user.pass);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpPage(
                                  normalUser: user,
                                  update: true,
                                  isGoogle: isGoogle)));
                    } else {
                      showDialogSignUp(context);
                    }
                  },
                ),
              ],
            ),
            SettingsSection(
              title: Text(
                'General',
                style: TextStyle(color: HapisColors.lgColor1, fontSize: 18),
              ),
              tiles: [
                SettingsTile(
                  title: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.exit_to_app,
                    color: HapisColors.lgColor3,
                  ),
                  onPressed: (BuildContext context) {
                    // Handle sign out action
                    if (GoogleSignInApi().isUserSignedIn() == true ||
                        LoginSessionSharedPreferences.getLoggedIn() == true) {
                      final user = GoogleSignInApi().getCurrentUser();
                      print(user);
                      if (user != null) {
                        GoogleSignInApi.logout();
                      } else {
                        LoginSessionSharedPreferences.removeNormalUserID();
                        LoginSessionSharedPreferences.setLoggedIn(false);
                      }
                    } else {
                      showDialogSignUp(context);
                    }
                  },
                ),
                SettingsTile(
                  title: Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 16),
                  ),
                  leading: Icon(
                    Icons.delete,
                    color: HapisColors.lgColor2,
                  ),
                  onPressed: (BuildContext context) async {
                    if (GoogleSignInApi().isUserSignedIn() == true ||
                        LoginSessionSharedPreferences.getLoggedIn() == true) {
                      String id;
                      final user = GoogleSignInApi().getCurrentUser();
                      if (user != null) {
                        id = user.id;
                        GoogleSignInApi.logout();
                        int result = await UserServices().deleteUser(id);
                        print(result);
                      } else {
                        id = LoginSessionSharedPreferences.getUserID()!;
                        LoginSessionSharedPreferences.removeNormalUserID();
                        LoginSessionSharedPreferences.setLoggedIn(false);
                        int result = await UserServices().deleteUser(id);
                        print(result);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppHomePage()));
                    } else {
                      showDialogSignUp(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
