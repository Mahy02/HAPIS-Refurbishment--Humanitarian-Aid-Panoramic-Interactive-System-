import 'package:flutter/material.dart';
import 'package:hapis/constants.dart';
import 'package:hapis/models/db_models/get_inprogress_donations_model.dart';
import 'package:hapis/services/db_services/donations_db_services.dart';
import 'package:hapis/services/db_services/matchings_db_services.dart';
import 'package:hapis/services/db_services/requests_db_services.dart';
import 'package:hapis/services/db_services/users_services.dart';

import '../helpers/matching_status_shared_pref.dart';
import '../utils/date_popup.dart';
import '../utils/show_user_details_modal.dart';

/// [RequestComponent] is a custom widget that displays the component shown in main app view for either Requests, Donations or Matchings page
/// It takes the following parameters:
/// * [isSent] - A required bool to check if its related to requests sent category
/// * [isMatching] - A required bool to check if its related to matchings category
/// * [isDonation] - A required bool to check if its related to donations category
/// * [fontSize], [buttonFontSize] - Required for having responsive layout
/// * [personName] - Optional to get the person name displayed
/// * [item] - Optional if its required to provide the item
/// * [status]  - Optional if its required to provide the status
/// * [type] - Optional if its required to provide the type
/// * [city] - Optional if its required to provide the city
/// * [category] - Optional if its required to provide the category
/// * [email] - Optional if its required to provide the email
/// * [phone] - Optional if its required to provide the phone
/// * [location] - Optional if its required to provide the location
/// * [dates] - Optional if its required to provide the dates
class RequestComponent extends StatefulWidget {
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
  final int? id;
  final int? id2;
  final String? userID;
  final String? seekerStatus;
  final String? giverStatus;
  final VoidCallback? onPressed;

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
    this.id,
    this.onPressed,
    this.userID,
    this.seekerStatus,
    this.giverStatus,
    this.id2,
  });

  @override
  State<RequestComponent> createState() => _RequestComponentState();
}

class _RequestComponentState extends State<RequestComponent> {
  bool _accepted = false;
  // bool isMatchAccepted = MatchingsSharedPreferences.isMatchAccepted();

