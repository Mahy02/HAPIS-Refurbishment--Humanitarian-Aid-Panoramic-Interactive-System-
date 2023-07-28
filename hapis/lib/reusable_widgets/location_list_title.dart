import 'package:flutter/material.dart';

///The widget [LocationListTitle] contains a [ListTile] with an icon, a text, and an [onTap] function that calls the [onSelect] function with the [location] string as an argument.

class LocationListTitle extends StatelessWidget {
  const LocationListTitle(
      {Key? key, required this.location, required this.onSelect})
      : super(key: key);

  final String location;
  final Function(String) onSelect;

  static const IconData location_on =
      IconData(0xe3ab, fontFamily: 'MaterialIcons');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => onSelect(location),
          horizontalTitleGap: 0,
          leading: Icon(Icons.location_on),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(
          height: 2,
          thickness: 2,
          color: Color.fromARGB(255, 215, 215, 215),
        ),
      ],
    );
  }
}
