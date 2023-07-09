
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/db_models/users_model.dart';
import 'package:hapis/services/LG_balloon_services/user_balloon_service.dart';
import 'package:provider/provider.dart';

import '../models/kml/KMLModel.dart';
import '../models/kml/look_at_model.dart';
import '../models/kml/placemark_model.dart';

import '../providers/ssh_provider.dart';
import '../services/LG_functionalities.dart';
import '../utils/pop_up_connection.dart';

class UserElevatedButton extends StatefulWidget {
  final String elevatedButtonContent;
  final String type;
  final UsersModel user;

  const UserElevatedButton({
    required this.elevatedButtonContent,
    required this.type,
    required this.user,
    super.key,
  });

  @override
  State<UserElevatedButton> createState() => _UserElevatedButtonState();
}

class _UserElevatedButtonState extends State<UserElevatedButton> {
  PlacemarkModel? _userPlacemark;

  bool seeker = false;

  /// Views a `user stats and info` into the Google Earth.
  void _viewUserStats(UsersModel user, bool showBalloon, BuildContext context,
      {double orbitPeriod = 2.8, bool updatePosition = true}) async {
    if (widget.type == 'seeker') {
      seeker = true;
    }
    final sshData = Provider.of<SSHprovider>(context, listen: false);
    print("here");
    final UserBalloonService userService = UserBalloonService();
    print("inside view user");

    print('seeker: $seeker');
    print('showBallon: $showBalloon');

    final placemark = userService.buildUserPlacemark(
      user,
      showBalloon,
      seeker, //if seeker then true
      orbitPeriod,
      lookAt: _userPlacemark != null && !updatePosition
          ? _userPlacemark!.lookAt
          : null,
      updatePosition: updatePosition,
    );

    setState(() {
      _userPlacemark = placemark;
    });

    try {
      print('clearing kml before another balloon');
      debugPrint('debug before clear kml');
      await LgService(sshData).clearKml();
      debugPrint('debug after clear kml');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    //  according to user if seeker or giver
    final kmlBalloon = KMLModel(
      name: 'HAPIS-USER-balloon',
      content: placemark.balloonOnlyTag,
    );

    print("kml content before sending it to slave");
    print(kmlBalloon.content);
    print(kmlBalloon.body);
    try {
      debugPrint('debug before send kml');
      await LgService(sshData).sendKMLToSlave(
        LgService(sshData).balloonScreen,
        kmlBalloon.body,
      );
      debugPrint('debug after send  kml');
      print('sent');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    if (updatePosition) {
      await LgService(sshData).flyTo(LookAtModel(
        latitude: user.userCoordinates!.latitude,
        longitude: user.userCoordinates!.longitude,
        altitude: 0,
        range: '300',
        tilt: '0',
        heading: '0',
      ));
    }

    await Future.delayed(Duration(seconds: 5));
    String query = 'echo "exittour=true" > /tmp/query.txt ';
    try {
      await sshData.execute(query);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
    final orbit = userService.buildOrbit(user);
    try {
      await LgService(sshData).sendTour(orbit, 'Orbit');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.15,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              primary: HapisColors.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 2,
              shadowColor: HapisColors.primary,
              side: const BorderSide(color: HapisColors.lgColor3, width: 1)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    widget.elevatedButtonContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: GoogleFonts.montserrat().fontFamily,
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HapisColors.lgColor1,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: GestureDetector(
                          child: Image.asset(
                            'assets/images/info.png',
                            height: MediaQuery.of(context).size.height * 0.18,
                            width: MediaQuery.of(context).size.height * 0.06,
                          ),
                          onTap: () async {
                            // final connection = Provider.of<Connectionprovider>(
                            //     context,
                            //     listen: false);
                            // final socket = await SSHSocket.connect(
                            //     connection.connectionFormData.ip,
                            //     connection.connectionFormData.port);
                            // final sshData = Provider.of<SSHprovider>(context,
                            //     listen: false);
                            // print('before calling view stats');
                            // try {
                            //   print('clearing kml before another balloon');
                            //   debugPrint('debug before clear kml');
                            //   await LgService(sshData).clearKml();
                            //   debugPrint('debug after clear kml');
                            // } catch (e) {
                            //   // ignore: avoid_print
                            //   print(e);
                            // }
                            // print('after calling clear before view stats');
                            _viewUserStats(widget.user, true, context);
                            // print('after view user stats');
                            //                         print(
                            //                             'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA');

                            //                         await Future.delayed(Duration(seconds: 15));
                            //                         print(_userPlacemark!.balloonOnlyTag);
                            //                         String balloon_trial = '''
                            //   <b><font size="+2">'Personal Information & statistics'<font color="#5D5D5D"></font></font></b>
                            //   <br/><br/>
                            //   <b>Name:</b> Mahy
                            //   <br/>
                            //   <b>Phone Number:</b> bla
                            //   <br/>
                            //   <b>Email:</b> bla
                            //   <br/>
                            //   <b>Total Number seekings made for self:</b> bla
                            //   <br/>
                            //   <b>Total Number seekings made for others:</b> bla
                            //   <br/>
                            // ''';
                            //                         final kmlBalloon = KMLModel(
                            //                           name: 'HAPIS-USER-balloon',
                            //                           // content: _userPlacemark!.balloonOnlyTag,
                            //                           content: balloon_trial,
                            //                         );
                            //                         try {
                            //                           debugPrint('debug before send kml');
                            //                           await LgService(sshData).sendKMLToSlave(
                            //                             1,
                            //                             kmlBalloon.body,
                            //                           );
                            //                           debugPrint('debug after send  kml');
                            //                           print('sent');
                            //                         } catch (e) {
                            //                           // ignore: avoid_print
                            //                           print(e);
                            //                         }
                          },
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: HapisColors.lgColor4,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: GestureDetector(
                            child: Image.asset(
                              'assets/images/orbit.png',
                              height: MediaQuery.of(context).size.height * 0.18,
                              width: MediaQuery.of(context).size.height * 0.06,
                            ),
                            onTap: () async {
                              final sshData = Provider.of<SSHprovider>(context,
                                  listen: false);

                              // final connection =
                              //     Provider.of<Connectionprovider>(context,
                              //         listen: false);
                              // final socket = await SSHSocket.connect(
                              //     connection.connectionFormData.ip,
                              //     connection.connectionFormData.port);

                              if (sshData.client != null) {
                                try {
                                  await LgService(sshData).stopTour();
                                  await LgService(sshData).startTour('Orbit');
                                  print("awaiting orbit");
                                } catch (e) {
                                  // ignore: avoid_print
                                  print(e);
                                }
                              } else {
                                showDialogConnection(context);
                              }
                            },
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
