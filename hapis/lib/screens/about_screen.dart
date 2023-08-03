import 'package:flutter/material.dart';
import 'package:hapis/responsive/responsive_layout.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';
import '../utils/build_inner_logos.dart';

///This is the about page, where we have the logos, name of the app, authors, links
///We call [BuildLogos] that has all the content of the About page
class About extends StatelessWidget {
  final bool isLg;
  const About({super.key, required this.isLg});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: HAPISAppBar(
          appBarText: '',
          isLg: isLg,
        ),
        drawer: ResponsiveLayout(
            mobileBody: buildDrawer(context, isLg, 18, 16),
            tabletBody: buildDrawer(context, isLg, 24, 20)),
        body: ResponsiveLayout(
          mobileBody: buildMobileLogos(),
          tabletBody: buildTabletLogos(),
        )
        //BuildLogos()
        //  SingleChildScrollView(
        //   child: BuildLogos(),
        // )
        );
  }
}
