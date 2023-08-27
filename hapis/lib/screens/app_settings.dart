import 'dart:async';

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
import '../reusable_widgets/back_button.dart';
import '../services/db_services/notifications_services.dart';
import '../services/db_services/users_services.dart';
import '../utils/database_popups.dart';
import '../utils/signup_popup.dart';
import 'google_signup.dart';
import 'notify_screen.dart';

/// The `AppSettings` class represents the settings page of the HAPIS application.
///
/// This page allows users to manage their account settings, notifications,
/// and perform actions such as editing their profile, signing in or out,
/// and deleting their account. It provides a user-friendly interface for users
/// to control various aspects of their app experience.
///
/// The class utilizes the `SettingsUI` package to create a user-friendly settings page
/// with sections and tiles for different settings options. It provides separate layouts
/// for both mobile and tablet devices using the `ResponsiveLayout` widget to ensure a
/// consistent user experience across different screen sizes.
///
class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  /// - `userId`: A string that holds the unique identifier of the current user.
  late String userId;

  /// - `initState()`: Initializes the state of the widget. Checks if the user is signed in
  ///   and retrieves the user ID accordingly.
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

  bool isEditLoading = false;
  bool isDeleteLoading = false;
  @override

  /// - `build(BuildContext context)`: Builds the widget's UI by creating a scaffold with
  ///   an app bar, a drawer, and the main body content. It uses the `ResponsiveLayout` widget
  ///   to display different layouts for mobile and tablet devices.
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HAPISAppBar(isLg: false, appBarText: ''),
      drawer: ResponsiveLayout(
          mobileBody: buildDrawer(context, false, 18, 16),
          tabletBody: buildDrawer(context, false, 24, 20)),
      body: ResponsiveLayout(
          mobileBody: buildMobile(), tabletBody: buildTablet(context)),
    );
  }

  /// - `buildMobile()`: Builds the UI content for mobile devices, including sections and tiles
  ///   for various settings options. It provides options to edit profile, manage notifications,
  ///   sign in or out, and delete the account.
  Widget buildMobile() {
    return Align(
      alignment: Alignment.center,
      child: SettingsList(
        sections: [
          SettingsSection(
            tiles: [
              SettingsTile(
                title: BackButtonWidget(
                  isTablet: false,
                ),
              ),
            ],
          ),
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
                leading: Stack(
                  children: [
                    Icon(
                      Icons.edit,
                      color: HapisColors.lgColor1,
                    ),
                    if (isEditLoading)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      ),
                  ],
                ),
                onPressed: (BuildContext context) async {
                  setState(() {
                    isEditLoading = true;
                  });

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

                    UserModel user = await UserServices().getUser(id);
                    setState(() {
                      isEditLoading = false;
                    });

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
              SettingsTile(
                title: Text(
                  'Notifications',
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(
                  Icons.notifications,
                  color: HapisColors.lgColor4,
                ),
                trailing: FutureBuilder<int>(
                  future: NotificationsServices().getNotificationCount(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      int notificationCount = snapshot.data ?? 0;
                      return CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 10,
                        child: Text(
                          '$notificationCount',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      );
                    }
                  },
                ),
                onPressed: (BuildContext context) {
                  if (GoogleSignInApi().isUserSignedIn() == true ||
                      LoginSessionSharedPreferences.getLoggedIn() == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationPage(
                                  notifyFontSize: 20,
                                  textFontSize: 18,
                                  titleFontSize: 20,
                                )));
                  } else {
                    showDialogSignUp(context);
                  }
                },
              ),
            ],
          ),
          // SettingsSection(
          //   title: Text(
          //     'General',
          //     style: TextStyle(color: HapisColors.lgColor1, fontSize: 18),
          //   ),
          //   tiles: [
          //     SettingsTile(
          //       title: Text(
          //         'Sign In',
          //         style: TextStyle(fontSize: 16),
          //       ),
          //       leading: Icon(
          //         Icons.exit_to_app,
          //         color: HapisColors.lgColor4,
          //       ),
          //       onPressed: (BuildContext context) {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (context) => const GoogleSignUp()));
          //       },
          //     ),
          //     SettingsTile(
          //       title: Text(
          //         'Sign Out',
          //         style: TextStyle(fontSize: 16),
          //       ),
          //       leading: Icon(
          //         Icons.exit_to_app,
          //         color: HapisColors.lgColor3,
          //       ),
          //       onPressed: (BuildContext context) {
          //         // Handle sign out action
          //         if (GoogleSignInApi().isUserSignedIn() == true ||
          //             LoginSessionSharedPreferences.getLoggedIn() == true) {
          //           final user = GoogleSignInApi().getCurrentUser();

          //           if (user != null) {
          //             GoogleSignInApi.logout();
          //           }

          //           LoginSessionSharedPreferences.removeUserID();
          //           LoginSessionSharedPreferences.setLoggedIn(false);
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => const AppHomePage()));
          //         } else {
          //           showDialogSignUp(context);
          //         }
          //       },
          //     ),
          //     SettingsTile(
          //       title: Text(
          //         'Delete Account',
          //         style: TextStyle(fontSize: 16),
          //       ),
          //       leading: Stack(
          //         children: [
          //           Icon(
          //             Icons.delete,
          //             color: HapisColors.lgColor2,
          //           ),
          //           if (isDeleteLoading)
          //             Center(
          //               child: CircularProgressIndicator(
          //                 color: Colors.blue,
          //               ),
          //             ),
          //         ],
          //       ),
          //       onPressed: (BuildContext context) async {
          //         setState(() {
          //           isDeleteLoading = true;
          //         });
          //         if (GoogleSignInApi().isUserSignedIn() == true ||
          //             LoginSessionSharedPreferences.getLoggedIn() == true) {
          //           String id;
          //           final user = GoogleSignInApi().getCurrentUser();
          //           if (user != null) {
          //             id = user.id;

          //             Completer<int> completer = Completer<int>();
          //             showDatabasePopup(
          //                 context, 'Are you sure you want to delete?',
          //                 isWarning: true,
          //                 isError: false,
          //                 isCancel: true, onOKPressed: () async {
          //               GoogleSignInApi.logout();
          //               LoginSessionSharedPreferences.removeUserID();
          //               LoginSessionSharedPreferences.setLoggedIn(false);
          //               int result = await UserServices().deleteUser(id);
          //               completer.complete(result);
          //             }, onCancelPressed: () {
          //               setState(() {
          //                 isDeleteLoading = false;
          //               });
          //             });

          //             int result = await completer.future;

          //             if (result == 1) {
          //               showDatabasePopup(context, 'User deleted successfully!',
          //                   isError: false);
          //             } else if (result == 0) {
          //               showDatabasePopup(context,
          //                   'Error deleting user \n\nPlease try again later.');
          //             }
          //           } else {
          //             id = LoginSessionSharedPreferences.getUserID()!;

          //             Completer<int> completer = Completer<int>();
          //             showDatabasePopup(
          //                 context, 'Are you sure you want to delete?',
          //                 isWarning: true,
          //                 isError: false,
          //                 isCancel: true, onOKPressed: () async {
          //               LoginSessionSharedPreferences.removeUserID();
          //               LoginSessionSharedPreferences.setLoggedIn(false);
          //               int result = await UserServices().deleteUser(id);
          //               completer.complete(result);
          //             }, onCancelPressed: () {
          //               setState(() {
          //                 isDeleteLoading = false;
          //               });
          //             });

          //             int result = await completer.future;

          //             if (result == 1) {
          //               showDatabasePopup(context, 'User deleted successfully!',
          //                   isError: false, onOKPressed: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => const AppHomePage()));
          //               });
          //             } else if (result == 0) {
          //               showDatabasePopup(context,
          //                   'Error deleting user \n\nPlease try again later.');
          //             }
          //           }

          //           // Navigator.push(
          //           //     context,
          //           //     MaterialPageRoute(
          //           //         builder: (context) => const AppHomePage()));
          //         } else {
          //           showDialogSignUp(context);
          //         }
          //         setState(() {
          //           isDeleteLoading = false;
          //         });
          //       },
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  /// - `buildTablet(BuildContext context)`: Builds the UI content for tablet devices, similar to
  ///   the mobile layout, but with larger font sizes and expanded sections to make optimal use
  ///   of the tablet screen size.
  Widget buildTablet(BuildContext context) {
    return Column(
      children: [
        BackButtonWidget(
          isTablet: true,
        ),
        Expanded(
          child: SettingsList(
            lightTheme: SettingsThemeData(settingsListBackground: Colors.white),
            shrinkWrap: false,
            sections: [
              SettingsSection(
                title: Text(
                  'Account',
                  style: TextStyle(color: HapisColors.lgColor1, fontSize: 40),
                ),
                tiles: [
                  SettingsTile(
                    title: Text(
                      'Edit Profile',
                      style: TextStyle(fontSize: 30),
                    ),
                    leading: Stack(
                      children: [
                        Icon(
                          Icons.edit,
                          color: HapisColors.lgColor1,
                        ),
                        if (isEditLoading)
                          Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          ),
                      ],
                    ),
                    onPressed: (BuildContext context) async {
                      setState(() {
                        isEditLoading = true;
                      });
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

                        UserModel user = await UserServices().getUser(id);
                        setState(() {
                          isEditLoading = false;
                        });

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
                  SettingsTile(
                    title: Text(
                      'Notifications',
                      style: TextStyle(fontSize: 30),
                    ),
                    leading: Icon(
                      Icons.notifications,
                      color: HapisColors.lgColor4,
                    ),
                    trailing: FutureBuilder<int>(
                      future:
                          NotificationsServices().getNotificationCount(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int notificationCount = snapshot.data ?? 0;
                          return CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 25,
                            child: Text(
                              '$notificationCount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          );
                        }
                      },
                    ),
                    onPressed: (BuildContext context) {
                      if (GoogleSignInApi().isUserSignedIn() == true ||
                          LoginSessionSharedPreferences.getLoggedIn() == true) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationPage(
                                      notifyFontSize: 26,
                                      textFontSize: 24,
                                      titleFontSize: 38,
                                    )));
                      } else {
                        showDialogSignUp(context);
                      }
                    },
                  ),
                ],
              ),
              SettingsSection(
                tiles: [
                  SettingsTile(
                    title: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ),
                ],
              ),
          //     SettingsSection(
          //       title: Text(
          //         'General',
          //         style: TextStyle(color: HapisColors.lgColor1, fontSize: 40),
          //       ),
          //       tiles: [
          //         SettingsTile(
          //           title: Text(
          //             'Sign In',
          //             style: TextStyle(fontSize: 30),
          //           ),
          //           leading: Icon(
          //             Icons.exit_to_app,
          //             color: HapisColors.lgColor4,
          //           ),
          //           onPressed: (BuildContext context) {
          //             // Handle sign out action
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => const GoogleSignUp()));
          //           },
          //         ),
          //         SettingsTile(
          //           title: Text(
          //             'Sign Out',
          //             style: TextStyle(fontSize: 30),
          //           ),
          //           leading: Icon(
          //             Icons.exit_to_app,
          //             color: HapisColors.lgColor3,
          //           ),
          //           onPressed: (BuildContext context) {
          //             // Handle sign out action
          //             if (GoogleSignInApi().isUserSignedIn() == true ||
          //                 LoginSessionSharedPreferences.getLoggedIn() == true) {
          //               final user = GoogleSignInApi().getCurrentUser();

          //               if (user != null) {
          //                 GoogleSignInApi.logout();
          //               }

          //               LoginSessionSharedPreferences.removeUserID();
          //               LoginSessionSharedPreferences.setLoggedIn(false);
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) => const AppHomePage()));
          //             } else {
          //               showDialogSignUp(context);
          //             }
          //           },
          //         ),
          //         SettingsTile(
          //           title: Text(
          //             'Delete Account',
          //             style: TextStyle(fontSize: 30),
          //           ),
          //           leading: Stack(
          //             children: [
          //               Icon(
          //                 Icons.delete,
          //                 color: HapisColors.lgColor2,
          //               ),
          //               if (isDeleteLoading)
          //                 Center(
          //                   child: CircularProgressIndicator(
          //                     color: Colors.blue,
          //                   ),
          //                 ),
          //             ],
          //           ),
          //           onPressed: (BuildContext context) async {
          //             setState(() {
          //           isDeleteLoading = true;
          //         });
          //         if (GoogleSignInApi().isUserSignedIn() == true ||
          //             LoginSessionSharedPreferences.getLoggedIn() == true) {
          //           String id;
          //           final user = GoogleSignInApi().getCurrentUser();
          //           if (user != null) {
          //             id = user.id;

          //             Completer<int> completer = Completer<int>();
          //             showDatabasePopup(
          //                 context, 'Are you sure you want to delete?',
          //                 isWarning: true,
          //                 isError: false,
          //                 isCancel: true, onOKPressed: () async {
          //               GoogleSignInApi.logout();
          //               LoginSessionSharedPreferences.removeUserID();
          //               LoginSessionSharedPreferences.setLoggedIn(false);
          //               int result = await UserServices().deleteUser(id);
          //               completer.complete(result);
          //             }, onCancelPressed: () {
          //               setState(() {
          //                 isDeleteLoading = false;
          //               });
          //             });

          //             int result = await completer.future;

          //             if (result == 1) {
          //               showDatabasePopup(context, 'User deleted successfully!',
          //                   isError: false);
          //             } else if (result == 0) {
          //               showDatabasePopup(context,
          //                   'Error deleting user \n\nPlease try again later.');
          //             }
          //           } else {
          //             id = LoginSessionSharedPreferences.getUserID()!;

          //             Completer<int> completer = Completer<int>();
          //             showDatabasePopup(
          //                 context, 'Are you sure you want to delete?',
          //                 isWarning: true,
          //                 isError: false,
          //                 isCancel: true, onOKPressed: () async {
          //               LoginSessionSharedPreferences.removeUserID();
          //               LoginSessionSharedPreferences.setLoggedIn(false);
          //               int result = await UserServices().deleteUser(id);
          //               completer.complete(result);
          //             }, onCancelPressed: () {
          //               setState(() {
          //                 isDeleteLoading = false;
          //               });
          //             });

          //             int result = await completer.future;

          //             if (result == 1) {
          //               showDatabasePopup(context, 'User deleted successfully!',
          //                   isError: false, onOKPressed: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) => const AppHomePage()));
          //               });
          //             } else if (result == 0) {
          //               showDatabasePopup(context,
          //                   'Error deleting user \n\nPlease try again later.');
          //             }
          //           }

          //           // Navigator.push(
          //           //     context,
          //           //     MaterialPageRoute(
          //           //         builder: (context) => const AppHomePage()));
          //         } else {
          //           showDialogSignUp(context);
          //         }
          //         setState(() {
          //           isDeleteLoading = false;
          //         });
          //           },
          //         ),
          //       ],
          //     ),
            ],
          ),
        ),
      ],
    );
  }
}