  // bool isMatchAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
                child: widget.isSent
                    ? RichText(
                        text: TextSpan(
                          style: TextStyle(
                              fontSize: widget.fontSize, color: Colors.black),
                          children: [
                            const TextSpan(
                              text: 'Request sent to ',
                            ),
                            TextSpan(
                              text: widget.personName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    : widget.isMatching
                        ? RichText(
                            text: TextSpan(
                              style: TextStyle(
                                  fontSize: widget.fontSize,
                                  color: Colors.black),
                              children: [
                                WidgetSpan(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (widget.type == 'giver') {
                                        showUserDetails(
                                            context,
                                            widget.personName,
                                            widget.email,
                                            widget.phone,
                                            widget.city,
                                            widget.category,
                                            widget.item,
                                            widget.dates,
                                            widget.location,
                                            'seeker', widget.fontSize);
                                      } else {
                                        showUserDetails(
                                            context,
                                            widget.personName,
                                            widget.email,
                                            widget.phone,
                                            widget.city,
                                            widget.category,
                                            widget.item,
                                            widget.dates,
                                            widget.location,
                                            'giver', widget.fontSize);
                                      }
                                    },
                                    child: Text(
                                      widget.personName ?? '',
                                      style: TextStyle(
                                        fontSize: widget.fontSize,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        color: const Color.fromARGB(
                                            255, 27, 120, 196),
                                      ),
                                    ),
                                  ),
                                ),
                                if (widget.type == 'giver')
                                  const TextSpan(
                                      text:
                                          ' is a good match for your wish to donate '),
                                if (widget.type == 'seeker')
                                  const TextSpan(
                                      text:
                                          ' is a good match for your need for '),
                                TextSpan(
                                  text: '${widget.item}. ',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const TextSpan(text: "Want to Contact?"),
                              ],
                            ),
                          )
                        : widget.isDonation
                            ? RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                      fontSize: widget.fontSize,
                                      color: Colors.black),
                                  children: [
                                    const TextSpan(text: 'You and  '),
                                    TextSpan(
                                      text: widget.personName,
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
                                      fontSize: widget.fontSize,
                                      color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: widget.personName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    if (widget.type == 'seeker')
                                      const TextSpan(
                                          text:
                                              ' requested to contact you about your need for '),
                                    if (widget.type == 'giver')
                                      const TextSpan(
                                          text:
                                              ' requested to contact you about your offered '),
                                    TextSpan(
                                      //  text: 'item',
                                      text: widget.item,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
              ),
            ],
          ),
          widget.isSent
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            HapisColors.lgColor1),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(15)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Text(
                        widget.status!.toUpperCase(),
                        style: TextStyle(fontSize: widget.buttonFontSize),
                      ),
                    ),
                  ),
                )
              : widget.isMatching
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if ((widget.type == 'seeker' &&
                                widget.seekerStatus != 'Accepted') ||
                            (widget.type == 'giver' &&
                                widget.giverStatus != 'Accepted'))
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () async {
                                //change status
                                int result = await MatchingsServices()
                                    .updateMatching(widget.id!, widget.type!);

                                //referesh
                                widget.onPressed!();
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HapisColors.lgColor4),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: Text(
                                'ACCEPT',
                                style:
                                    TextStyle(fontSize: widget.buttonFontSize),
                              ),
                            ),
                          ),
                        if ((widget.type == 'seeker' &&
                                widget.seekerStatus != 'Accepted') ||
                            (widget.type == 'giver' &&
                                widget.giverStatus != 'Accepted'))
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () async {
                                //delete matching
                                int result = await MatchingsServices()
                                    .deleteMatching(widget.id!);

                                //referesh
                                widget.onPressed!();
                                //send push notification to other person
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HapisColors.lgColor2),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: Text(
                                'IGNORE',
                                style:
                                    TextStyle(fontSize: widget.buttonFontSize),
                              ),
                            ),
                          ),
                        if ((widget.type == 'seeker' &&
                                widget.seekerStatus == 'Accepted') ||
                            (widget.type == 'giver' &&
                                widget.giverStatus == 'Accepted'))
                          SizedBox(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HapisColors.lgColor1),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: Tooltip(
                                message: 'Waiting for others..',
                                child: Text(
                                  'PENDING',
                                  style: TextStyle(
                                      fontSize: widget.buttonFontSize),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : widget.isDonation
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: SizedBox(
                            child: ElevatedButton(
                              onPressed: () async {
                                //update donation
                                await DonationsServices()
                                    .updateDonation(widget.id!, widget.id2!);
                                //referesh
                                widget.onPressed!();

                                //get forms
                                if (widget.id! != 0) {
                                  //requests
                                  int rFormId = await RequestsServices()
                                      .getFormId(widget.id!);
                                  //delete forms
                                  await UserServices().deleteForm(rFormId);
                                }
                                if (widget.id2! != 0) {
                                  //matchings
                                  List<int> mFormIds = await MatchingsServices()
                                      .getFormIds(widget.id2!);
                                  for (int i = 0; i < mFormIds.length; i++) {
                                    await UserServices()
                                        .deleteForm(mFormIds[i]);
                                  }
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HapisColors.lgColor4),
                                padding: MaterialStateProperty.all<
                                        EdgeInsetsGeometry>(
                                    const EdgeInsets.all(15)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                              child: Text(
                                'FINISH PROCESS',
                                style:
                                    TextStyle(fontSize: widget.buttonFontSize),
                              ),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () async {
                                  //change status in database
                                  int result = await RequestsServices()
                                      .acceptRequest(widget.id!);
                                  //refresh:
                                  widget.onPressed!();
                                  //send push notification
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          HapisColors.lgColor4),
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      const EdgeInsets.all(15)),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'ACCEPT',
                                  style: TextStyle(
                                      fontSize: widget.buttonFontSize),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: ElevatedButton(
                                onPressed: () async {
                                  //change status in database
                                  int result = await RequestsServices()
                                      .deleteRequest(widget.id!);
                                  //refresh:
                                  widget.onPressed!();
                                  //send push notification
                                },
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
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'DECLINE',
                                  style: TextStyle(
                                      fontSize: widget.buttonFontSize),
                                ),
                              ),
                            ),
                          ],
                        ),
        ],
      ),
    );
  }

  
}
