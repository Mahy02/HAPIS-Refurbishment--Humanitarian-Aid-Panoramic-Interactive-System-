import 'package:flutter/material.dart';
import 'package:hapis/screens/about_screen.dart';
import 'package:hapis/screens/home.dart';

import '../screens/configuration_screen.dart';
import '../screens/settings_screen.dart';
import '../reusable_widgets/item_side_menu.dart';

///This is a method called [buildDrawer] to build the drawer for the side menu
///it returns a [Drawer] which is a flutter built in drawer widget with a [ListView] for all our components
///It helps navigate between these pages=> [HomePage] , [About], [Configuration] & [Settings]
///We use  [IconSideMenuWidget] to represent each item in the sidemenu 

Drawer buildDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: const Color.fromARGB(222, 255, 255, 255),
    child: SafeArea(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          Divider(
            color: const Color.fromARGB(245, 220, 220, 220),
            thickness: 2,
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          const IconSideMenuWidget(
            itemNumber: '1',
            page: About(),
            itemTitle: 'About',
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          const IconSideMenuWidget(
            itemNumber: '2',
            page: HomePage(),
            itemTitle: 'Home',
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          const IconSideMenuWidget(
            itemNumber: '3',
            page: Settings(),
            itemTitle: 'LG Settings',
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          const IconSideMenuWidget(
            itemNumber: '4',
            page: Configuration(),
            itemTitle: 'Connect LG',
          ),
          Divider(
              color: const Color.fromARGB(245, 220, 220, 220),
              thickness: 2,
              height: MediaQuery.of(context).size.height * 0.05),
          SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        ],
      ),
    ),
  );
}
