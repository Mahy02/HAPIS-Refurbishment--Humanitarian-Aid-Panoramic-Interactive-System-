import 'package:flutter/material.dart';
import 'package:hapis/helpers/google_signin_api.dart';
import 'package:hapis/helpers/login_session_shared_preferences.dart';
import 'package:hapis/models/db_models/get_requests_recieved_model.dart';
import 'package:hapis/models/db_models/get_requests_sent_model.dart';
import 'package:hapis/screens/google_signup.dart';
import 'package:hapis/services/db_services/requests_db_services.dart';
import '../reusable_widgets/no_component.dart';
import '../reusable_widgets/requests_component.dart';

class Requests extends StatefulWidget {
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
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  @override
  Widget build(BuildContext context) {
    String id;
    final user = GoogleSignInApi().getCurrentUser();
    if (user != null) {
      id = user.id;
    } else {
      id = LoginSessionSharedPreferences.getNormalUserID()!;
    }
    print(id);
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Requests Received',
              style: TextStyle(
                  fontSize: widget.subHeadFontSize,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          FutureBuilder<List<RequestReceivedModel>>(
              future: RequestsServices().getRequestsReceived(id),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching requests'));
                }
                final requestsRecList = snapshot.data ?? [];
                final noRequestsRec = requestsRecList.isEmpty;

                return noRequestsRec!
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Center(
                          child: NoComponentWidget(
                            displayText:
                                'You don\'t have any requests recieved',
                            icon: Icons.person_add_alt_1_rounded,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ListView.builder(
                          itemCount: requestsRecList.length,
                          itemBuilder: (context, index) {
                            final RequestReceivedModel requestRec =
                                requestsRecList[index];
                            final personName =
                                '${requestRec.firstName} ${requestRec.lastName}';
                            final type = requestRec.type;
                            final item = requestRec.item;
                            final id = requestRec.RId;
                            return ListTile(
                                title: RequestComponent(
                              isSent: false,
                              isMatching: false,
                              isDonation: false,
                              fontSize: widget.fontSize,
                              buttonFontSize: widget.buttonFontSize,
                              personName: personName,
                              type: type,
                              item: item,
                              id: id,
                              onPressed: () {
                                setState(() {});
                              },
                              //   buttonHeight: buttonHeight,
                              // finishButtonHeight:finishButtonHeight ,
                              // pendingButtonHeight: pendingButtonHeight,
                              // buttonWidth:buttonWidth ,
                              // pendingButtonWidth:pendingButtonWidth ,
                              // finishButtonWidth: finishButtonWidth,
                            ));
                          },
                        ),
                      );
              }),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          const Divider(
            thickness: 2,
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Requests Sent',
              style: TextStyle(
                  fontSize: widget.subHeadFontSize,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder<List<RequestSentModel>>(
              future: RequestsServices().getRequestsSent(id),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching requests'));
                }
                final requestsSentList = snapshot.data ?? [];
                final noRequestsSent = requestsSentList.isEmpty;

                return noRequestsSent!
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: const Center(
                          child: NoComponentWidget(
                            displayText: 'You don\'t have any requests sent',
                            icon: Icons.person_add_alt_1_rounded,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: ListView.builder(
                          itemCount: requestsSentList.length,
                          itemBuilder: (context, index) {
                            final RequestSentModel requestSent =
                                requestsSentList[index];
                            final personName =
                                '${requestSent.firstName} ${requestSent.lastName}';

                            final statusText = requestSent.recipientStatus;

                            return ListTile(
                                title: RequestComponent(
                              isSent: true,
                              isMatching: false,
                              isDonation: false,
                              fontSize: widget.fontSize,
                              buttonFontSize: widget.buttonFontSize,
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
                        ));
              }),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        ],
      ),
    );
  }
}
