import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hapis/constants.dart';


///This is the custom app bar for our application
class HAPISAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarText;
  const HAPISAppBar({
    super.key,
    required this.appBarText,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.menu_open_rounded,
          size: 50,
          color: HapisColors.secondary,
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
                    color: HapisColors.secondary,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Image.asset(
            'assets/images/earth-day.png',
            width: 50,
            height: 50,
          ),
        ],
      ), //our title
      backgroundColor: HapisColors.primary,
      actions: const [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
