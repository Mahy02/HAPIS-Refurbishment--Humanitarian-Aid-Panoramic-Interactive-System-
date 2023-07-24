import 'package:flutter/material.dart';
import 'package:hapis/providers/inprogress_donation_provider.dart';
import 'package:provider/provider.dart';

import '../reusable_widgets/requests_component.dart';

class Donations extends StatelessWidget {
  final double fontSize;
  final double subHeadFontSize;
  final double buttonFontSize;
  //  final double buttonHeight;
  // final double finishButtonHeight;
  // final double pendingButtonHeight;
  //   final double buttonWidth;
  // final double finishButtonWidth;
  // final double pendingButtonWidth;
  const Donations(
      {super.key, required this.fontSize, required this.subHeadFontSize, required this.buttonFontSize, 
      //required this.buttonHeight, required this.finishButtonHeight, required this.pendingButtonHeight, required this.buttonWidth, required this.finishButtonWidth, required this.pendingButtonWidth
      });

  @override
  Widget build(BuildContext context) {
    InProgressDonationsProvider inProgressDonationProvider =
        Provider.of<InProgressDonationsProvider>(context, listen: false);
    inProgressDonationProvider.fetchInProgressDonations();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Donations In progress',
              style: TextStyle(
                  fontSize: subHeadFontSize, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ListView.builder(
            //itemCount: 20,
            itemCount: inProgressDonationProvider.inProgressDonations.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              //check for the no component if none available
               final matching = inProgressDonationProvider.inProgressDonations[index];
           
              final personName = '${matching.firstName} ${matching.lastName}';
              return ListTile(
                  title: RequestComponent(
                isSent: false,
                isMatching: false,
                isDonation: true,
                fontSize: fontSize,
                buttonFontSize: buttonFontSize,
                personName: personName,
                  // buttonHeight: buttonHeight,
                  // finishButtonHeight:finishButtonHeight ,
                  // pendingButtonHeight: pendingButtonHeight,
                  // buttonWidth:buttonWidth ,
                  // pendingButtonWidth:pendingButtonWidth ,
                  // finishButtonWidth: finishButtonWidth,
              ));
            },
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        ],
      ),
    );
  }
}
