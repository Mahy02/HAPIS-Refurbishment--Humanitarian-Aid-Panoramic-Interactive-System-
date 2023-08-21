import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:provider/provider.dart';

import '../providers/icon_state_provider.dart';

///This represnts the UI of [IconSideMenuWidget] which is a custom widget for displaying each item in the side menu
///It conatins:
///           [itemTitle] which is a [String] that represents the text of the item in the side menu
///           [itemNumber] which is a [String] that represents the number of the item in the side menu (1,2,3)
///           [page] which is a [Widget] that represents the page it would be routed to when the item is pressed
/// we used [Consumer] which is of type [IconState] provider to allow for state change when an item is clicked (to the icon and to navigate to another page)

class IconSideMenuWidget extends StatelessWidget {
  final String itemTitle;
  final String itemNumber;
  final Widget page;
  final double fontSize;
  final double iconFontSize;
  
  const IconSideMenuWidget({
    Key? key,
    required this.itemTitle,
    required this.itemNumber,
    required this.page,
    required this.fontSize,
    required this.iconFontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<IconState>(
      builder: (BuildContext context, iconStateProvider, child) {
        final iconState = iconStateProvider.getIconState(itemNumber);
        return Container(
          decoration: BoxDecoration(
            color: iconState
                ? Colors.white
                : const Color.fromARGB(100, 255, 255, 255),
            border: Border.all(
              color: iconState
                  ? Colors.white
                  : const Color.fromARGB(100, 255, 255, 255),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  iconState
                      ? const CircleAvatar(
                          backgroundColor: HapisColors.primary,
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                          ))
                      : CircleAvatar(
                          backgroundColor: HapisColors.primary,
                          child: Text(
                            itemNumber,
                            style:  TextStyle(
                              fontFamily: "segoe ui",
                              fontSize: iconFontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                  const SizedBox(width: 30),
                ],
              ),
              title: Text(
                itemTitle,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: "segoe ui",
                  color: itemNumber == '1'
                      ? HapisColors.lgColor1
                      : itemNumber == '2'
                          ? HapisColors.lgColor2
                          : itemNumber == '3'
                              ? HapisColors.lgColor3
                              : HapisColors.lgColor4,
                ),
              ),
              onTap: () {
                iconStateProvider.setIconState(itemNumber);
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => page));
              },
            ),
          ),
        );
      },
    );
  }
}
