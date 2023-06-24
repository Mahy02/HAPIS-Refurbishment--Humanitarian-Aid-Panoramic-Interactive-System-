import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/db_models/users_model.dart';
import 'package:hapis/reusable_widgets/hapis_elevated_button.dart';

class CityComponent extends StatefulWidget {
  final String city;
  final Color buttonColor;
  final String country;
  const CityComponent(
      {super.key,
      required this.city,
      required this.buttonColor,
      required this.country});

  @override
  State<CityComponent> createState() => _CityComponentState();
}

class _CityComponentState extends State<CityComponent> {
  @override
  Widget build(BuildContext context) {
    final imagePath = countryMap[widget.country];
    return Image.asset(imagePath!);
    // HapisElevatedButton(
    //   buttonColor: buttonColor,
    //   elevatedButtonContent: city,
    //   height: MediaQuery.of(context).size.height * 0.2,
    //   onpressed: () {},
    // );
  }
}
