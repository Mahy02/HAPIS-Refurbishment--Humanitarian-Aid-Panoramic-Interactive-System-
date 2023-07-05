import 'package:flutter/material.dart';
import 'package:hapis/screens/seekers.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../models/db_models/users_model.dart';
import '../providers/users_provider.dart';
import '../reusable_widgets/app_bar.dart';
import '../reusable_widgets/hapis_elevated_button.dart';
import '../reusable_widgets/sub_text.dart';
import '../utils/drawer.dart';
import 'givers.dart';

///This is our Home page. It has 2 main buttons=> Global statistics and Cities

class Users extends StatefulWidget {
  final String city;
  const Users({super.key, required this.city});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HAPISAppBar(appBarText: ''),
      drawer: buildDrawer(context),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0, left: 80),
                  child:
                      SubText(subTextContent: 'HAPIS Users in ${widget.city}'),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 110.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HapisElevatedButton(
                      elevatedButtonContent: 'Seekers',
                      buttonColor: HapisColors.lgColor2,
                      height: MediaQuery.of(context).size.height * 0.4,
                      imagePath: 'assets/images/seekers.png',
                      imageHeight: MediaQuery.of(context).size.height * 0.25,
                      imageWidth: MediaQuery.of(context).size.height * 0.25,
                      isPoly: false,
                      onpressed: () async {
                        //will show seekers
                        UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);

                        List<UsersModel> seekers = userProvider.seekers;

                        for (UsersModel seeker in seekers) {
                          print(
                              'Seeker: ${seeker.firstName} ${seeker.lastName}');
                          print('ID: ${seeker.userID}');
                          print('City: ${seeker.city}');
                          print(
                              'seekings for others: ${seeker.seekingForOthers}');
                          print('seekings for self: ${seeker.seekingsForSelf}');
                          print(
                              'coordinates: ${seeker.userCoordinates!.latitude}');
                          print(
                              'coordinates: ${seeker.userCoordinates!.longitude}');
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Seekers(
                                    seekersList: seekers, city: widget.city)));
                      }),
                  HapisElevatedButton(
                      elevatedButtonContent: 'Donors',
                      buttonColor: HapisColors.lgColor4,
                      height: MediaQuery.of(context).size.height * 0.4,
                      imagePath: 'assets/images/giver.png',
                      imageHeight: MediaQuery.of(context).size.height * 0.25,
                      imageWidth: MediaQuery.of(context).size.height * 0.25,
                      isPoly: false,
                      onpressed: () {
                        //will show givers
                        UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        List<UsersModel> givers = userProvider.givers;
                        for (UsersModel giver in givers) {
                          print('giver: ${giver.firstName} ${giver.lastName}');
                          print('ID: ${giver.userID}');
                          print('City: ${giver.city}');
                          print('givings made: ${giver.givings}');
                          print(
                              'coordinates: ${giver.userCoordinates!.latitude}');
                          print(
                              'coordinates: ${giver.userCoordinates!.longitude}');
                        }
                        //will display placemark for givers on map
                        ///TO DO:
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Givers(
                                    giversList: givers, city: widget.city)));
                      }),
                ],
              ),
            ),
            /////////////////JUST FOR TESTING, WILL NOT BE IN MAIN UI
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
