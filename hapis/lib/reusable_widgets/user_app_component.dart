import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/db_models/user_model.dart';
import 'package:hapis/services/db_services/requests_db_services.dart';

import '../helpers/google_signin_api.dart';
import '../helpers/login_session_shared_preferences.dart';
import '../utils/database_popups.dart';
import '../utils/date_popup.dart';
import '../utils/signup_popup.dart';

/// custom widget `UserAppComponent` that displays the user component in the main app view
/// It takes:
/// - `user` which represents a [UserModel]
/// - `imageHeight`  `imageWidth` `expansionTitleFontSize` `containerHeight` `containerWidth` `userImageHeight` `userImageWidth` `headerFontSize` `textFontSize` `isMobile`  which are resposible for having responsive layput

class UserAppComponent extends StatefulWidget {
  final UserModel user;
  final double imageHeight;
  final double imageWidth;
  final double expansionTitleFontSize;
  final double containerHeight;
  final double containerWidth;
  final double userImageHeight;
  final double userImageWidth;
  final double headerFontSize;
  final double textFontSize;
  final bool isMobile;
  final double friendshipSize;

  const UserAppComponent(
      {Key? key,
      required this.user,
      required this.imageHeight,
      required this.imageWidth,
      required this.expansionTitleFontSize,
      required this.containerHeight,
      required this.containerWidth,
      required this.userImageHeight,
      required this.userImageWidth,
      required this.headerFontSize,
      required this.textFontSize,
      required this.isMobile,
      required this.friendshipSize,
      })
      : super(key: key);

  @override
  State<UserAppComponent> createState() => _UserAppComponentState();
}

class _UserAppComponentState extends State<UserAppComponent> {
  late String id = '0';
  bool requested = false;

  @override
  void initState() {
    super.initState();

    if (GoogleSignInApi().isUserSignedIn() == true ||
        LoginSessionSharedPreferences.getLoggedIn() == true) {
      final currentUser = GoogleSignInApi().getCurrentUser();
      if (currentUser != null) {
        id = currentUser.id;
      } else {
        id = LoginSessionSharedPreferences.getUserID()!;
      }
      checkFriendshipRequest(id, widget.user.userID!, widget.user.formID!)
          .then((result) {
        // Set the state when the Future completes
        setState(() {
          requested = result;
        });
      });
    }
  }

  Future<bool> checkFriendshipRequest(
      String userId, String friendId, int formID) async {
    final request = await RequestsServices()
        .checkFriendshipRequest(userId, friendId, formID);
    return request;
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = countryMap[widget.user.country];

    List<String> dates = widget.user.multiDates!.split(',');

    return ExpansionTile(
        leading: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: const BorderSide(
              color: Colors.grey,
              // color: HapisColors.lgColor3,
              width: 1.0,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Ink.image(
            image: AssetImage('$imagePath'),
            fit: BoxFit.cover,
            width: widget.imageWidth,
            height: widget.imageHeight,
            child: InkWell(
              onTap: () {},
            ),
          ),
        ),
        title: Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: TextStyle(
            fontSize: widget.expansionTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: HapisColors.lgColor1,
        iconColor: HapisColors.lgColor1,
        collapsedIconColor: HapisColors.lgColor3,
        children: [
          Container(
            height: widget.containerHeight,
            width: widget.containerWidth,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: HapisColors.lgColor3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/donorpin.png',
                      height: widget.userImageHeight,
                      width: widget.userImageWidth,
                    ),
                    Text(
                      ' ${widget.user.firstName} ${widget.user.lastName}',
                      style: TextStyle(
                        fontSize: widget.expansionTitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (GoogleSignInApi().isUserSignedIn() == true ||
                        LoginSessionSharedPreferences.getLoggedIn() == true)
                      if (id != widget.user.userID)
                        StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return GestureDetector(
                            onTap: () async {
                              //Make new request if not requested before
                              print(requested);
                              if (requested == false) {
                                if (GoogleSignInApi().isUserSignedIn() ==
                                        true ||
                                    LoginSessionSharedPreferences
                                            .getLoggedIn() ==
                                        true) {
                                  int result = await RequestsServices()
                                      .createRequest(id, widget.user.userID!,
                                          widget.user.formID!);
                                  if (result > 0) {
                                    showDatabasePopup(
                                        context, 'Request sent successfully!',
                                        isError: false);
                                  } else {
                                    showDatabasePopup(context,
                                        'There was a problem sending request. Please try again later..');
                                  }

                                  //referesh:
                                  setState(() {
                                    requested = true;
                                  });
                                } else {
                                  showDialogSignUp(context);
                                }
                              }
                            },
                            //we should checkfriendship to see which icon to use
                            child: requested
                                ?  Icon(Icons.check,
                                    color: HapisColors.lgColor4,
                                    size: widget.friendshipSize)
                                :  Icon(Icons.person_add_alt_1_rounded,
                                    color: HapisColors.lgColor1,
                                    size: widget.friendshipSize),
                          );
                        }),
                  ],
                ),
                if (widget.isMobile)
                  SizedBox(height: MediaQuery.of(context).size.height * 0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTACT INFO',
                      style: TextStyle(
                        fontSize: widget.headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.user.email ?? '',
                      style: TextStyle(
                        fontSize: widget.textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                    Text(
                      widget.user.phoneNum ?? '',
                      style: TextStyle(
                        fontSize: widget.textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (widget.isMobile)
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'ADDRESS LOCATION',
                      style: TextStyle(
                        fontSize: widget.headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.user.addressLocation ?? '',
                      style: TextStyle(
                        //fontSize: 16,
                        fontSize: widget.textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (widget.isMobile)
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COUNTRY',
                      style: TextStyle(
                        fontSize: widget.headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.user.country ?? '',
                      style: TextStyle(
                        fontSize: widget.textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (widget.isMobile)
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CITY',
                      style: TextStyle(
                        fontSize: widget.headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.user.city ?? '',
                      style: TextStyle(
                        fontSize: widget.textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (widget.isMobile)
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.user.type == 'seeker'
                        ? Text(
                            'SEEKING',
                            style: TextStyle(
                              fontSize: widget.headerFontSize,
                              color: Colors.grey,
                            ),
                          )
                        : Text(
                            'DONATING',
                            style: TextStyle(
                              fontSize: widget.headerFontSize,
                              color: Colors.grey,
                            ),
                          ),
                    Text(
                      widget.user.item ?? '',
                      style: TextStyle(
                        fontSize: widget.textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ],
                ),
                if (widget.isMobile)
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CATEGORY',
                          style: TextStyle(
                            fontSize: widget.headerFontSize,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          widget.user.category ?? '',
                          style: TextStyle(
                            fontSize: widget.textFontSize,
                            color: Colors.black,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ],
                    ),
                    if (widget.user.type == 'seeker')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FOR',
                            style: TextStyle(
                              fontSize: widget.headerFontSize,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.user.forWho ?? '',
                            style: TextStyle(
                              fontSize: widget.textFontSize,
                              color: Colors.black,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
                if (widget.isMobile)
                  //  ?
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AVAILABLE DATES',
                      style: TextStyle(
                        fontSize: widget.headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'click here to view available dates',
                        style: TextStyle(
                          fontSize: widget.textFontSize,
                          color: Color.fromARGB(255, 7, 115, 203),
                          fontFamily: GoogleFonts.montserrat().fontFamily,
                        ),
                      ),
                      onTap: () {
                        showDatesDialog(dates, context);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ]);
  }
}
