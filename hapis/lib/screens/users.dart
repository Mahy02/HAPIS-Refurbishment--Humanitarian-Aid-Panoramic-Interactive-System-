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

///This is the `users` class in a certain given `city` as input to the widget
///It consists of 2 buttons, `seekers` and `givers` from the [HapisElevatedButton] custom widget with an image provided

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
                        ///retrieving the `list of seekers` from the `user provider` and saving them in `seekers`
                        UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        List<UsersModel> seekers = userProvider.seekers;

                        /// navigating to the `Seekers` page with the `seekers` and the `city` from the widget input
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
                        ///retrieving the `list of givers` from the `user provider` and saving them in `givers`
                        UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        List<UsersModel> givers = userProvider.givers;

                        /// navigating to the `Givers` page with the `givers` and the `city` from the widget input
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Givers(
                                    giversList: givers, city: widget.city)));
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
