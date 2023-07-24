import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/requests_recieved_provider.dart';
import '../providers/requests_sent_provider.dart';
import '../reusable_widgets/requests_component.dart';

class Requests extends StatelessWidget {
  final double fontSize;
  final double subHeadFontSize;
  final double buttonFontSize;
  //  final double buttonHeight;
  // final double finishButtonHeight;
  // final double pendingButtonHeight;
  //   final double buttonWidth;
  // final double finishButtonWidth;
  // final double pendingButtonWidth;
  const Requests({
    super.key,
    required this.fontSize,
    required this.subHeadFontSize,
    required this.buttonFontSize,
    //required this.buttonHeight, required this.finishButtonHeight, required this.pendingButtonHeight, required this.buttonWidth, required this.finishButtonWidth, required this.pendingButtonWidth
  });

  @override
  Widget build(BuildContext context) {
    RequestsSentProvider requestsSentProvider =
        Provider.of<RequestsSentProvider>(context, listen: false);
    RequestsReceivedProvider requestsRecProvider =
        Provider.of<RequestsReceivedProvider>(context, listen: false);
    requestsSentProvider.loadRequestsSent();
    requestsRecProvider.loadRequestsReceived();
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Requests Recieved',
              style: TextStyle(
                  fontSize: subHeadFontSize, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
              //itemCount: 20,
              itemCount: requestsRecProvider.requestsReceived.length,
              itemBuilder: (context, index) {
                //check for the no component if none available
                final requestRec = requestsRecProvider.requestsReceived[index];
                final personName =
                    '${requestRec.firstName} ${requestRec.lastName}';
                final type = requestRec.type;
                final item = requestRec.item;
                return ListTile(
                    title: RequestComponent(
                  isSent: false,
                  isMatching: false,
                  isDonation: false,
                  fontSize: fontSize,
                  buttonFontSize: buttonFontSize,
                  personName: personName,
                  type: type,
                  item: item,
                  //   buttonHeight: buttonHeight,
                  // finishButtonHeight:finishButtonHeight ,
                  // pendingButtonHeight: pendingButtonHeight,
                  // buttonWidth:buttonWidth ,
                  // pendingButtonWidth:pendingButtonWidth ,
                  // finishButtonWidth: finishButtonWidth,
                ));
              },
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Requests Sent',
              style: TextStyle(
                  fontSize: subHeadFontSize, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: ListView.builder(
              // itemCount: 30,
              itemCount: requestsSentProvider.requestsSent.length,
              itemBuilder: (context, index) {
                final requestSent = requestsSentProvider.requestsSent[index];
                final personName =
                    '${requestSent.firstName} ${requestSent.lastName}';
                final statusText = requestSent.recipientStatus;
                return ListTile(
                    title: RequestComponent(
                  isSent: true,
                  isMatching: false,
                  isDonation: false,
                  fontSize: fontSize,
                  buttonFontSize: buttonFontSize,
                  status: statusText,
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
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
}
