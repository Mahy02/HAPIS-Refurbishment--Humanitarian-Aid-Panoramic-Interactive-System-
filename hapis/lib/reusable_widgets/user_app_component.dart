import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/db_models/user_model.dart';

import '../utils/date_popup.dart';

/// custom widget `UserAppComponent` that displays the user component in the main app view
/// It takes:
/// - `user` which represents a [UserModel]
/// - `imageHeight`  `imageWidth` `expansionTitleFontSize` `containerHeight` `containerWidth` `userImageHeight` `userImageWidth` `headerFontSize` `textFontSize` `isMobile`  which are resposible for having responsive layput

class UserAppComponent extends StatelessWidget {
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
      required this.isMobile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePath = countryMap[user.country];

    List<String> dates = user.multiDates!.split(',');

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
            width: imageWidth,
            height: imageHeight,
            child: InkWell(
              onTap: () {},
            ),
          ),
        ),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            fontSize: expansionTitleFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: HapisColors.lgColor1,
        iconColor: HapisColors.lgColor1,
        collapsedIconColor: HapisColors.lgColor3,
        children: [
          Container(
            height: containerHeight,
            width: containerWidth,
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
                      height: userImageHeight,
                      width: userImageWidth,
                    ),
                    Text(
                      ' ${user.firstName} ${user.lastName}',
                      style: TextStyle(
                        fontSize: expansionTitleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                if (isMobile)
                  SizedBox(height: MediaQuery.of(context).size.height * 0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CONTACT INFO',
                      style: TextStyle(
                        fontSize: headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      user.email ?? '',
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                    Text(
                      user.phoneNum ?? '',
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (isMobile)
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
                        fontSize: headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      user.addressLocation ?? '',
                      style: TextStyle(
                        //fontSize: 16,
                        fontSize: textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (isMobile)
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
                        fontSize: headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      user.country ?? '',
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (isMobile)
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
                        fontSize: headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      user.city ?? '',
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                if (isMobile)
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    user.type == 'seeker'
                        ? Text(
                            'SEEKING',
                            style: TextStyle(
                              fontSize: headerFontSize,
                              color: Colors.grey,
                            ),
                          )
                        : Text(
                            'DONATING',
                            style: TextStyle(
                              fontSize: headerFontSize,
                              color: Colors.grey,
                            ),
                          ),
                    Text(
                      user.item ?? '',
                      style: TextStyle(
                        fontSize: textFontSize,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ],
                ),
                if (isMobile)
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
                            fontSize: headerFontSize,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          user.category ?? '',
                          style: TextStyle(
                            fontSize: textFontSize,
                            color: Colors.black,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ],
                    ),
                    if (user.type == 'seeker')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FOR',
                            style: TextStyle(
                              fontSize: headerFontSize,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            user.forWho ?? '',
                            style: TextStyle(
                              fontSize: textFontSize,
                              color: Colors.black,
                              fontFamily: GoogleFonts.montserrat().fontFamily,
                            ),
                          ),
                        ],
                      )
                  ],
                ),
                if (isMobile)
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
                        fontSize: headerFontSize,
                        color: Colors.grey,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'click here to view available dates',
                        style: TextStyle(
                          fontSize: textFontSize,
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
  //2023-08-22 11:00:00,2023-08-02 14:00:00,2023-08-01 13:00:00
}
