import 'package:flutter/material.dart';
import 'package:hapis/reusable_widgets/app_bar.dart';
import 'package:hapis/utils/drawer.dart';
import '../utils/build_inner_logos.dart';


///This is the about page, where we have the logos, name of the app, authors, links
///We call [BuildLogos] that has all the content of the About page
class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const HAPISAppBar(appBarText: ''),
        drawer: buildDrawer(context),
        body: SingleChildScrollView(
          child: BuildLogos(),
        ));
  }
}


