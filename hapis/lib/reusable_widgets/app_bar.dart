import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/screens/app_home.dart';
import 'package:hapis/screens/liquid_galaxy/home.dart';

import '../responsive/responsive_layout.dart';

///This is the custom app bar for our application
class HAPISAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarText;
  final bool isLg;
  const HAPISAppBar({
    super.key,
    required this.isLg,
    required this.appBarText,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileBody: buildMobileLayout(context),
      tabletBody: buildTabletLayout(context),
    );
  }

  Widget buildMobileLayout(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.menu_open_rounded,
          size: 30,
          // color: HapisColors.secondary,
          color: Colors.white,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),

      title: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'HAPIS',
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    // color: HapisColors.secondary,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Column(
            children: [
              GestureDetector(
                  child: isLg
                      ? Image.asset(
                          'assets/images/earth-day.png',
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                        )
                      : Image.asset(
                          'assets/images/lg.png',
                          width: MediaQuery.of(context).size.width * 0.1,
                          height: MediaQuery.of(context).size.width * 0.1,
                        ),
                  onTap: () {
                    //switch to app view or liquid galaxy view
                    if (isLg == false) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LgHomePage()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppHomePage()));
                    }
                  }),
              Text(
                "Switch",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    //color: HapisColors.secondary,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ), //our title
      backgroundColor: HapisColors.primary,
      actions: const [],
    );
  }

  Widget buildTabletLayout(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.menu_open_rounded,
          size: 50,
          //color: HapisColors.secondary,
          color: Colors.white,
        ),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),

      title: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                'HAPIS',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    //  color: HapisColors.secondary,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "Switch",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    //color: HapisColors.secondary,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                  child: isLg
                      ? Image.asset(
                          'assets/images/earth-day.png',
                          width: MediaQuery.of(context).size.width * 0.04,
                          height: MediaQuery.of(context).size.width * 0.04,
                        )
                      : Image.asset(
                          'assets/images/lg.png',
                          width: MediaQuery.of(context).size.width * 0.05,
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                  onTap: () {
                    //switch to app view or liquid galaxy view
                    if (isLg == false) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LgHomePage()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AppHomePage()));
                    }
                  }),
            ],
          ),
          // Image.asset(
          //   'assets/images/earth-day.png',
          //   width: 50,
          //   height: 50,
          // ),
        ],
      ), //our title
      backgroundColor: HapisColors.primary,
      actions: const [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
