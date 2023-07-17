import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/db_models/user_model.dart';

class UserAppComponent extends StatelessWidget {
  final UserModel user;

  const UserAppComponent({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imagePath = countryMap[user.country];

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
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.height * 0.03,
            child: InkWell(
              onTap: () {
                // add your onTap logic here
              },
            ),
          ),
        ),

        // leading: Image.asset(
        //   '$imagePath',
        //   height: MediaQuery.of(context).size.height * 0.05,
        //   width: MediaQuery.of(context).size.width * 0.05,
        // ),
        //Icon(Icons.person),
        title: Text(
          '${user.firstName} ${user.lastName}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        textColor: HapisColors.lgColor1,
        iconColor: HapisColors.lgColor1,
        collapsedIconColor: HapisColors.lgColor3,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.8,
            width: MediaQuery.of(context).size.width * 0.9,
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
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.1,
                    ),
                    Text(
                      ' ${user.firstName} ${user.lastName}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                //const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CONTACT INFO',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    //const SizedBox(height: 10),
                    Text(
                      user.email ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                    //const SizedBox(height: 10),
                    Text(
                      user.phoneNum ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      'ADDRESS LOCATION',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    //const SizedBox(height: 10),
                    Text(
                      user.addressLocation ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'COUNTRY',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    // const SizedBox(height: 10),
                    Text(
                      user.country ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CITY',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    //const SizedBox(height: 10),
                    Text(
                      user.city ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.05,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    user.type == 'seeker'
                        ? const Text(
                            'SEEKING',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          )
                        : const Text(
                            'DONATING',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                    // const SizedBox(height: 10),
                    Text(
                      user.item ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      maxLines: 2,
                    ),
                  ],
                ),
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
                        const Text(
                          'CATEGORY',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        //   const SizedBox(height: 10),
                        Text(
                          user.category ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: GoogleFonts.montserrat().fontFamily,
                          ),
                        ),
                      ],
                    ),
                    user.type == 'seeker'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'FOR',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey,
                                ),
                              ),
                              //   const SizedBox(height: 10),
                              Text(
                                user.forWho ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                  ],
                ),

                user.type == 'seeker'
                    ? SizedBox(
                        height: MediaQuery.of(context).size.width * 0.05,
                      )
                    : Container(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AVAILABLE DATES',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    //   const SizedBox(height: 10),
                    Text(
                      user.multiDates ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontFamily: GoogleFonts.montserrat().fontFamily,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ]);
  }
}
