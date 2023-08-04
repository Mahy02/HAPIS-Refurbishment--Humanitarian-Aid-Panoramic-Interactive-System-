import 'package:flutter/material.dart';
import 'package:hapis/models/db_models/get_inprogress_donations_model.dart';
import 'package:hapis/services/db_services/donations_db_services.dart';

import '../helpers/google_signin_api.dart';
import '../helpers/login_session_shared_preferences.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/requests_component.dart';

class Donations extends StatefulWidget {
  final double fontSize;
  final double subHeadFontSize;
  final double buttonFontSize;
  //  final double buttonHeight;
  // final double finishButtonHeight;
  // final double pendingButtonHeight;
  //   final double buttonWidth;
  // final double finishButtonWidth;
  // final double pendingButtonWidth;
  const Donations({
    super.key,
    required this.fontSize,
    required this.subHeadFontSize,
    required this.buttonFontSize,
    //required this.buttonHeight, required this.finishButtonHeight, required this.pendingButtonHeight, required this.buttonWidth, required this.finishButtonWidth, required this.pendingButtonWidth
  });

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  late String id;
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
    // String id;
    // final user = GoogleSignInApi().getCurrentUser();
    // if (user != null) {
    //   id = user.id;
    // } else {
    //   id = LoginSessionSharedPreferences.getUserID()!;
    // }
    return FutureBuilder<List<InProgressDonationModel>>(
        future: _future,
        //DonationsServices().getDonationsInProgress(id),
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
                        //itemCount: 20,
                        itemCount: donationsList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final InProgressDonationModel donations =
                              donationsList[index];
                          final r_id = donations.rID;
                          final m_id = donations.mID;
                          print('rid:');
                          print(r_id);
                          print('mid:');
                          print(m_id);

                          final personName =
                              '${donations.firstName} ${donations.lastName}';
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
                            onPressed: () {
                              _refreshData();
                            },

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
