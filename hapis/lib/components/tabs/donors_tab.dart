import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/db_models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../reusable_widgets/no_component.dart';
import '../../reusable_widgets/user_app_component.dart';
import '../../services/db_services/users_services.dart';

class DonorsTab extends StatefulWidget {
  const DonorsTab({Key? key}) : super(key: key);

  @override
  State<DonorsTab> createState() => _DonorsTabState();
}

class _DonorsTabState extends State<DonorsTab> {
  List<UserModel> usersList = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getUsers();
    });
  }

  void getUsers() async {
    UserAppProvider userProvider =
        Provider.of<UserAppProvider>(context, listen: false);

    userProvider.clearDataApp();
    await UserServices().getUsersInfo('giver', context);

    setState(() {
      usersList = userProvider.giversApp;
      print("donors length");
      print(usersList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: buildMobileLayout(), tabletBody: buildTabletLayout());
  }

  Widget buildMobileLayout() {
    final noSeekers = usersList.isEmpty;

    return noSeekers
        ? const NoComponentWidget(
            displayText: 'You don\'t have any donors', icon: Icons.person)
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: HapisColors.primary,
              onPressed: () {},
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  final UserModel user = usersList[index];

                  return Column(
                    children: [
                      UserAppComponent(
                        user: user,
                        expansionTitleFontSize: 22,
                        imageHeight: MediaQuery.of(context).size.height * 0.03,
                        imageWidth: MediaQuery.of(context).size.width * 0.07,
                        userImageHeight:
                            MediaQuery.of(context).size.height * 0.1,
                        userImageWidth: MediaQuery.of(context).size.width * 0.1,
                        headerFontSize: 18,
                        textFontSize: 16,
                        containerHeight:
                            MediaQuery.of(context).size.height * 0.8,
                        containerWidth: MediaQuery.of(context).size.width * 0.9,
                      ),
                      Divider(
                        height: 3,
                        thickness: 0.5,
                        color: HapisColors.lgColor3,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      )
                    ],
                  );
                },
              ),
            ),
          );
  }

  Widget buildTabletLayout() {
    final noSeekers = usersList.isEmpty;

    return noSeekers
        ? const NoComponentWidget(
            displayText: 'You don\'t have any donors', icon: Icons.person)
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 40,
              ),
              backgroundColor: HapisColors.primary,
              onPressed: () {},
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: usersList.length,
                itemBuilder: (context, index) {
                  final UserModel user = usersList[index];

                  return Column(
                    children: [
                      UserAppComponent(
                        user: user,
                        expansionTitleFontSize: 28,
                        imageHeight: MediaQuery.of(context).size.height * 0.04,
                        imageWidth: MediaQuery.of(context).size.width * 0.03,
                        userImageHeight:
                            MediaQuery.of(context).size.height * 0.15,
                        userImageWidth:
                            MediaQuery.of(context).size.width * 0.15,
                        headerFontSize: 30,
                        textFontSize: 28,
                        containerHeight:
                            MediaQuery.of(context).size.height * 1.5,
                        containerWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      Divider(
                        height: 3,
                        thickness: 0.5,
                        color: HapisColors.lgColor3,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      )
                    ],
                  );
                },
              ),
            ),
          );
  }
}

// width: MediaQuery.of(context).size.width * 0.07,
            //height: MediaQuery.of(context).size.height * 0.03,

            //fontsize 22
            // 18
            //16
            //