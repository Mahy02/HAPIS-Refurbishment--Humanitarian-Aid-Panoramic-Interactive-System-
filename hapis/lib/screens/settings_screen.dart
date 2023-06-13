import 'dart:ffi';

import 'package:flutter/material.dart';
import '../reusable_widgets/app_bar.dart';
import '../reusable_widgets/sub_text.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const HAPISAppBar(
          appBarText: 'Settings',
        ),
        drawer: const Drawer(
            // Drawer content goes here
            ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              const SubText(subTextContent: 'LG Settings'),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text('Click me'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 210, 78, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
