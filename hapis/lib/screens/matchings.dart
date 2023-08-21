import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/get_matchings_model.dart';

import '../helpers/google_signin_api.dart';
import '../helpers/login_session_shared_preferences.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/requests_component.dart';
import '../services/db_services/matchings_db_services.dart';

/// The `Matchings` widget displays a list of matching opportunities for the user.
///
/// This widget fetches and displays a list of matching opportunities that are available to the user.
/// Each matching opportunity is displayed using the `RequestComponent` widget.
///
/// **Properties:**
///
/// - `fontSize`: The font size for the text in the widget.
/// - `subHeadFontSize`: The font size for the subhead text.
/// - `buttonFontSize`: The font size for the button text.
///
class Matchings extends StatefulWidget {
  final double fontSize;
  final double subHeadFontSize;
  final double buttonFontSize;
  const Matchings({
    super.key,
    required this.fontSize,
    required this.subHeadFontSize,
    required this.buttonFontSize,
  });

  @override
  State<Matchings> createState() => _MatchingsState();
}

class _MatchingsState extends State<Matchings> {
  late String id;
  late Future<List<MatchingsModel>>? _future;

  @override
  void initState() {
    super.initState();
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }
    _future = MatchingsServices().getMatchings(id);
  }

 /// - `_refreshData()`: Refreshes the data by fetching matching opportunities.
  Future<void> _refreshData() async {
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }

    setState(() {
      _future = MatchingsServices().getMatchings(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MatchingsModel>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching matchings'));
          }
          final matchingsList = snapshot.data ?? [];

          final noMatchings = matchingsList.isEmpty;

          return noMatchings!
              ? const NoComponentWidget(
                  displayText: 'You don\'t have any matchings',
                  icon: Icons.compare_arrows)
              : SingleChildScrollView(
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
                        itemCount: matchingsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final MatchingsModel matching = matchingsList[index];

                          final type = matching.type;
                          final personName =
                              '${matching.firstName} ${matching.lastName}';

                          final userID = matching.userID;
                          final matchingID = matching.matchingID;

                          //we need to retrieve all data of the other user
                          final city = matching.city;
                          final category = matching.category;
                          final item = matching.item;
                          final email = matching.email;
                          final phone = matching.phoneNum;
                          final dates = matching.datesAvailable;
                          final location = matching.addressLocation;

                          final seekerStatus = matching.seekerStatus;
                          final giverStatus = matching.giverStatus;

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
                            userID: userID,
                            id: matchingID,
                            seekerStatus: seekerStatus,
                            giverStatus: giverStatus,
                            currentUserID: id,
                            onPressed: () {
                              _refreshData();
                            },
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
