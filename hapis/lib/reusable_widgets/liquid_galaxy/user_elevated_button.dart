import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/liquid_galaxy/balloon_models/users_model.dart';
import 'package:provider/provider.dart';

import '../../models/liquid_galaxy/kml/KMLModel.dart';
import '../../models/liquid_galaxy/kml/look_at_model.dart';
import '../../models/liquid_galaxy/kml/placemark_model.dart';
import '../../providers/liquid_galaxy/ssh_provider.dart';
import '../../services/liquid_galaxy/LG_placemarks_services/user_balloon_service.dart';
import '../../services/liquid_galaxy/LG_functionalities.dart';
import '../../utils/pop_up_connection.dart';

/// This is a custom widget, `UserElevatedButton` for displaying the user button in the liquid galaxy view
/// It takes the following inputs
/// - * [elevatedButtonContent] which is required for content displayed on the button
/// - * [type] which is a required to determine whether user was seeker or giver
/// - * [user] which is a required [UsersModel] for displaying the user statistics
/// - * [height] and [width] which are required for having a responsive layout
/// - * [imageHeight] and [imageWidth] which are optional if image exists to adapt to different layouts

class UserElevatedButton extends StatefulWidget {
  final String elevatedButtonContent;
  final String type;
  final UsersModel user;
  final double height;
  final double width;
  final double? imageHeight;
  final double? imageWidth;

  const UserElevatedButton({
    required this.elevatedButtonContent,
    required this.type,
    required this.user,
    required this.height,
    required this.width,
    super.key, this.imageHeight, this.imageWidth,
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

    final UserBalloonService userService = UserBalloonService();

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

    final kmlBalloon = KMLModel(
      name: 'HAPIS-USER-balloon',
      content: placemark.balloonOnlyTag,
    );

    await Future.delayed(Duration(seconds: 3));
    try {
      await LgService(sshData).sendKMLToSlave(
        LgService(sshData).balloonScreen,
        kmlBalloon.body,
      );
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

    await Future.delayed(Duration(seconds: 3));

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
        height: widget.height,
        width: widget.width,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
              backgroundColor: HapisColors.accent,
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
                            height: widget.imageHeight,
                            width: widget.imageWidth,
                          ),
                          onTap: () async {
                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);
                            try {
                              await LgService(sshData).clearKml();
                            } catch (e) {
                              // ignore: avoid_print
                              print(e);
                            }
                            _viewUserStats(widget.user, true, context);
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
                          child: Icon(
                            Icons.play_arrow,
                            size: 35,
                            color: HapisColors.lgColor1,
                          ),
                          onTap: () async {
                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);

                            if (sshData.client != null) {
                              try {
                                await LgService(sshData).stopTour();
                                await LgService(sshData).startTour('Orbit');
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                              }
                            } else {
                              showDialogConnection(context);
                            }
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: HapisColors.lgColor2,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: GestureDetector(
                          child: Icon(
                            Icons.pause_circle,
                            size: 35,
                            color: HapisColors.lgColor1,
                          ),
                          onTap: () async {
                            final sshData = Provider.of<SSHprovider>(context,
                                listen: false);

                            if (sshData.client != null) {
                              try {
                                await LgService(sshData).stopTour();
                              } catch (e) {
                                // ignore: avoid_print
                                print(e);
                              }
                            } else {
                              showDialogConnection(context);
                            }
                          },
                        ),
                      ),
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
