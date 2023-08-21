import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/get_inprogress_donations_model.dart';
import 'package:hapis/services/db_services/donations_db_services.dart';

import '../helpers/google_signin_api.dart';
import '../helpers/login_session_shared_preferences.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/requests_component.dart';

/// The `Donations` widget displays the list of in-progress donations for the current user.
///
/// This widget fetches in-progress donations from the database and presents them to the user.
/// It offers a refresh functionality to reload the list and accommodates both cases when
/// the user has in-progress donations and when they don't.

/// **Properties:**
///
/// - `fontSize`: The font size for the text content.
/// - `subHeadFontSize`: The font size for subheadings.
/// - `buttonFontSize`: The font size for buttons.
///

class Donations extends StatefulWidget {
  final double fontSize;
  final double subHeadFontSize;
  final double buttonFontSize;
  const Donations({
    super.key,
    required this.fontSize,
    required this.subHeadFontSize,
    required this.buttonFontSize,
   
  });

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {

  /// - `id`: A string that holds the unique identifier of the current user.
  late String id;

  /// - `_future`: A `Future` that holds the list of in-progress donation models.
  late Future<List<InProgressDonationModel>>? _future;
  @override
  void initState() {
    super.initState();
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }
    _future = DonationsServices().getDonationsInProgress(id);
  }

  /// - `Future<void> _refreshData()`: Refreshes the data by fetching the list of
  ///   in-progress donations from the database and updating the state.
  Future<void> _refreshData() async {
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getUserID()!;
    }

    setState(() {
      _future = DonationsServices().getDonationsInProgress(id);
    });
  }

  @override
  Widget build(BuildContext context) {
  
    return FutureBuilder<List<InProgressDonationModel>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching donations'));
          }
          final donationsList = snapshot.data ?? [];
          final noDonations = donationsList.isEmpty;

          return noDonations!
              ? const NoComponentWidget(
                  displayText: 'You don\'t have any current donations',
                  icon: Icons.favorite)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'Donations In progress',
                          style: TextStyle(
                              fontSize: widget.subHeadFontSize,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      ListView.builder(
                       
                        itemCount: donationsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final InProgressDonationModel donations =
                              donationsList[index];
                          final r_id = donations.rID;
                          final m_id = donations.mID;
                          final type = donations.type;

                          final otherId = donations.otherId;

                          final personName =
                              '${donations.firstName} ${donations.lastName}';

                          final currentStatus = donations.currentDonationStatus;
                          final otherStatus = donations.otherDonationStatus;
                       
                          return ListTile(
                              title: RequestComponent(
                            isSent: false,
                            isMatching: false,
                            isDonation: true,
                            fontSize: widget.fontSize,
                            buttonFontSize: widget.buttonFontSize,
                            personName: personName,
                            id: r_id,
                            id2: m_id,
                            type: type,
                            currentDonationStatus: currentStatus,
                            otherDonationStatus: otherStatus,
                            userID: otherId,
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
