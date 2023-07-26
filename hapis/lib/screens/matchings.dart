import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/get_matchings_model.dart';

import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/requests_component.dart';
import '../services/db_services/matchings_db_services.dart';

class Matchings extends StatefulWidget {
  final double fontSize;
  final double subHeadFontSize;
  final double buttonFontSize;
  //  final double buttonHeight;
  // final double finishButtonHeight;
  // final double pendingButtonHeight;
  //   final double buttonWidth;
  // final double finishButtonWidth;
  // final double pendingButtonWidth;
  const Matchings({
    super.key,
    required this.fontSize,
    required this.subHeadFontSize,
    required this.buttonFontSize,
    // required this.buttonHeight, required this.finishButtonHeight, required this.pendingButtonHeight, required this.buttonWidth, required this.finishButtonWidth, required this.pendingButtonWidth
  });

  @override
  State<Matchings> createState() => _MatchingsState();
}

class _MatchingsState extends State<Matchings> {
  @override
  Widget build(BuildContext context) {
   
    return FutureBuilder<List<MatchingsModel>>(
        future: MatchingsServices().getMatchings(),
     
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching matchings'));
          }
          final matchingsList = snapshot.data ?? [];
          final noMatchings = matchingsList.isEmpty;
          //print(noDrafts); //false
          return noMatchings!
              ? const NoComponentWidget(
                  displayText: 'You don\'t have any matchings',
                  icon: Icons.compare_arrows)
              :
              SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Matchings For You',
                          style: TextStyle(
                              fontSize: widget.subHeadFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      ListView.builder(
                        // itemCount: 20,
                        itemCount: matchingsList.length,
                        //matchingsProvider.matchings.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final MatchingsModel matching = matchingsList[index];

                          // final matching = matchingsProvider.matchings[index];
                          final type = matching.type;
                          final personName =
                              '${matching.firstName} ${matching.lastName}';

                          //we need to retrieve all data of the other user
                          final city = matching.city;
                          final category = matching.category;
                          final item = matching.item;
                          final email = matching.email;
                          final phone = matching.phoneNum;
                          final dates = matching.datesAvailable;
                          final location = matching.addressLocation;

                          return ListTile(
                              title: RequestComponent(
                            isSent: false,
                            isMatching: true,
                            isDonation: false,
                            fontSize: widget.fontSize,
                            buttonFontSize: widget.buttonFontSize,
                            personName: personName,
                            type: type,
                            item: item,
                            email: email,
                            city: city,
                            category: category,
                            phone: phone,
                            dates: dates,
                            location: location,
                            // buttonHeight: buttonHeight,
                            // finishButtonHeight:finishButtonHeight ,
                            // pendingButtonHeight: pendingButtonHeight,
                            // buttonWidth:buttonWidth ,
                            // pendingButtonWidth:pendingButtonWidth ,
                            // finishButtonWidth: finishButtonWidth,
                          ));
                        },
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                    ],
                  ),
                );
        });
  }
}
