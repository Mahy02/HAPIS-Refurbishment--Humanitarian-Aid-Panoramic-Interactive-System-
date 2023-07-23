import 'package:flutter/material.dart';

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
  const Requests(
      {super.key, required this.fontSize, required this.subHeadFontSize, required this.buttonFontSize, 
      //required this.buttonHeight, required this.finishButtonHeight, required this.pendingButtonHeight, required this.buttonWidth, required this.finishButtonWidth, required this.pendingButtonWidth
      });

  @override
  Widget build(BuildContext context) {
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
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                //check for the no component if none available
                return ListTile(
                    title: RequestComponent(
                  isSent: false,
                  isMatching: false,
                  isDonation: false,
                  fontSize: fontSize,
                  buttonFontSize: buttonFontSize,
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
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              itemCount: 30,
              itemBuilder: (context, index) {
                return ListTile(
                    title: RequestComponent(
                  isSent: true,
                  isMatching: false,
                  isDonation: false,
                  fontSize: fontSize,
                  buttonFontSize: buttonFontSize,
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
