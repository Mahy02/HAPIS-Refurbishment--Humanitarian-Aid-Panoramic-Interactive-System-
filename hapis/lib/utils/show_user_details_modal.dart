import 'package:flutter/material.dart';

import '../constants.dart';
import 'date_popup.dart';

/// A function that calls [showModalBottomSheet] for opening a modal with users details in case of a match between 2 peope
/// It containes: [personName], [email], [phone], [item], [city], [category], [dates], [location] and [type]
void showUserDetails(
    BuildContext context,
    String? personName,
    String? email,
    String? phone,
    String? city,
    String? category,
    String? item,
    String? dates,
    String? location,
    String? type,
    double fontSize) {
  showModalBottomSheet(
    context: context,
    useSafeArea: true,
    isScrollControlled: true, // Set this to true
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.all(16),
        height: MediaQuery.of(context).size.height * 0.7,
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
                Flexible(
                  child: Text(
                    item ?? '',
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
