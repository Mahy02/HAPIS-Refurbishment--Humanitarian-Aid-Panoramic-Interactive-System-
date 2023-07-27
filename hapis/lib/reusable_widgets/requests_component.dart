import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';

import '../utils/date_popup.dart';

class RequestComponent extends StatelessWidget {
  final bool isSent;
  final bool isMatching;
  final bool isDonation;
  final double fontSize;
  final double buttonFontSize;
  final String? personName;
  final String? item;
  final String? status;
  final String? type;
  final String? city;
  final String? category;
  final String? email;
  final String? phone;
  final String? location;
  final String? dates;

  // final double buttonHeight;
  // final double finishButtonHeight;
  // final double pendingButtonHeight;
  //   final double buttonWidth;
  // final double finishButtonWidth;
  // final double pendingButtonWidth;
  const RequestComponent({
    super.key,
    required this.isSent,
    required this.isMatching,
    required this.isDonation,
    required this.fontSize,
    required this.buttonFontSize,
    this.personName,
    this.item,
    this.type,
    this.status,
    this.city,
    this.category,
    this.email,
    this.phone,
    this.location,
    this.dates,
    // required this.buttonHeight, required this.finishButtonHeight, required this.pendingButtonHeight, required this.buttonWidth, required this.finishButtonWidth, required this.pendingButtonWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        //  color: HapisColors.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/donorpin.png'),
                radius: 30,
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Expanded(
                child: isSent
                    ? RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: fontSize, color: Colors.black),
                          children: [
                            const TextSpan(
                              text: 'Request sent to ',
                            ),
                            TextSpan(
                              //text: 'Person Name',
                              text: personName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : isMatching
                        // ? RichText(
                        //     text: TextSpan(
                        //       style: TextStyle(
                        //           fontSize: fontSize, color: Colors.black),
                        //       children: [
                        //         TextSpan(
                        //           //text: 'Person Name',
                        //           text: personName,
                        //           style: const TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               decoration: TextDecoration.underline,
                        //               color: Color.fromARGB(255, 27, 120, 196)),
                        //         ),
                        //         if (type == 'giver')
                        //           const TextSpan(
                        //               text:
                        //                   ' is a good match for your wish to donate '),
                        //         if (type == 'seeker')
                        //           const TextSpan(
                        //               text:
                        //                   ' is a good match for your need for '),
                        //         TextSpan(
                        //           text: '$item. ',
                        //           style: const TextStyle(
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //         const TextSpan(text: "Want to Contact?"),
                        //       ],
                        //     ),
                        //   )
                        ? RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: fontSize, color: Colors.black),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (type == 'giver') {
                                        _showUserDetails(
                                            context,
                                            personName,
                                            email,
                                            phone,
                                            city,
                                            category,
                                            item,
                                            dates,
                                            location,
                                            'seeker');
                                      } else {
                                        _showUserDetails(
                                            context,
                                            personName,
                                            email,
                                            phone,
                                            city,
                                            category,
                                            item,
                                            dates,
                                            location,
                                            'giver');
                                      }
                                    },
                                    child: Text(
                                      personName ?? '',
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: const Color.fromARGB(
                                            255, 27, 120, 196),
                                      ),
                                    ),
                                  ),
                                ),
                                if (type == 'giver')
                                  const TextSpan(
                                      text:
                                          ' is a good match for your wish to donate '),
                                if (type == 'seeker')
                                  const TextSpan(
                                      text:
                                          ' is a good match for your need for '),
                                TextSpan(
                                  text: '$item. ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(text: "Want to Contact?"),
                              ],
                            ),
                          )
                        : isDonation
                            ? RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: fontSize, color: Colors.black),
                                  children: [
                                    const TextSpan(text: 'You and  '),
                                    TextSpan(
                                      //text: 'Person Name ',
                                      text: personName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: ' are now in contact',
                                    ),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: fontSize, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      //text: 'Person Name',
                                      text: personName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (type == 'seeker')
                                      const TextSpan(
                                          text:
                                              ' requested to contact you about your need for '),
                                    if (type == 'giver')
                                      const TextSpan(
                                          text:
                                              ' requested to contact you about your offered '),
                                    TextSpan(
                                      //  text: 'item',
                                      text: item,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ],
          ),
          isSent
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    // height: MediaQuery.of(context).size.height * 0.08,
                    // width: MediaQuery.of(context).size.width * 0.15,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button click here
                      },
                      child: Text(
                        // 'PENDING',
                        status!,
                        style: TextStyle(fontSize: buttonFontSize),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HapisColors.lgColor1), // Button background color
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(15)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                5), // Button border radius
                            // You can also set other properties like borderColor, borderWidth, etc. here
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : isMatching
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.08,
                          // width: MediaQuery.of(context).size.width * 0.1,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button click here
                            },
                            child: Text(
                              'REQUEST',
                              style: TextStyle(fontSize: buttonFontSize),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HapisColors
                                      .lgColor4), // Button background color
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(15)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Button border radius
                                  // You can also set other properties like borderColor, borderWidth, etc. here
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          // height: MediaQuery.of(context).size.height * 0.08,
                          // width: MediaQuery.of(context).size.width * 0.1,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle button click here
                            },
                            child: Text(
                              'IGNORE',
                              style: TextStyle(fontSize: buttonFontSize),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HapisColors
                                      .lgColor2), // Button background color
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      const EdgeInsets.all(15)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      5), // Button border radius
                                  // You can also set other properties like borderColor, borderWidth, etc. here
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : isDonation
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            // height: MediaQuery.of(context).size.height * 0.08,
                            // width: MediaQuery.of(context).size.width * 0.2,
                            child: ElevatedButton(
                              onPressed: () {
                                // Handle button click here
                              },
                              child: Text(
                                'FINISH PROCESS',
                                style: TextStyle(fontSize: buttonFontSize),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(HapisColors
                                        .lgColor4), // Button background color
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        5), // Button border radius
                                    // You can also set other properties like borderColor, borderWidth, etc. here
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.08,
                              // width: MediaQuery.of(context).size.width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle button click here
                                },
                                child: Text(
                                  'ACCEPT',
                                  style: TextStyle(fontSize: buttonFontSize),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty
                                      .all<Color>(HapisColors
                                          .lgColor4), // Button background color
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      const EdgeInsets.all(15)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Button border radius
                                      // You can also set other properties like borderColor, borderWidth, etc. here
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              // height: MediaQuery.of(context).size.height * 0.08,
                              // width: MediaQuery.of(context).size.width * 0.1,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle button click here
                                },
                                child: Text(
                                  'DECLINE',
                                  style: TextStyle(fontSize: buttonFontSize),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty
                                      .all<Color>(HapisColors
                                          .lgColor2), // Button background color
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      const EdgeInsets.all(15)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          5), // Button border radius
                                      // You can also set other properties like borderColor, borderWidth, etc. here
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
        ],
      ),

      //Text('Item $index'),
    );
  }

  void _showUserDetails(
      BuildContext context,
      String? personName,
      String? email,
      String? phone,
      String? city,
      String? category,
      String? item,
      String? dates,
      String? location,
      String? type) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              const Icon(
                Icons.keyboard_double_arrow_up,
                size: 30,
                color: HapisColors.lgColor3,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Center(
                child: Text(
                  personName ?? '',
                  style: TextStyle(
                      fontSize: fontSize + 4, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (type == 'seeker')
                    Text(
                      'Seeking',
                      style: TextStyle(
                          fontSize: fontSize + 1,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                  if (type == 'giver')
                    Text(
                      'Donating',
                      style: TextStyle(
                        fontSize: fontSize + 1,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    item ?? '',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'City',
                    style: TextStyle(
                      fontSize: fontSize + 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    city ?? '',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: fontSize + 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    phone ?? '',
                    style: TextStyle(
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: fontSize + 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      email ?? '',
                      style: TextStyle(
                          fontSize: fontSize,
                          color: const Color.fromARGB(255, 32, 132, 214),
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Location',
                    style: TextStyle(
                      fontSize: fontSize + 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      location ?? '',
                      style: TextStyle(
                        fontSize: fontSize,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dates available',
                    style: TextStyle(
                      fontSize: fontSize + 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    child: Text(
                      'click here to view',
                      style: TextStyle(
                          fontSize: fontSize,
                          color: Color.fromARGB(255, 32, 132, 214),
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      List<String> listDates = dates!.split(',');
                      showDatesDialog(listDates, context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
